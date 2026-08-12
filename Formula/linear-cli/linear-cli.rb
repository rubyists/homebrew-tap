class LinearCli < Formula
  desc "CLI for interacting with Linear.app"
  homepage "https://github.com/rubyists/linear-cli"
  license "WTFPL"

  on_macos do
    on_arm do
      url "https://github.com/rubyists/linear-cli/releases/download/v1.4.0/lc_macos_aarch64.tar.gz"
      sha256 "7f63650ec3180ea8fea4ce797a59fbfc2a462f50e070ebee778ec2a0fb7c9e0e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/rubyists/linear-cli/releases/download/v1.4.0/lc_linux_x86_64.tar.gz"
      sha256 "2ab8355940245cbf6bd7fb77ea5d89e2c39cdf80de5127b371698de99a01180e"
    end
  end

  def install
    bin.install "lc", "lcreate", "lcls", "lclose", "lcomment", "lproj"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lc --version")
  end
end
