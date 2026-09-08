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
      sha256 "5ddb227346fa9a950c50c967aad3b54cdde80e44b6c6c6cc4bfdc9a416a09305"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_x86_64.tar.gz"
      sha256 "12322dde878af54336e8be6f9cc29c7795b4c9f27c10f0751f6777cd8f55ccba"
    end

    on_arm do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_aarch64.tar.gz"
      sha256 "fd04b01f81fbb80a379088fdf33e4be67dbad7cf7be7f5fb5fd90d0a3d82f9dc"
    end
  end

  def install
    bin.install "lc", "lcreate", "lcls", "lclose", "lcomment", "lproj"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lc --version")
  end
end
