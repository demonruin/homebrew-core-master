class Libvncserver < Formula
  desc "VNC server and client libraries"
  homepage "https://libvnc.github.io"
  url "https://github.com/LibVNC/libvncserver/archive/LibVNCServer-0.9.13.tar.gz"
  sha256 "0ae5bb9175dc0a602fe85c1cf591ac47ee5247b87f2bf164c16b05f87cbfa81a"

  bottle do
    cellar :any
    sha256 "c667ff09ee40d2ab0e8db25a51697ae62edd14496c1075f07015bf0ed372695e" => :catalina
    sha256 "7e5799814cd2077d39c8d4c95806fa23c408d8a26c92140ba64f852b6a53567f" => :mojave
    sha256 "f331a9fc3ba043f0febe78df7551630a5a28f9adb362a58384901192476dff89" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libgcrypt"
  depends_on "libpng"
  depends_on "openssl@1.1"

  def install
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}
      -DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/libjpeg.dylib
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "ctest", "-V"
      system "make", "install"
    end
  end

  test do
    (testpath/"server.cpp").write <<~EOS
      #include <rfb/rfb.h>
      int main(int argc,char** argv) {
        rfbScreenInfoPtr server=rfbGetScreen(&argc,argv,400,300,8,3,4);
        server->frameBuffer=(char*)malloc(400*300*4);
        rfbInitServer(server);
        return(0);
      }
    EOS

    system ENV.cc, "server.cpp", "-I#{include}", "-L#{lib}",
                   "-lvncserver", "-lc++", "-o", "server"
    system "./server"
  end
end