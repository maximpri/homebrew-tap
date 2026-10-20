class Mlxtop < Formula
  desc "Top-style monitor for local LLM servers: memory, paging and throughput"
  homepage "https://github.com/maximpri/mlxtop"
  url "https://github.com/maximpri/mlxtop/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "fe0d7fb090aef42fd40311dba4fb82e69ba9e2f371f3ec1d08d66ca0d31a3a4a"
  license "MIT"
  head "https://github.com/maximpri/mlxtop.git", branch: "main"

  bottle do
    root_url "https://github.com/maximpri/homebrew-tap/releases/download/mlxtop-3.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "cefe90ccea2552bb2c95a012d485f7db69320a34d3c55d6085f1be9b48663471"
    sha256 cellar: :any,                 x86_64_linux: "9803a5ed48113cf1eab38ba60d5f5c9e8a76803f3805ef4ea3e7970cfe962a51"
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
