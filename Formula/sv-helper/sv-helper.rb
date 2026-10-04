class SvHelper < Formula
  desc "Manage runit services as yourself, with per-service logging"
  homepage "https://github.com/rubyists/sv-helper"
  license "MIT"

  # The one place the version lives - rubyists/sv-helper's own
  # homebrew-tap-bump workflow job writes this file directly to mirror
  # that repo's release tag exactly. Everything below interpolates from
  # it rather than repeating the version in each url, so there's nothing
  # else to keep in sync by hand.
  version File.read(File.expand_path(".version", __dir__)).chomp

  # The scripts are architecture-independent: one archive per platform,
  # repeated per architecture only because Homebrew allows a url inside
  # on_arm/on_intel but not directly inside on_macos/on_linux.
  on_macos do
    on_arm do
      url "https://github.com/rubyists/sv-helper/releases/download/v#{version}/sv-helper-darwin.tar.gz"
      sha256 "edd7082372306b95a1717d2e578099d6277991d618354d85a7140e680da50c5f"
    end

    on_intel do
      url "https://github.com/rubyists/sv-helper/releases/download/v#{version}/sv-helper-darwin.tar.gz"
      sha256 "edd7082372306b95a1717d2e578099d6277991d618354d85a7140e680da50c5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rubyists/sv-helper/releases/download/v#{version}/sv-helper-linux.tar.gz"
      sha256 "edd7082372306b95a1717d2e578099d6277991d618354d85a7140e680da50c5f"
    end

    on_intel do
      url "https://github.com/rubyists/sv-helper/releases/download/v#{version}/sv-helper-linux.tar.gz"
      sha256 "edd7082372306b95a1717d2e578099d6277991d618354d85a7140e680da50c5f"
    end
  end

  depends_on "runit"

  def install
    # The release's own installer, so the command links are exactly the
    # ones every other installation path gets.
    system "./install.sh", "install", "--prefix", prefix
    doc.install "share/doc/sv-helper/conf.example"
  end

  def caveats
    on_macos do
      <<~EOS
        sv-helper manages services in Homebrew's runit tree:
          #{HOMEBREW_PREFIX}/var/service
        To keep that tree supervised across logins:
          brew services start runit
        The supervisor logs to #{HOMEBREW_PREFIX}/var/log/runit.log, and each
        service using rsvlog logs to #{HOMEBREW_PREFIX}/var/log/<service>.
      EOS
    end
  end

  test do
    # An explicit tree and definition directory, so the test never touches
    # Homebrew's real var/service.
    ENV["SVDIR"] = (testpath/"service").to_s
    ENV["SV_SOURCE_DIR"] = (testpath/"sv").to_s
    (testpath/"service").mkpath
    (testpath/"sv/hello").mkpath
    (testpath/"sv/hello/run").write <<~SH
      #!/bin/sh
      exec sleep 1000
    SH
    chmod 0755, testpath/"sv/hello/run"

    assert_match testpath.to_s, shell_output("#{bin}/sv-helper paths")
    assert_match "hello", shell_output("#{bin}/sv-list")
    assert_equal (testpath/"sv/hello").to_s, shell_output("#{bin}/sv-find hello").chomp

    system bin/"sv-enable", "hello"
    assert_predicate testpath/"service/hello", :symlink?
    system bin/"sv-disable", "hello"
    refute_path_exists testpath/"service/hello"

    # Every alias is a link to sv-helper itself.
    %w[sv-start sv-stop sv-restart sv-list svls sv-enable sv-disable sv-find].each do |name|
      assert_equal "sv-helper", File.readlink(bin/name)
    end
  end
end
