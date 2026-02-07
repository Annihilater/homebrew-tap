class GhosttyConfig < Formula
  desc "Annihilater's Ghostty terminal configuration with shaders and themes"
  homepage "https://github.com/Annihilater/my-ghostty-config"
  url "https://github.com/Annihilater/my-ghostty-config/archive/refs/heads/master.tar.gz"
  version "1.0.0"
  license "MIT"

  def install
    (share/"ghostty-config").install "config"
    (share/"ghostty-config").install "shaders"
    (share/"ghostty-config").install "themes"
    (share/"ghostty-config").install "install.sh"
  end

  def post_install
    src = share/"ghostty-config"
    system "bash", "-c", <<~SCRIPT
      set -euo pipefail
      CONFIG_DIR="${HOME}/.config/ghostty"
      if [ -e "${CONFIG_DIR}" ]; then
        BACKUP="${CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
        mv "${CONFIG_DIR}" "${BACKUP}"
      fi
      mkdir -p "${CONFIG_DIR}"
      cp "#{src}/config" "${CONFIG_DIR}/config"
      cp -r "#{src}/shaders" "${CONFIG_DIR}/shaders"
      cp -r "#{src}/themes" "${CONFIG_DIR}/themes"
    SCRIPT
  end

  def caveats
    <<~EOS
      配置已安装到 ~/.config/ghostty/
      如果之前有配置，已备份为 ~/.config/ghostty.bak.<timestamp>

      如果自动安装失败，可手动执行：
        bash #{share}/ghostty-config/install.sh

      重启 Ghostty 或按 Cmd+Shift+R 重载配置。
    EOS
  end

  test do
    assert_predicate share/"ghostty-config/config", :exist?
  end
end
