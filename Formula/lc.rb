class Lc < Formula
  desc "CLI for interacting with Linear.app"
  homepage "https://github.com/rubyists/linear-cli-ex"
  license "WTFPL"

  on_macos do
    on_arm do
      url "https://github.com/rubyists/linear-cli-ex/releases/download/v1.0.0/lc_macos_aarch64.tar.gz"
      sha256 "977f8099f748f34cee355c72d99db22c574000b4c2f8e74be85a05fc612189fc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/rubyists/linear-cli-ex/releases/download/v1.0.0/lc_linux_x86_64.tar.gz"
      sha256 "a538bef611950424fe7d484d484ec972fff57016a178c9a965e48ae9047787e4"
    end
  end

  def install
    bin.install "lc", "lcreate", "lcls", "lclose", "lcomment", "lproj"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lc --version")
  end
end
