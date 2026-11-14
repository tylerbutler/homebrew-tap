class TrellisGleam < Formula
  desc "A workspace CLI for Gleam monorepos: task fan-out, introspection, and release orchestration derived entirely from gleam.toml"
  homepage "https://github.com/tylerbutler/trellis"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.6.0/trellis-gleam-aarch64-apple-darwin.tar.xz"
      sha256 "7eab2b5f3d0ab8d90f72c718a20149eaefe9d9af40c298020633d0b07561e0b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.6.0/trellis-gleam-x86_64-apple-darwin.tar.xz"
      sha256 "dba1fe71f82388665271d4283a90785c958aecf2dc7671d0a449ad46da68b0b5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.6.0/trellis-gleam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "74c5ff373b482e7b37f961409d2e7476a2c288d7a780ef9100ef4603f0cb51b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.6.0/trellis-gleam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f22cebe41eeaf344b20a95162ced0c1725a15411fe2c0502283456c1ba2e5053"
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
