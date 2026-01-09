# Claude Notifier

Simple macOS notification system for Claude Code. Get notified when Claude finishes a task or needs your input.

## Features

- **Smart Notifications** - Different alerts for "Complete" vs "Needs Input"
- **Duration Tracking** - Shows how long Claude worked (e.g., "Complete (2m 30s)")
- **Project Name** - Displays which project finished
- **Per-Session Emojis** - Each terminal gets a unique emoji to identify which session finished
- **Auto-Setup** - Hooks into Claude Code automatically

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/Claude-Notifier.git
cd Claude-Notifier
./install.sh
```

This will:
1. Install the CLI to `/usr/local/bin/claude-notifier`
2. Configure Claude Code hooks in `~/.claude/settings.json`
3. Create config directory at `~/.claude-notifier/`

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                      Claude Code                             │
├─────────────────────────────────────────────────────────────┤
│  SessionStart    → claude-notifier init   → Assigns emoji   │
│  UserPromptSubmit → claude-notifier start → Records time    │
│  Stop            → claude-notifier notify → Sends alert     │
└─────────────────────────────────────────────────────────────┘
```

**Notification Types:**

| Type | Title | Sound | When |
|------|-------|-------|------|
| Complete | `🤖 ProjectName - Complete (1m 23s)` | Glass | Task finished |
| Input Needed | `🤖 ProjectName - Input Needed` | Blow | Needs permission/review |

## Usage

After installation, just use Claude Code normally. Notifications appear automatically.

### Commands

```bash
claude-notifier status      # Show current session config
claude-notifier enable      # Enable notifications globally
claude-notifier disable     # Disable notifications globally
claude-notifier test        # Test "complete" notification
claude-notifier test input  # Test "input needed" notification
```

### Multiple Terminals

Each terminal session gets a unique emoji automatically:

- Terminal 1 → 🤖 Robot
- Terminal 2 → 🔔 Bell
- Terminal 3 → ✨ Sparkles
- Terminal 4 → 🚀 Rocket
- Terminal 5 → 🧠 Brain
- Terminal 6 → 💻 Computer

This helps identify which terminal finished when running multiple Claude sessions.

## Configuration

Config stored in `~/.claude-notifier/`:

```
~/.claude-notifier/
├── enabled           # Global on/off ("true" or "false")
└── sessions/
    ├── <id>.json     # Session config (emoji, enabled)
    └── <id>.start    # Start timestamp for duration tracking
```

### Claude Code Hooks

The installer adds these hooks to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [{"hooks": [{"type": "command", "command": "/usr/local/bin/claude-notifier init"}]}],
    "UserPromptSubmit": [{"hooks": [{"type": "command", "command": "/usr/local/bin/claude-notifier start"}]}],
    "Stop": [{"hooks": [{"type": "command", "command": "/usr/local/bin/claude-notifier notify"}]}]
  }
}
```

## Customization

### Change Notification Sounds

Edit `scripts/claude-notifier`:

```bash
SOUND_COMPLETE="Glass"   # Task finished
SOUND_INPUT="Blow"       # Needs input
```

Available sounds: `Basso`, `Blow`, `Bottle`, `Frog`, `Funk`, `Glass`, `Hero`, `Morse`, `Ping`, `Pop`, `Purr`, `Sosumi`, `Submarine`, `Tink`

### Add More Emojis

Edit `scripts/claude-notifier`:

```bash
EMOJI_7="🎯|Target|Goal achieved"
EMOJI_8="⚡|Lightning|Quick response"
```

## Uninstall

```bash
./uninstall.sh
```

This removes the CLI and optionally the config directory. You'll need to manually remove the hooks from `~/.claude/settings.json`.

## Troubleshooting

### Notifications not appearing

1. Check macOS permissions: **System Settings → Notifications → Terminal**
2. Ensure notifications are enabled: `claude-notifier status`
3. Test manually: `claude-notifier test`

### Wrong emoji showing

Each terminal gets one emoji. To reset:
```bash
rm ~/.claude-notifier/sessions/*.json
```

### Duration not showing

The `UserPromptSubmit` hook must be configured. Re-run `./install.sh` or manually add the hook.

## Requirements

- macOS (uses `osascript` for notifications)
- Claude Code CLI
- Bash

## License

MIT
