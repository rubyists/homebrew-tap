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
      sha256 "fb69278d433224416e17e1123ce3da00282935fa93ac6adb0aa3a5a5c620cc34"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_x86_64.tar.gz"
      sha256 "d353f8f9b024202780bb5c468e62d83c27ea5fcd79d6ddcb6c98d4ecfa086f4c"
    end

    on_arm do
      url "https://github.com/rubyists/linear-cli/releases/download/v#{version}/lc_linux_aarch64.tar.gz"
      sha256 "86bcde3b8c30232c423dee048e84fed22235402269c23658193f488c8d52e72a"
    end
  end

  def install
    bin.install "lc", "lcreate", "lcls", "lclose", "lcomment", "lproj"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lc --version")
  end
end
