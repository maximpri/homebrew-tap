class Mlxtop < Formula
  desc "Top-style monitor for local LLM servers: memory, paging and throughput"
  homepage "https://github.com/maximpri/mlxtop"
  url "https://github.com/maximpri/mlxtop/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "a0a4aba5a1b06515e9bdd7639d66684190e8483e18f8f8c414bb8ad12572a2d0"
  license "MIT"
  head "https://github.com/maximpri/mlxtop.git", branch: "main"

  bottle do
    root_url "https://github.com/maximpri/homebrew-tap/releases/download/mlxtop-3.1.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "22571f289cfb872d68856737f3383336fc7d4c3b1c57a650f0b1652411f9aab5"
    sha256 cellar: :any,                 x86_64_linux: "363b2b9acc06d1eb668dffc04df402fd05e5cc79cb8864a37cf686b266306bdd"
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
