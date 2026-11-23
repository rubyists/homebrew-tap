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
      sha256 "19f16b55a7efcfba81372a98b08c593de247a0c80446bea1e51751954833948a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_x86_64.tar.gz"
      sha256 "01a758370b4edf367720436d409845ea585b5a94a843f44526ef6e68aae6a6d8"
    end

    on_arm do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_aarch64.tar.gz"
      sha256 "8d4e48ed38a9e59d37c1482b1853bf3deb2cb9ceed093b4b3781c61c386fc3b5"
    end
  end

  def install
    bin.install "lc", "lcreate", "lcls", "lclose", "lcomment", "lproj"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lc --version")
  end
end
