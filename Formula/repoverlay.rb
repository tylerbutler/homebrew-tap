class Repoverlay < Formula
  desc "Overlay config files into git repositories without committing them"
  homepage "https://github.com/tylerbutler/repoverlay"
  version "0.18.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.18.1/repoverlay-aarch64-apple-darwin.tar.xz"
      sha256 "59de94c6a1a58cd6aa9a1bf4db020c6d98ccd34f3f9adff9f8929d4c2b34d68d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.18.1/repoverlay-x86_64-apple-darwin.tar.xz"
      sha256 "4307b0c82eab753fc9c97a59c9d796c9aecfe3a9a3d9fd2d44e0275a777bc205"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.18.1/repoverlay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0dfb6e0769c01ae9bc41fc5c657e395f325bbad033c82089cefda8fa2beda5a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.18.1/repoverlay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab84db2c34e2625cbc3ff1384800a365a5c1939501346d6c645622a21e7f2ee6"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "repoverlay"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "repoverlay"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "repoverlay"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "repoverlay"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
