class TrellisGleam < Formula
  desc "A workspace CLI for Gleam monorepos: task fan-out, introspection, and release orchestration derived entirely from gleam.toml"
  homepage "https://github.com/tylerbutler/trellis"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.7.0/trellis-gleam-aarch64-apple-darwin.tar.xz"
      sha256 "da149cba0c3cbc5d9967337d900330406ce4a1e9af442c834069799f809dc5d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.7.0/trellis-gleam-x86_64-apple-darwin.tar.xz"
      sha256 "92f1f89be196ea5f9894bba9fe4f95b2e9b160cef9b6440a5d36b6d2ff578fb8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.7.0/trellis-gleam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "37bbe579fef7c4c63ecec68925525a1050e2cec0bd4379f2fc93eb6b07835c6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.7.0/trellis-gleam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3f9dc5967dd540679f8d720548fa4e3e129660179c0325e9a955baf2911fdbe8"
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
