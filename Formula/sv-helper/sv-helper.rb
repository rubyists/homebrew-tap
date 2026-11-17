class SvHelper < Formula
  desc "Helpers for administering runit services, as root or as a regular user"
  homepage "https://github.com/rubyists/sv-helper"
  license "MIT"

  # The one place the version lives - rubyists/sv-helper's own
  # homebrew-tap-bump workflow job writes this file directly to mirror
  # that repo's release tag exactly. Everything below interpolates from
  # it rather than repeating the version in each url, so there's nothing
  # else to keep in sync by hand.
  version File.read(File.expand_path(".version", __dir__)).chomp

  # Shell scripts, so one archive per OS and no architecture anywhere.
  # The two archives carry identical contents; they are separate so each
  # records the platform it is supported on. Each url is repeated per
  # architecture only because brew style allows a url inside
  # on_arm/on_intel but not directly inside on_macos/on_linux.
  on_macos do
    on_arm do
      url "https://github.com/rubyists/sv-helper/releases/download/v#{version}/sv-helper-darwin.tar.gz"
      sha256 "7314f19639a6a8c3c98adae254b6416fe4c73e2c614bd5facc9f4b7e8232ceab"
    end

    on_intel do
      url "https://github.com/rubyists/sv-helper/releases/download/v#{version}/sv-helper-darwin.tar.gz"
      sha256 "7314f19639a6a8c3c98adae254b6416fe4c73e2c614bd5facc9f4b7e8232ceab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rubyists/sv-helper/releases/download/v#{version}/sv-helper-linux.tar.gz"
      sha256 "7314f19639a6a8c3c98adae254b6416fe4c73e2c614bd5facc9f4b7e8232ceab"
    end

    on_intel do
      url "https://github.com/rubyists/sv-helper/releases/download/v#{version}/sv-helper-linux.tar.gz"
      sha256 "7314f19639a6a8c3c98adae254b6416fe4c73e2c614bd5facc9f4b7e8232ceab"
    end
  end

  # sv, runsvdir, runsv, svlogd and chpst. On macOS this formula is also
  # what defines where services and logs live: it patches sv's default
  # service directory to #{HOMEBREW_PREFIX}/var/service and ships the
  # `brew services` definition that supervises it.
  depends_on "runit"

  def install
    # The same installer the release archive ships for everyone else,
    # pointed at the cellar. One definition of what "installed" means,
    # whether it came from Homebrew, a tarball, or packslip.
    system "./install.sh", "install", "--prefix", prefix
  end

  def caveats
    return linux_caveats unless OS.mac?

    <<~EOS
      Services are supervised from
        #{HOMEBREW_PREFIX}/var/service
      and service definitions are looked for in
        #{HOMEBREW_PREFIX}/etc/sv

      To keep a supervision tree running across logins, start runit's own
      Homebrew service, which supervises that directory and logs to
      #{HOMEBREW_PREFIX}/var/log/runit.log:

        brew services start runit

      Or run a tree in the foreground, in a terminal or under something
      else:

        runsvdir.sh

      Per-service logs default to #{HOMEBREW_PREFIX}/var/log/<service>.
      Link rsvlog as a service's log/run script to get that:

        mkdir -p #{HOMEBREW_PREFIX}/etc/sv/myservice/log
        ln -s #{HOMEBREW_PREFIX}/bin/rsvlog \\
              #{HOMEBREW_PREFIX}/etc/sv/myservice/log/run
        sv-enable myservice

      Everything runs as you. No system service configuration and no
      privilege escalation is involved.
    EOS
  end

  # On Linux a regular user's services live in their own directories,
  # exactly as they do for an sv-helper installed any other way. Being
  # installed by Homebrew does not move them under Homebrew's prefix.
  def linux_caveats
    <<~EOS
      Services are supervised from
        ${XDG_STATE_HOME:-$HOME/.local/state}/sv-helper/service
      and service definitions are looked for in
        ${XDG_CONFIG_HOME:-$HOME/.config}/sv-helper/sv
      with per-service logs under
        ${XDG_STATE_HOME:-$HOME/.local/state}/sv-helper/log

      Start a supervision tree with:

        runsvdir.sh

      Run it as a service of whatever supervises your login session, or
      from your system's runit if you have one. Everything runs as you;
      no privilege escalation is involved.

      As root, the usual system locations are used instead: /etc/sv for
      definitions and /var/service, /service or /etc/service for the
      tree.
    EOS
  end

  test do
    # Each helper is a link to sv-helper, which dispatches on the name it
    # was invoked by. If the links were installed as copies, or pointed
    # somewhere absolute that the cellar move broke, this is what catches
    # it.
    %w[sv-start sv-stop sv-restart sv-list svls sv-enable sv-disable sv-find].each do |command|
      assert_predicate bin/command, :symlink?
      assert_equal "sv-helper", (bin/command).readlink.to_s
    end

    assert_match "svls", shell_output("#{bin}/svls -h")
    assert_match "sv-enable", shell_output(bin/"sv-helper")

    # Which paths are correct depends on the platform, and the point of
    # checking is that it picks the right set. macOS runs on Homebrew's
    # runit, so the tree and the definitions live under Homebrew's
    # prefix. On Linux, including Homebrew on Linux, a regular user's
    # services belong in their own XDG directories - sv-helper being
    # installed by Homebrew does not change where a user's services go.
    paths = shell_output("#{bin}/sv-helper paths")
    if OS.mac?
      assert_match "#{HOMEBREW_PREFIX}/var/service", paths
      assert_match "#{HOMEBREW_PREFIX}/etc/sv", paths
    else
      assert_match "sv-helper/service", paths
      assert_match "sv-helper/sv", paths
      refute_match "#{HOMEBREW_PREFIX}/var/service", paths
    end

    # An explicit tree is honoured over the default, which is what makes
    # a second, separate supervision tree possible alongside the one
    # `brew services start runit` manages.
    (testpath/"tree").mkpath
    assert_match (testpath/"tree").to_s,
                 shell_output("SVDIR=#{testpath}/tree #{bin}/sv-helper paths")

    # Listing works before any service exists, rather than failing
    # because there is nothing to list yet.
    assert_equal "", shell_output("SVDIR=#{testpath}/tree #{bin}/sv-list").strip

    # rsvlog refuses to run anywhere but a service's log directory.
    assert_match "log directory", shell_output("#{bin}/rsvlog 2>&1", 1)

    # Enabling and disabling a definition really changes the tree.
    (testpath/"sv/hello").mkpath
    (testpath/"sv/hello/run").write "#!/bin/sh\nexec sleep 1000\n"
    chmod 0755, testpath/"sv/hello/run"
    with_env(SVDIR: "#{testpath}/tree", SV_SOURCE_DIR: "#{testpath}/sv") do
      assert_equal (testpath/"sv/hello").to_s, shell_output("#{bin}/sv-find hello").chomp
      system bin/"sv-enable", "hello"
      assert_predicate testpath/"tree/hello", :symlink?
      system bin/"sv-disable", "hello"
      refute_path_exists testpath/"tree/hello"
    end
  end
end
