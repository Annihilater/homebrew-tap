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

    # 生成便捷命令，用户执行 ghostty-config-install 即可完成部署
    (bin/"ghostty-config-install").write <<~SCRIPT
      #!/usr/bin/env bash
      set -euo pipefail
      SRC="#{share}/ghostty-config"
      CONFIG_DIR="${HOME}/.config/ghostty"
      if [ -e "${CONFIG_DIR}" ]; then
        BACKUP="${CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
        echo "==> 已有配置，备份到: ${BACKUP}"
        mv "${CONFIG_DIR}" "${BACKUP}"
      fi
      mkdir -p "${CONFIG_DIR}"
      cp "${SRC}/config" "${CONFIG_DIR}/config"
      cp -r "${SRC}/shaders" "${CONFIG_DIR}/shaders"
      cp -r "${SRC}/themes" "${CONFIG_DIR}/themes"
      echo "==> 安装完成: ${CONFIG_DIR}"
      echo "==> 重启 Ghostty 或按 Cmd+Shift+R 重载配置"
    SCRIPT
  end

  def caveats
    <<~EOS
      安装完成后请执行以下命令部署配置到 ~/.config/ghostty/:

        ghostty-config-install

      如果之前有配置，会自动备份为 ~/.config/ghostty.bak.<timestamp>
      重启 Ghostty 或按 Cmd+Shift+R 重载配置。
    EOS
  end

  test do
    assert_predicate share/"ghostty-config/config", :exist?
    assert_predicate bin/"ghostty-config-install", :exist?
  end
end
