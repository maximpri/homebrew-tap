class Mlxtop < Formula
  desc "Top-style monitor for local LLM servers: memory, paging and throughput"
  homepage "https://github.com/maximpri/mlxtop"
  url "https://github.com/maximpri/mlxtop/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "a0a4aba5a1b06515e9bdd7639d66684190e8483e18f8f8c414bb8ad12572a2d0"
  license "MIT"
  head "https://github.com/maximpri/mlxtop.git", branch: "main"

  bottle do
    root_url "https://github.com/maximpri/homebrew-tap/releases/download/mlxtop-3.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "2727341631ef9ee21b672c96b737ff3f3e1ec6f544cc53c2b4b1538c37262026"
    sha256 cellar: :any,                 x86_64_linux: "571bb701c952b4b3a4589014046d9c53f0e2dc70203f798d9f8b07ab5ee76742"
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
