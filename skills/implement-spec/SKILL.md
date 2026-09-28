---
name: implement-spec
description: Plan and execute a feature based on a spec. Use for medium-sized tasks as the natural successor to to-spec.
---

# Implement Spec

This skill plans and executes a medium-sized feature based on an existing spec.

## 1. Planning

1. Read the spec from `docs/specs/<slug>/spec.md` (or similar). Do not design or write code yourself.
2. Break the feature down into small, executable tasks. 
3. Write a plan to `docs/plans/<task-slug>.md` (which is gitignored). Include:
   - Phase/Task breakdown
   - Exact files to be touched per task
   - Dependencies between tasks (whether they are parallel-safe)
4. Stop and share a summary of the plan with the user. Do not proceed until the user approves the plan.

## 2. Execution

1. For each task in the approved plan, invoke the `builder` subagent.
2. Use `Workspace: inherit` for every `builder` invocation. Do NOT use `branch`. The subagents must run directly in the current worktree to reuse the existing environment.
3. Embed the full task brief in the `invoke_subagent` call (goal, exact files, testing expectations). Do not merely point the `builder` to `spec.md` or the plan file—pass the necessary context in the prompt itself.
4. Run parallel-safe tasks concurrently. For dependent tasks, wait for the previous `builder` to finish successfully.
5. If a `builder` fails, report it and ask the user how to proceed.
6. There is no mandatory `oracle` review. When all tasks are complete, summarize the changes and finish.
