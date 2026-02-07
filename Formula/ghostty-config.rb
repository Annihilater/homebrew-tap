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
  end

  def post_install
    ghostty_dir = Pathname.new("#{Dir.home}/.config/ghostty")

    # 备份已有配置
    if ghostty_dir.exist?
      backup = Pathname.new("#{Dir.home}/.config/ghostty.bak.#{Time.now.strftime("%Y%m%d%H%M%S")}")
      ghostty_dir.rename(backup)
      opoo "已有配置已备份到 #{backup}"
    end

    ghostty_dir.mkpath
    cp share/"ghostty-config/config", ghostty_dir/"config"
    cp_r share/"ghostty-config/shaders", ghostty_dir/"shaders"
    cp_r share/"ghostty-config/themes", ghostty_dir/"themes"
  end

  def caveats
    <<~EOS
      配置已安装到 ~/.config/ghostty/
      如果之前有配置，已备份为 ~/.config/ghostty.bak.<timestamp>

      重启 Ghostty 或按 Cmd+Shift+R 重载配置。
    EOS
  end

  test do
    assert_predicate share/"ghostty-config/config", :exist?
  end
end
