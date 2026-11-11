#!/usr/bin/env bash
set -euo pipefail

# Determine repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"
AGENTS_SRC="$SCRIPT_DIR/claude/agents"

# Determine target directories
CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SKILLS_DEST="$CLAUDE_CONFIG_DIR/skills"
AGENTS_DEST="$CLAUDE_CONFIG_DIR/agents"

echo "=== Installing Claude Code Skills & Subagents ==="
echo "Source: $SCRIPT_DIR"
echo "Target: $CLAUDE_CONFIG_DIR"
echo

# Ensure source directories exist
if [ ! -d "$SKILLS_SRC" ] || [ ! -d "$AGENTS_SRC" ]; then
  echo "Error: Source directories '$SKILLS_SRC' or '$AGENTS_SRC' not found" >&2
  exit 1
fi

# Ensure destination directories exist
mkdir -p "$SKILLS_DEST" "$AGENTS_DEST"

# Copy skills
echo "Copying skills to $SKILLS_DEST..."
for skill_dir in "$SKILLS_SRC"/*; do
  if [ -d "$skill_dir" ]; then
    skill_name="$(basename "$skill_dir")"
    rm -rf "$SKILLS_DEST/$skill_name"
    cp -r "$skill_dir" "$SKILLS_DEST/"
    echo "  - Installed skill: $skill_name"
  fi
done

echo
# Copy subagents
echo "Copying subagents to $AGENTS_DEST..."
for agent_file in "$AGENTS_SRC"/*.md; do
  if [ -f "$agent_file" ]; then
    cp "$agent_file" "$AGENTS_DEST/"
    echo "  - Installed subagent: $(basename "$agent_file")"
  fi
done

echo
echo "=== Installation complete! ==="
