# Annihilater's Homebrew Tap

Personal Homebrew tap for my tools and configurations.

## Usage

```bash
brew tap Annihilater/tap
brew install <formula>
```

## Available Formulae

| Formula | Description |
|---|---|
| `ghostty-config` | Ghostty terminal configuration with shaders and themes |
| `copilot2api-go` | GitHub Copilot token → OpenAI / Anthropic API proxy |

## copilot2api-go

```bash
brew install Annihilater/tap/copilot2api-go

# 以后台服务方式启动（登录后自动恢复）
brew services start copilot2api-go
```

- Web 控制台：http://localhost:37000
- 代理 API：http://localhost:34141

更多说明：https://github.com/Annihilater/copilot2api-go
