class CopilotGo < Formula
  desc "GitHub Copilot token → OpenAI / Anthropic API proxy"
  homepage "https://github.com/Annihilater/copilot2api-go"
  version "0.0.0"
  license "MIT"

  # Placeholder — automatically updated by the release workflow on each tag push.
  on_macos do
    on_arm do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.0.0/copilot-go_v0.0.0_darwin_arm64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.0.0/copilot-go_v0.0.0_darwin_amd64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.0.0/copilot-go_v0.0.0_linux_arm64.tar.gz"
        sha256 "0000000000000000000000000000000000000000000000000000000000000000"
      end
    end
    on_intel do
      url "https://github.com/Annihilater/copilot2api-go/releases/download/v0.0.0/copilot-go_v0.0.0_linux_amd64.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
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
    assert_predicate opt_bin/"copilot-go", :exist?
  end
end
