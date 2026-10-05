---
name: setup-worktree
description: Create a new git worktree inside the project directory and automatically hydrate its environment (e.g., copying .venv or node_modules) for immediate implementation.
---

# Setup Worktree

This skill automates the creation of a new git worktree directly inside the current project and hydrates its environment. This avoids creating worktrees inside `.gemini` and keeps the environment setup simple and fast.

## 1. Preparation
1. **Determine the branch name**: Based on the context of the chat (e.g., features discussed), propose a branch name. Ask the user for confirmation if it's not already clear.
2. **Update `.gitignore`**: Check the `.gitignore` at the root of the project. Ensure that the folder where worktrees will live (e.g., `/.worktrees/`) is ignored. If it is not, add it.

## 2. Create the Worktree
1. Use the appropriate tool (e.g., `run_command`) to create the git worktree inside the project folder.
   - Example command: `git worktree add .worktrees/<branch-name> -b <branch-name>`
   - *Note:* If branching from a specific commit or if the branch already exists, adjust the git command accordingly.

## 3. Analyze & Hydrate Environment
1. **Analyze**: Inspect the root of the current project (base branch) to determine the tech stack and environment dependencies.
   - **Python**: Look for `.venv`, `venv`, `requirements.txt`, `pyproject.toml`, `Pipfile`.
   - **Node.js**: Look for `node_modules`, `package.json`, `.nvmrc`.
   - **Rust**: Look for `Cargo.toml`, `target/`.
   - **Environment variables**: Look for `.env`, `.env.local`.
2. **Hydrate**: Execute commands to copy or link the dependencies into the newly created worktree.
   - **Fast Copying**: Prefer copying existing environments to save time. 
   - Example for Python: `cp -a .venv .worktrees/<branch-name>/.venv` and `cp .env .worktrees/<branch-name>/.env`
   - Example for Node.js: `cp -a node_modules .worktrees/<branch-name>/node_modules`

## 4. Finalize
1. Confirm to the user that the worktree has been successfully created and hydrated.
2. Inform the user of the path (e.g., `.worktrees/<branch-name>`) so they can navigate to it or open it in their IDE and start implementing.
