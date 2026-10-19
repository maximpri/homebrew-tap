class Mlxtop < Formula
  desc "Top-style monitor for local LLM servers: memory, paging and throughput"
  homepage "https://github.com/maximpri/mlxtop"
  url "https://github.com/maximpri/mlxtop/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "c2eb22810374fe130b37423a19a7f3a69445c922086acb626a14d22c44097aa5"
  license "MIT"
  head "https://github.com/maximpri/mlxtop.git", branch: "main"

  bottle do
    root_url "https://github.com/maximpri/homebrew-tap/releases/download/mlxtop-3.0.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "ad0e8bc648463a2757e51022d86c785faac0c86e030c4aaf0dfa4f4ec611fce8"
    sha256 cellar: :any,                 x86_64_linux: "9bc5c6b981518e720f7f80b6fd1da1464951fb1aadf47b4a9e6a9493a33827ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "scripts/record_usage.py"
  end

  def caveats
    <<~EOS
      Run `mlxtop` in a terminal, or `mlxtop doctor` to check the runtime connection.
      The client usage recorder is installed at:
        #{opt_pkgshare}/record_usage.py
    EOS
  end

  test do
    assert_match "mlxtop #{version}", shell_output("#{bin}/mlxtop --version")
    assert_match "Usage: mlxtop", shell_output("#{bin}/mlxtop --help")
    # A static report samples the host without a terminal UI.
    assert_match "PRESSURE", shell_output("#{bin}/mlxtop --once --interval 1")
  end
end
