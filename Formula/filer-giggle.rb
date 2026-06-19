class FilerGiggle < Formula
  desc "FILER-customized GIGGLE interval search/indexing tool"
  homepage "https://github.com/pkuksa/FILER_giggle"
  url "https://github.com/pkuksa/FILER_giggle/archive/refs/tags/v0.6.3fsbv.tar.gz"
  sha256 "d8e0a30af6d4c5b0524055e379afd95b4f9973184b90bb2e931f41e20f0fb461"
  license "MIT"

  depends_on "bzip2"
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "xz"
  depends_on "zlib"

  def install
    if OS.mac?
      # system "make", "clean"
      system "make", "-f", "Makefile.macos"
    else
      system "make"
    end

    bin.install "bin/giggle" => "giggle"
  end

  test do
    output = shell_output("#{bin}/giggle search 2>&1 || true")
    assert_match "usage:", output
    assert_match "giggle", output
  end
end
