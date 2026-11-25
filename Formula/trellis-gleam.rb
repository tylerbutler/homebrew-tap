class TrellisGleam < Formula
  desc "A workspace CLI for Gleam monorepos: task fan-out, introspection, and release orchestration derived entirely from gleam.toml"
  homepage "https://github.com/tylerbutler/trellis"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.8.0/trellis-gleam-aarch64-apple-darwin.tar.xz"
      sha256 "a4aab33d0f2846b2e473db25d455b4048d11c80da7b9720cac04db83f7476431"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.8.0/trellis-gleam-x86_64-apple-darwin.tar.xz"
      sha256 "83287de176504576610b78e51f5da4a75d9490b971fabb3ecfc0a2aff97c1bd4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.8.0/trellis-gleam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1d1a6982c3a5ded74aaed93241a51c4723f20cd39334287c9342e54a234c2a4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.8.0/trellis-gleam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "341ab1f1b1c3e57291d5fa440dfbd2fc1fd9f4a157c9184046f350e74da1b0a3"
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
