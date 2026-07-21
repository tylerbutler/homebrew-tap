class TrellisGleam < Formula
  desc "A workspace CLI for Gleam monorepos: task fan-out, introspection, and release orchestration derived entirely from gleam.toml"
  homepage "https://github.com/tylerbutler/trellis"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.5.0/trellis-gleam-aarch64-apple-darwin.tar.xz"
      sha256 "ebe8dbca1720b7d30da3010e3f444d89eacc21b1878a17e345b3e3072c8fa261"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.5.0/trellis-gleam-x86_64-apple-darwin.tar.xz"
      sha256 "fdd6ac6841de2e8eb6aab53ce1a12fc6c95724ed16fbc797162d8a6c1d7249fb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.5.0/trellis-gleam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "394775586ceaf82e39c8e7289c08a3a2fab4614764836e667dd261e4dd593f88"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.5.0/trellis-gleam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8ca022bf6b058922bd5b61e1726d86475dc26100397e210b3b4a7876489caa51"
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
    bin.install "trellis" if OS.mac? && Hardware::CPU.arm?
    bin.install "trellis" if OS.mac? && Hardware::CPU.intel?
    bin.install "trellis" if OS.linux? && Hardware::CPU.arm?
    bin.install "trellis" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
