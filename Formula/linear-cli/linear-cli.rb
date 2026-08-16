class LinearCli < Formula
  desc "CLI for interacting with Linear.app"
  homepage "https://github.com/rubyists/linear-cli"
  license "WTFPL"

  # The one place the version lives - rubyists/linear-cli's own
  # homebrew-tap-bump workflow job writes this file directly to mirror
  # that repo's release tag exactly. Everything below interpolates from
  # it rather than repeating the version in each url, so there's nothing
  # else to keep in sync by hand.
  version File.read(File.expand_path(".version", __dir__)).chomp

  on_macos do
    on_arm do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_macos_aarch64.tar.gz"
      sha256 "732111ca0186f669d8d7ff99ad214e1e9d9f2cb02576e8c0ae1e8811fb4f5ec1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_x86_64.tar.gz"
      sha256 "044e2985471441f1ae000047d59db692f6eafc60ea139e8a2f919814dab2004d"
    end
  end

  def install
    bin.install "lc", "lcreate", "lcls", "lclose", "lcomment", "lproj"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lc --version")
  end
end
