---
name: setup-worktree
description: Analyze the project and generate environment hydration instructions for new git worktrees (e.g. copying .venv or node_modules).
---

# Setup Worktree

This skill analyzes the current project repository and generates a configuration file containing instructions for how to hydrate the environment of a newly created git worktree.

## 1. Analysis

1. Inspect the root of the project to determine the tech stack and environment requirements.
   - **Python**: Look for `.venv`, `venv`, `requirements.txt`, `pyproject.toml`, `Pipfile`.
   - **Node.js**: Look for `node_modules`, `package.json`, `.nvmrc`.
   - **Rust**: Look for `Cargo.toml`, `target/`.
   - **Environment variables**: Look for `.env`, `.env.local`.

## 2. Generate Instructions

1. Based on the analysis, write specific, runnable commands (e.g., bash commands) that will copy, link, or reinstall the necessary environment dependencies from the parent repository into a new worktree.
2. Assume the user is running these commands from the root of the *new* worktree, and the parent/main repository is located at a known relative path (usually `../<main-repo-folder>`). Use placeholder variables like `$MAIN_REPO_PATH` if the exact path isn't known, but explain how to use it.
3. Consider speed and reliability: Prefer fast commands like `cp -a ../main/.venv .venv` or `ln -s` over running `npm install` or `pip install` from scratch if possible.
4. Save these instructions into `.gemini/worktree-setup.md`.

## 3. Format of `.gemini/worktree-setup.md`

The file should clearly list the steps needed to hydrate a worktree. Example structure:

```markdown
# Worktree Environment Setup

This project uses [Tech Stack]. When creating a new git worktree, run the following commands from the root of the new worktree to hydrate the environment:

\`\`\`bash
# Example for Python
cp -a ../main-repo/.venv .venv
cp ../main-repo/.env .env
\`\`\`
```

4. Stop and inform the user that the setup instructions have been saved.
