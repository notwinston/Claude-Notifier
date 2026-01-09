#!/bin/bash

echo ""
echo "════════════════════════════════════════"
echo "     Uninstalling Claude Notifier"
echo "════════════════════════════════════════"
echo ""

# Remove CLI
if [ -f "/usr/local/bin/claude-notifier" ]; then
    if [ -w "/usr/local/bin" ]; then
        rm -f /usr/local/bin/claude-notifier
    else
        sudo rm -f /usr/local/bin/claude-notifier
    fi
    echo "✓ Removed CLI"
else
    echo "- CLI not found (already removed)"
fi

# Remove config (optional - ask user)
if [ -d "$HOME/.claude-notifier" ]; then
    read -r -p "Remove config directory ~/.claude-notifier? [y/N] " choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        rm -rf "$HOME/.claude-notifier"
        echo "✓ Removed config directory"
    else
        echo "- Config directory kept"
    fi
fi

echo ""
echo "════════════════════════════════════════"
echo ""
echo "Note: Claude Code hooks in ~/.claude/settings.json"
echo "were not removed. To remove them manually, edit:"
echo "  ~/.claude/settings.json"
echo ""
echo "And remove the SessionStart and Stop hook entries."
echo ""
echo "Uninstall complete!"
echo ""
