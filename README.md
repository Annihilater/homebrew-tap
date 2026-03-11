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
| `copilot-go` | GitHub Copilot token → OpenAI / Anthropic API proxy |

## copilot-go

```bash
brew install Annihilater/tap/copilot-go

# 以后台服务方式启动（登录后自动恢复）
brew services start copilot-go
```

- Web 控制台：http://localhost:37000
- 代理 API：http://localhost:34141

更多说明：https://github.com/Annihilater/copilot2api-go
