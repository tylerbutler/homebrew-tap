class TrellisGleam < Formula
  desc "A workspace CLI for Gleam monorepos: task fan-out, introspection, and release orchestration derived entirely from gleam.toml"
  homepage "https://github.com/tylerbutler/trellis"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.1.0/trellis-gleam-aarch64-apple-darwin.tar.xz"
      sha256 "4aad39846f99e6e1f1d0acc3b44f9cae1d163e88118c7c2aed918641385a7526"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.1.0/trellis-gleam-x86_64-apple-darwin.tar.xz"
      sha256 "793abdc5aff1285794b1d08e03cf26f3fa043456ce3fa455166cfe1ac75e62a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.1.0/trellis-gleam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "611495a52de294dd0a77f3f49f41707eb514d092c58511c344d1a1401257a862"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/trellis/releases/download/v1.1.0/trellis-gleam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "217c7b312ed165b726d94a1ff4531be89cbbb215c161cdba381acb7d8f35f6b5"
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
