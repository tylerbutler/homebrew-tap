class Repoverlay < Formula
  desc "Overlay config files into git repositories without committing them"
  homepage "https://github.com/tylerbutler/repoverlay"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.3.1/repoverlay-aarch64-apple-darwin.tar.xz"
      sha256 "c867009bf96f0ae350a6a09cb190fce7d9239a8ae4f8826f7b76b8110ced9430"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.3.1/repoverlay-x86_64-apple-darwin.tar.xz"
      sha256 "593db386db7bfecd24399b129aa2f600fb752ee85e6ce1e67ee35e1b6e730681"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.3.1/repoverlay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a0574b0608c6bcdfa5e0275f1521d28648dfafe7d60e13acfc1ed8b13cecb76"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.3.1/repoverlay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7bb0e6fcb9f92ffb563e0193299e0c7a6773827b2da7d12311ee808c643d539f"
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
