class CopilotGo < Formula
  desc "GitHub Copilot token → OpenAI / Anthropic API proxy"
  homepage "https://github.com/Annihilater/copilot2api-go"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.1/copilot-go_v0.1.1_darwin_arm64.tar.gz"
      sha256 "95a54db08db1b3a032ee88b65f090f0a2edf7593aaaf79fbdcb8a1a4de9317a6"
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.1/copilot-go_v0.1.1_darwin_amd64.tar.gz"
      sha256 "2a182e2f2bc41631207e1af9b906c4729f8da4cf9a4e96924a29aa0c8b597cfa"
    end
  end

  on_linux do
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.1/copilot-go_v0.1.1_linux_arm64.tar.gz"
        sha256 "210aedefb9a788cef41119a218a38e02e02921afd786dc1c82910bda6c97193a"
      end
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.1/copilot-go_v0.1.1_linux_amd64.tar.gz"
      sha256 "a75de985a5b25c29e724e68444401254ace4e44c0786d64b316676b6117b9509"
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
