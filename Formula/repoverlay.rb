class Repoverlay < Formula
  desc "Overlay config files into git repositories without committing them"
  homepage "https://github.com/tylerbutler/repoverlay"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.5.0/repoverlay-aarch64-apple-darwin.tar.xz"
      sha256 "dd9599cd6d4a69e9f632c4bc388b4398d8ca768575b798a3e8613130e4cae92c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.5.0/repoverlay-x86_64-apple-darwin.tar.xz"
      sha256 "b7abfd6620dae835ca0378ffbf4b2e23f286faaac20f848cc88c32c840b54c15"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.5.0/repoverlay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28bb9301d0c5c2ef731c7a07a1c2ed859f7f0ce6b9edf85f9a0e845ad4d797c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.5.0/repoverlay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "894621194c0fc3dbc027829f146e9c3f9dab0cbf0093bda978237f51087cea78"
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
