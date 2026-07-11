class TrellisGleam < Formula
  desc "A workspace CLI for Gleam monorepos: task fan-out, introspection, and release orchestration derived entirely from gleam.toml"
  homepage "https://github.com/tylerbutler/trellis"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.1.0/trellis-gleam-aarch64-apple-darwin.tar.xz"
      sha256 "9f943d722136b30de8694e4f01f5913e21e50d3f2adafc563f4443165c1cc6c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.1.0/trellis-gleam-x86_64-apple-darwin.tar.xz"
      sha256 "79b0257d54f86459c50664d27654656329a7a10c452da4b1674ecb9cbc5f7fec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.1.0/trellis-gleam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b0fe1ee76435c5cf8451b3d59ed93ad1bce3f0b4e631d86791bce7d4d474c045"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.1.0/trellis-gleam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "10f307533a0d98854e827eee3ba182bc0fd0da963577d1e2bb17ac2800623094"
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
