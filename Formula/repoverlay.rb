class Repoverlay < Formula
  desc "Overlay config files into git repositories without committing them"
  homepage "https://github.com/tylerbutler/repoverlay"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.6.0/repoverlay-aarch64-apple-darwin.tar.xz"
      sha256 "55c7325aefba8a16cb7b44366a86c9855df8da6bf0622cf86758f2ae5a11c3c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.6.0/repoverlay-x86_64-apple-darwin.tar.xz"
      sha256 "617ba92ff008616d3c95e622798c58f4c352daf87505d9cbf92cf9d000f1a646"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.6.0/repoverlay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "998de19d8152739e9b138baecff719a386878587422e0ea2e0544fdbb4920dbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.6.0/repoverlay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "101f657b826ec464d5c9bf2ca4533aa88769cb94f6bf58412ba7e728d7fdaa18"
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
