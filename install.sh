#!/usr/bin/env bash
set -euo pipefail

# Determine repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"
AGENTS_SRC="$SCRIPT_DIR/agents"

# Determine target directories
GEMINI_CONFIG_DIR="${GEMINI_CONFIG_DIR:-$HOME/.gemini/config}"
SKILLS_DEST="$GEMINI_CONFIG_DIR/skills"
AGENTS_DEST="$GEMINI_CONFIG_DIR/agents"

echo "=== Installing Antigravity Skills & Agents ==="
echo "Source: $SCRIPT_DIR"
echo "Target: $GEMINI_CONFIG_DIR"
echo

# Ensure source directories exist
if [ ! -d "$SKILLS_SRC" ] || [ ! -d "$AGENTS_SRC" ]; then
  echo "Error: Source directories 'skills' or 'agents' not found in $SCRIPT_DIR" >&2
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
# Copy agents
echo "Copying agents to $AGENTS_DEST..."
for agent_file in "$AGENTS_SRC"/*; do
  if [ -f "$agent_file" ]; then
    agent_name="$(basename "$agent_file")"
    cp "$agent_file" "$AGENTS_DEST/"
    echo "  - Installed agent: $agent_name"
  fi
done

echo
echo "=== Installation complete! ==="
