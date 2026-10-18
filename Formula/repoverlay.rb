class Repoverlay < Formula
  desc "Overlay config files into git repositories without committing them"
  homepage "https://github.com/tylerbutler/repoverlay"
  version "0.18.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.18.0/repoverlay-aarch64-apple-darwin.tar.xz"
      sha256 "f89a9726fc8e69f864f30fa57092b5e9fe9068aba120686dec2ebe95102a6853"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.18.0/repoverlay-x86_64-apple-darwin.tar.xz"
      sha256 "51425966364277139bce5547d2bb5486c8beeb8beaa0e18be57ed016c48a3105"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.18.0/repoverlay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d6df78733f65d94682b67d6cecab2ed0aced5f5196ebf1dd61d5191d2852b89a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.18.0/repoverlay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e47a20906a86cd6a009a60cc396f6c33a5a4d100170ca06db953676748c574f6"
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
