class TrellisGleam < Formula
  desc "A workspace CLI for Gleam monorepos: task fan-out, introspection, and release orchestration derived entirely from gleam.toml"
  homepage "https://github.com/tylerbutler/trellis"
  version "0.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.10.1/trellis-gleam-aarch64-apple-darwin.tar.xz"
      sha256 "d4327bfa20ca0dde364a4fe9096fe7e9dca4cf23375b73472989436f451ab9b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.10.1/trellis-gleam-x86_64-apple-darwin.tar.xz"
      sha256 "83bfd8487c733257a2332f74f518f0ba3d9e697b83cdcbf48ddf854024e8414a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.10.1/trellis-gleam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "db0a6b9baeb3ece053e497ab7e1e0e5a8ca80b9bee9e41df5d00ab3c99df49fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.10.1/trellis-gleam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19c9d3594692c89bce0f4242d0d5df2370a09d5581fd3a821ba2f9ed75f131c7"
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
