class TrellisGleam < Formula
  desc "A workspace CLI for Gleam monorepos: task fan-out, introspection, and release orchestration derived entirely from gleam.toml"
  homepage "https://github.com/tylerbutler/trellis"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.6.1/trellis-gleam-aarch64-apple-darwin.tar.xz"
      sha256 "999c87f64e787c91ccea724585a80f6093326652ad79f85ee8e0a24478e691dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.6.1/trellis-gleam-x86_64-apple-darwin.tar.xz"
      sha256 "0c41bd08feed7417c4573c729c03e81f7afdad42fb3e094ec858394a1021bddc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.6.1/trellis-gleam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20245ac2735acfd031a28c07cb9cc293d87efbd7a8bc5b73f5a12b494df7b96a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.6.1/trellis-gleam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fc35fd862a9968a2a4f7ddeffdd4823d49ba796afc86d6e5d0d03c4c24b95bd4"
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
      bin.install "trellis"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "trellis"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "trellis"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "trellis"
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
