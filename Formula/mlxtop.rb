class Mlxtop < Formula
  desc "Top-style monitor for local LLM servers: memory, paging and throughput"
  homepage "https://github.com/maximpri/mlxtop"
  url "https://github.com/maximpri/mlxtop/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "d3b042ab2e29040e03b790376bf207f78ddf7725a053e9047b0f8d3bc729e428"
  license "MIT"
  head "https://github.com/maximpri/mlxtop.git", branch: "main"

  bottle do
    root_url "https://github.com/maximpri/homebrew-tap/releases/download/mlxtop-3.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "97bf28e74ae093cee80309615b1ce7285fa99c2dc8861e615ca21958235ff755"
    sha256 cellar: :any,                 x86_64_linux: "991bec99b2431b774cee2b08e794dd182af8ab0b76684bb282cdbd878d40b2d7"
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
