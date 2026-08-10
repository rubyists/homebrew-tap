class Lc < Formula
  desc "CLI for interacting with Linear.app"
  homepage "https://github.com/rubyists/linear-cli-ex"
  license "WTFPL"

  on_macos do
    on_arm do
      url "https://github.com/rubyists/linear-cli-ex/releases/download/v0.8.1/lc_macos_aarch64.tar.gz"
      sha256 "c485b50e7eeba82ec5488d14a850d6588ca0f8fca7f2c47ecb9e2ca5867e87e2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/rubyists/linear-cli-ex/releases/download/v0.8.1/lc_linux_x86_64.tar.gz"
      sha256 "728a285b1cd870121c26673d21969ac2977ed23a12e4c4f064b83a23fe1d257b"
    end
  end

  def install
    bin.install "lc", "lcreate", "lcls", "lclose", "lcomment", "lproj"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lc --version")
  end
end
