class TrellisGleam < Formula
  desc "A workspace CLI for Gleam monorepos: task fan-out, introspection, and release orchestration derived entirely from gleam.toml"
  homepage "https://github.com/tylerbutler/trellis"
  version "1.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.2.3/trellis-gleam-aarch64-apple-darwin.tar.xz"
      sha256 "1fe2e0e04c1288c1f2558afbb42bb11f89461d9387ce647b673d3fa3344a6957"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.2.3/trellis-gleam-x86_64-apple-darwin.tar.xz"
      sha256 "73e6652ab8e792df3535685d8a44bae8584b2a53dd75fdcd40fc664c10333e7d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.2.3/trellis-gleam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f4f438fc234b941470a7ae0c5a8b2fb0582f9b3a96a322814c192b8f9edb7315"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.2.3/trellis-gleam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e5baba619bb854e54e64486b7c8e30c46b3c988f172291993a7d79f3d751f48f"
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
