#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="$HOME/.claude-notifier"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"

echo ""
echo "════════════════════════════════════════"
echo "     Installing Claude Notifier"
echo "════════════════════════════════════════"
echo ""

# 1. Create config directory and copy icon
mkdir -p "$CONFIG_DIR/sessions"
echo "true" > "$CONFIG_DIR/enabled"

# Copy icon if it exists
if [ -f "$SCRIPT_DIR/assets/icon.png" ]; then
    cp "$SCRIPT_DIR/assets/icon.png" "$CONFIG_DIR/icon.png"
    echo "✓ Installed notification icon"
fi
echo "✓ Created config directory: $CONFIG_DIR"

# 2. Install CLI script
if [ -w "$INSTALL_DIR" ]; then
    cp "$SCRIPT_DIR/scripts/claude-notifier" "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/claude-notifier"
else
    sudo cp "$SCRIPT_DIR/scripts/claude-notifier" "$INSTALL_DIR/"
    sudo chmod +x "$INSTALL_DIR/claude-notifier"
fi
echo "✓ Installed CLI to: $INSTALL_DIR/claude-notifier"

# 3. Configure Claude Code hooks
mkdir -p "$(dirname "$CLAUDE_SETTINGS")"

if [ -f "$CLAUDE_SETTINGS" ]; then
    cp "$CLAUDE_SETTINGS" "$CLAUDE_SETTINGS.backup"
    echo "✓ Backed up existing settings to $CLAUDE_SETTINGS.backup"
fi

# Create or merge settings
if command -v jq &> /dev/null; then
    if [ -f "$CLAUDE_SETTINGS" ] && [ -s "$CLAUDE_SETTINGS" ]; then
        # Merge with existing settings
        jq '.hooks.SessionStart = [{"hooks": [{"type": "command", "command": "/usr/local/bin/claude-notifier init"}]}] | .hooks.UserPromptSubmit = [{"hooks": [{"type": "command", "command": "/usr/local/bin/claude-notifier start"}]}] | .hooks.Stop = [{"hooks": [{"type": "command", "command": "/usr/local/bin/claude-notifier notify"}]}]' "$CLAUDE_SETTINGS" > "$CLAUDE_SETTINGS.tmp"
        mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"
    else
        # Create new settings file
        cat > "$CLAUDE_SETTINGS" << 'EOF'
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/usr/local/bin/claude-notifier init"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/usr/local/bin/claude-notifier start"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/usr/local/bin/claude-notifier notify"
          }
        ]
      }
    ]
  }
}
EOF
    fi
    echo "✓ Configured Claude Code hooks"
else
    echo ""
    echo "⚠ jq not installed. Please manually add hooks to $CLAUDE_SETTINGS:"
    echo ""
    cat << 'EOF'
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/usr/local/bin/claude-notifier init"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/usr/local/bin/claude-notifier start"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/usr/local/bin/claude-notifier notify"
          }
        ]
      }
    ]
  }
}
EOF
    echo ""
fi

echo ""
echo "════════════════════════════════════════"
echo "       Installation complete!"
echo "════════════════════════════════════════"
echo ""

# Check for terminal-notifier (needed for custom icon)
if command -v terminal-notifier &> /dev/null; then
    echo "✓ terminal-notifier found (custom icon enabled)"
else
    echo "⚠ For custom Claude icon in notifications, install terminal-notifier:"
    echo "  brew install terminal-notifier"
    echo ""
fi

echo ""
echo "Next time you start Claude Code, you'll be"
echo "prompted to select an emoji for notifications."
echo ""
echo "Manual commands:"
echo "  claude-notifier init     - Pick emoji"
echo "  claude-notifier status   - Check config"
echo "  claude-notifier disable  - Turn off globally"
echo ""
