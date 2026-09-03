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
      sha256 "904b2935c309cd0a41eb00102f80a2729e16bda8942b5083ec9417d7365e6f1d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_x86_64.tar.gz"
      sha256 "8a00230a6b6b5fb77997f894d0ee12a0624f645ea4727322bbcc275272237f02"
    end

    on_arm do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_aarch64.tar.gz"
      sha256 "8bf6241da7fc45501da6fa89c57f8f8b30a7bec09c34f3a1d91485088d6c4e5f"
    end
  end

  def install
    bin.install "lc", "lcreate", "lcls", "lclose", "lcomment", "lproj"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lc --version")
  end
end
