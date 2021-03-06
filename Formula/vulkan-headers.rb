class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.144.tar.gz"
  sha256 "dffe7653e6233146dfe8d089d6156e82b3fed68f6de7b5bca301c767b5e61e56"

  bottle do
    cellar :any_skip_relocation
    sha256 "395bde84f955323658d6a26a1b9a5d40d5923e74714b89414eff3a1ae84b287f" => :catalina
    sha256 "395bde84f955323658d6a26a1b9a5d40d5923e74714b89414eff3a1ae84b287f" => :mojave
    sha256 "395bde84f955323658d6a26a1b9a5d40d5923e74714b89414eff3a1ae84b287f" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
