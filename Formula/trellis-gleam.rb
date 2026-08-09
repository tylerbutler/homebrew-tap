class TrellisGleam < Formula
  desc "A workspace CLI for Gleam monorepos: task fan-out, introspection, and release orchestration derived entirely from gleam.toml"
  homepage "https://github.com/tylerbutler/trellis"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.11.0/trellis-gleam-aarch64-apple-darwin.tar.xz"
      sha256 "16dfaaebbbc955fadc6f69d3aefcde87bfb62eef4b12040a08e92c56866e4b82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.11.0/trellis-gleam-x86_64-apple-darwin.tar.xz"
      sha256 "7bbdf7893fee933ac67858acff1b8cee3055a667a29123eb0e77db7f457406b7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.11.0/trellis-gleam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c760621862ff218a04360e604bb59c645bb15c5631fe3a3c3137d9de94c3de62"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v0.11.0/trellis-gleam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "316c10c2a09e3121eff5b8d55e3b291af2b297ef61f854d168b6258cb50a8f9d"
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
