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
      sha256 "8ed57774e0acb60d9de69fa66f57946d005651b2739ecac1b0633b3a03e04e58"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_x86_64.tar.gz"
      sha256 "65d73af0ffa7c64e4241663c79e9996a3d2d307b00fd3dc1a3710f06b858f144"
    end

    on_arm do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_aarch64.tar.gz"
      sha256 "5de962aaec826d712fe849dbc133692bca51e2d2ae0f9460cb7cdd113d207441"
    end
  end

  def install
    bin.install "lc", "lcreate", "lcls", "lclose", "lcomment", "lproj"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lc --version")
  end
end
