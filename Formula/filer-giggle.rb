class FilerGiggle < Formula
  desc "FILER-customized GIGGLE interval search/indexing tool"
  homepage "https://github.com/pkuksa/FILER_giggle"
  url "https://github.com/pkuksa/FILER_giggle/archive/refs/tags/v0.6.3fsbv.tar.gz"
  sha256 "d8e0a30af6d4c5b0524055e379afd95b4f9973184b90bb2e931f41e20f0fb461"
  license "MIT"

  depends_on "zlib"

  on_macos do
    depends_on "bzip2"
    depends_on "curl"
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    if OS.mac?
      system "make", "-f", "Makefile.macos"
    else
      arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"
      triplet = "#{arch}-pc-linux-gnu"

      inreplace "Makefile", "--host=x86_64", ""
      inreplace "Makefile", "./configure", "CC=/usr/bin/gcc ./configure --build=#{triplet} --host=#{triplet}"

      ENV.deparallelize

      inreplace "src/Makefile", /\bgcc\b/, "/usr/bin/gcc"

      inreplace "src/Makefile" do |s|
        s.gsub! "-L/usr/local/opt/openssl/lib", ""
        s.gsub! "-L/opt/local/lib", ""
        s.gsub! "-lcurl", ""
        s.gsub! "-lcrypto", ""
      end

      system "make"
    end

    bin.install "bin/giggle" => "giggle"
  end

  test do
    output = shell_output("#{bin}/giggle search 2>&1", 1)
    assert_match "giggle, v0.6.3fsbv", output
    assert_match "usage:   giggle search -i <index directory>", output
  end
end
