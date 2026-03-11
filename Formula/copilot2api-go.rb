class Copilot2apiGo < Formula
  desc "GitHub Copilot token → OpenAI / Anthropic API proxy"
  homepage "https://github.com/Annihilater/copilot2api-go"
  version "0.1.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.4/copilot-go_v0.1.4_darwin_arm64.tar.gz"
      sha256 "dfb8887e4d9532b80d6d24357535a8478bb207c4dd00171ad67ea8cca9fbaf8d"
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.4/copilot-go_v0.1.4_darwin_amd64.tar.gz"
      sha256 "97a5e883617e4050f20bd15911aba82ba80a94b9162f8d89c74c9df3217e1b68"
    end
  end

  on_linux do
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.4/copilot-go_v0.1.4_linux_arm64.tar.gz"
        sha256 "3a7698d22ef4af2afa1bf37da4a9836c224ed873de4da7697b8f989d1567ba70"
      end
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.4/copilot-go_v0.1.4_linux_amd64.tar.gz"
      sha256 "50bace7f66c3e470e73ab4c5ac2349d00777a7e934ba7186cc6444b3fa8ba43d"
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
