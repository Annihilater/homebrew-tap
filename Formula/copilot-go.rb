class CopilotGo < Formula
  desc "GitHub Copilot token → OpenAI / Anthropic API proxy"
  homepage "https://github.com/Annihilater/copilot2api-go"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.0/copilot-go_v0.1.0_darwin_arm64.tar.gz"
      sha256 "1eeb7bad9e545f2d5cf0badb2360f8f7cb3fc5fd8093b08f6b967c773e2bbba6"
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.0/copilot-go_v0.1.0_darwin_amd64.tar.gz"
      sha256 "374cfedb6c807f6aac847e1434dccdfee24afd52a4e0e720ffda8de223c3801c"
    end
  end

  on_linux do
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.0/copilot-go_v0.1.0_linux_arm64.tar.gz"
        sha256 "dc6b8daf5fb463c07475b7da617ca6a622abb89a3cb6cc5a4da77f4936f66d4c"
      end
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.0/copilot-go_v0.1.0_linux_amd64.tar.gz"
      sha256 "8ffb19a0998312c1460290bbe35c721ab0e30961479a8a5350295afeb01ed857"
    end
  end

  def install
    libexec.install "copilot-go"
    libexec.install "web"
    (bin/"copilot-go").write <<~SH
      #!/bin/bash
      cd "#{libexec}" && exec "#{libexec}/copilot-go" "$@"
    SH
  end

  service do
    run [opt_bin/"copilot-go", "--web-port=37000", "--proxy-port=34141"]
    keep_alive true
    working_dir libexec
    log_path var/"log/copilot-go.log"
    error_log_path var/"log/copilot-go.log"
  end

  test do
    port = free_port
    pid = fork { exec opt_bin/"copilot-go", "--web-port=#{port}", "--proxy-port=#{free_port}" }
    sleep 1
    assert_match "200", shell_output("curl -s -o /dev/null -w '%{http_code}' http://localhost:#{port}/api/config")
  ensure
    Process.kill("TERM", pid) rescue nil
  end
end
