class Repoverlay < Formula
  desc "Overlay config files into git repositories without committing them"
  homepage "https://github.com/tylerbutler/repoverlay"
  version "0.17.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.17.1/repoverlay-aarch64-apple-darwin.tar.xz"
      sha256 "7cfc3888acb6480873be112f473a50cd79f566f2251da960e7e89875c26779fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.17.1/repoverlay-x86_64-apple-darwin.tar.xz"
      sha256 "0c25ccf4c036fbabeb6e470a31686aefcae321778fef219196e6428604021c5a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.17.1/repoverlay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "631051e953d7542187645412fc04e85ace149121f78c7ef9eb6a2ebd1a08aeab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tylerbutler/repoverlay/releases/download/v0.17.1/repoverlay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a8695fb3f39881769585bdf02b3f7679ede6fb03ca10518e6a3f9ffc7f2de6f3"
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
      bin.install "repoverlay"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "repoverlay"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "repoverlay"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "repoverlay"
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
