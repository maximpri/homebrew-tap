class Mlxtop < Formula
  desc "Top-style monitor for local LLM servers: memory, paging and throughput"
  homepage "https://github.com/maximpri/mlxtop"
  url "https://github.com/maximpri/mlxtop/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "27a858b1d6f25470c23468f37c70b1074fa039c06de63317d0338662e8dfde1e"
  license "MIT"
  head "https://github.com/maximpri/mlxtop.git", branch: "main"

  bottle do
    root_url "https://github.com/maximpri/homebrew-tap/releases/download/mlxtop-3.4.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "c47cf12a981098fd98e505a89bafaaffa5c0328ab2037fc9d9f8a1f0e2a7ada2"
    sha256 cellar: :any,                 x86_64_linux: "d8eacbaa55f20e42bacb592d98b04a234bea72e887a99e457a7fb8bfa846bd2a"
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
