class Mlxtop < Formula
  desc "Top-style monitor for local LLM servers: memory, paging and throughput"
  homepage "https://github.com/maximpri/mlxtop"
  url "https://github.com/maximpri/mlxtop/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "f642f3f2c48df8c31020f30ee0127b2cfab74b635f0d787d98bb6b226b405110"
  license "MIT"
  head "https://github.com/maximpri/mlxtop.git", branch: "main"

  bottle do
    root_url "https://github.com/maximpri/homebrew-tap/releases/download/mlxtop-2.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "97c4eb8507a83e1cd08f310bf1fa5f767dbdeab6797e19cd5905cb13de951668"
    sha256 cellar: :any,                 x86_64_linux: "842819c4b66c48135d7e6242153c557fe57e9599a469d358e76689e26b16d36d"
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
