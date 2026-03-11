class Copilot2apiGo < Formula
  desc "GitHub Copilot token → OpenAI / Anthropic API proxy"
  homepage "https://github.com/Annihilater/copilot2api-go"
  version "0.1.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.3/copilot-go_v0.1.3_darwin_arm64.tar.gz"
      sha256 "ed7fbf7704b4c01fd8b251a6cb9c1b6e8c6e427f7838b8383cb5428b48fe7fcf"
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.3/copilot-go_v0.1.3_darwin_amd64.tar.gz"
      sha256 "f681d43f7c35b884361997fd4a4278e837f4f69145ccccd359d04ad7afb7bfe9"
    end
  end

  on_linux do
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.3/copilot-go_v0.1.3_linux_arm64.tar.gz"
        sha256 "e807237f42112636c621c28fcfd94f267166456379f56b8d30f658895fa6419e"
      end
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.3/copilot-go_v0.1.3_linux_amd64.tar.gz"
      sha256 "985e1d3a54980d9d16897cb3058994c36b27d911ae12d4ec022a38210dfbb519"
    end
  end

  def install
    libexec.install "copilot-go"
    libexec.install "web"
    (bin/"copilot2api-go").write <<~SH
      #!/bin/bash
      cd "#{libexec}" && exec "#{libexec}/copilot-go" "$@"
    SH
  end

  service do
    run [opt_bin/"copilot2api-go", "--web-port=37000", "--proxy-port=34141"]
    keep_alive true
    working_dir libexec
    log_path var/"log/copilot2api-go.log"
    error_log_path var/"log/copilot2api-go.log"
  end

  test do
    port = free_port
    pid = fork { exec opt_bin/"copilot2api-go", "--web-port=#{port}", "--proxy-port=#{free_port}" }
    sleep 1
    assert_match "200", shell_output("curl -s -o /dev/null -w '%{http_code}' http://localhost:#{port}/api/config")
  ensure
    Process.kill("TERM", pid) rescue nil
  end
end
