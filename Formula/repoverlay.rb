class Repoverlay < Formula
  desc "Overlay config files into git repositories without committing them"
  homepage "https://github.com/tylerbutler/repoverlay"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.16.0/repoverlay-aarch64-apple-darwin.tar.xz"
      sha256 "b72d571acb7fe670418e91d8410ffe83fff6bc340ab9278ca6150ed3a1705edc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.16.0/repoverlay-x86_64-apple-darwin.tar.xz"
      sha256 "fd0491e4b325c33529ef7c64777b266dd27f7868891a9bf0886123c41fa4a6ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.16.0/repoverlay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "52f73f6f60d4ffe04e78229ab353274e30e88efdfc1170616654d11dbfa62853"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.16.0/repoverlay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab8c7bc4c77d400f9d489eb7453766801943d6ada48aebaf5bd1a6302f242197"
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
