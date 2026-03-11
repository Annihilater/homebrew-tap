class Copilot2apiGo < Formula
  desc "GitHub Copilot token → OpenAI / Anthropic API proxy"
  homepage "https://github.com/Annihilater/copilot2api-go"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.2/copilot-go_v0.1.2_darwin_arm64.tar.gz"
      sha256 "0a24b2d2debe8516651288bbebfad2c1b19e9cfa36721b17394dda895938ce65"
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.2/copilot-go_v0.1.2_darwin_amd64.tar.gz"
      sha256 "581237d55417eb7dea6f55524e263386cddd2c4a5d7c8e1c385b1ca7cc4ee73d"
    end
  end

  on_linux do
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.2/copilot-go_v0.1.2_linux_arm64.tar.gz"
        sha256 "268f16902684a39242403f632fcd2fd8ce146a5db615625c7c63e6840fe08eba"
      end
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.1.2/copilot-go_v0.1.2_linux_amd64.tar.gz"
      sha256 "d9d02abb13a896e19a6989195ec33e8ba4fbc5cea87129e713bd5c3db3b3e5fc"
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
