class Repoverlay < Formula
  desc "Overlay config files into git repositories without committing them"
  homepage "https://github.com/tylerbutler/repoverlay"
  version "0.14.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.14.2/repoverlay-aarch64-apple-darwin.tar.xz"
      sha256 "3e4170e580dcc70e620b5e606122f009f901dbd65e20d9dd706a0f9d51a87fb3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.14.2/repoverlay-x86_64-apple-darwin.tar.xz"
      sha256 "e50aff9d261ab4623b0510736b2489a88b2f3bcaee9b39c4cd609b8ca94943ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.14.2/repoverlay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c14498482b295c51f8721d606fe1ec1714fadf8e4d6b3e0f521701e2dd5c3a66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.14.2/repoverlay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cd7729fafde72acfd1cf6ffc50f0116353c39268a5af9d9f484dc0220f24f577"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "repoverlay" if OS.mac? && Hardware::CPU.arm?
    bin.install "repoverlay" if OS.mac? && Hardware::CPU.intel?
    bin.install "repoverlay" if OS.linux? && Hardware::CPU.arm?
    bin.install "repoverlay" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
