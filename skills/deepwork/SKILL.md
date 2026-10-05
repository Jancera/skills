---
name: deepwork
description: High-cost orchestrator workflow for large, high-risk, multi-phase coding efforts with meaningful dependencies and review gates. Do not activate for routine multi-file changes.
---

# Deepwork

Deepwork is an orchestrator workflow for heavy coding sessions. Use it only
when the work is clearly large or high-risk: multiple dependent phases,
cross-cutting architectural change, unsafe-to-partially-ship migration, or
sustained coordination across several specialist lanes.

Do not activate deepwork merely because a task touches multiple files. Do
not use it for trivial edits, quick docs changes, simple bug fixes, or
routine bounded features — those get no skill and no special agent at all,
just the default agent working directly.

## Core contract

Once this skill is active, whichever agent invoked it must manage the work
as a scheduler, not as the default implementation worker. Never edit
source code yourself — all coding is delegated to `builder`.

Specialists available via `invoke_subagent`:
- `oracle` — review, mandatory once per phase
- `librarian` — research
- `designer` — UI/UX
- `fixer` — bounded mechanical follow-up
- `explorer` — structure/dependency-boundary scans
- `builder` — sandboxed implementation directly in the active workspace

Rules that hold for the whole session:
- Single-level only: never let a specialist invoke another specialist.
- **No new worktrees or branches**: Subagents must NEVER create new worktrees,
  branches, or environments. Always invoke subagents with `Workspace: inherit`.
  The user sets up the environment manually (via worktree or branch) prior to
  starting deepwork; subagents execute directly in this pre-hydrated workspace.
- Never point a subagent at a file to go read (spec.md, the progress
  file) — embed the relevant content directly in its brief.
- **Package installation**: Subagents do not have network access in the
  sandbox. If a task requires a new package or dependency, install it
  separately in the environment before dispatching the task. Never delegate
  package installation to a subagent.

## Setup and state

Maintain a progress file at `.deepwork/<task-slug>.md`. It is
**gitignored, never committed** — bookkeeping for this session only, not
something any subagent is told to open. Do not follow a rigid template;
capture whatever is useful:

- current goal and understanding
- accepted research from `librarian` (reference file paths, don't copy
  content in)
- phase order, specialist ownership per phase, gate order and rationale
- per-task status: task id, files changed, review-gate outcome
- unresolved questions, blockers, follow-ups

Update it after major decisions, reviews, phase completions, and scope
changes.

## Planning

1. Ensure a spec exists (e.g. generated via `to-spec`). Stop for user approval.
2. From the approved spec, choose a small number of coherent **phases**
   based on the work's dependencies and natural delivery boundaries. Do
   not split phases merely to shrink an Oracle review's scope.
3. Break each phase into small vertical-slice **tasks** — one related
   change across every layer it touches (e.g. one db change + the backend
   change that uses it + the frontend change that surfaces it), not
   layered batches. Record per task: id, files owned, depends-on,
   parallel-safe yes/no.
4. Share a compact version of the phase/task breakdown with the user
   before starting.

## Phase execution

- Within a phase, invoke `builder` once per task using `Workspace: inherit`.
  **Never create new worktrees or branches, and never use `workspace: branch`**.
  The environment and workspace are already manually set up by the user prior
  to deepwork; subagents must execute directly in the existing workspace.
- Embed each task's full brief as text in the `invoke_subagent` call:
  goal, exact files, done-when check, and any spec content it needs.
  Never point `builder` at a file to go read.
- **Package installation**: Subagents do not have network access inside
  their sandbox. If a task requires a new package or dependency, install
  it separately in the active environment before invoking `builder`. Never
  ask subagents to fetch or install packages.
- When a brief depends on an unfamiliar dependency, framework, or
  external service, ask `librarian` first so `builder` and `oracle` don't
  redo that research.
- After each `builder` run reports success, report the files changed and
  let the **user** review or validate the changes interactively.
- If a `builder` run fails because its own sandbox blocked something
  (denied network, denied write, permission-rule violation), report it
  and stop. Do not auto-retry with relaxed permissions, and do not
  silently re-triage.

## Phase gate (mandatory)

Once every task in the phase is complete:

1. Invoke `oracle` against the phase's full changed surface (not task by
   task). Give it the phase goal, changed paths, validation evidence, the
   specific decision/risk to review, and accepted research/file
   references — so it reviews established context instead of repeating
   discovery.
2. If the phase changed module boundaries, dependency direction, or file
   placement, run `explorer` in parallel with the Oracle gate.
3. At most **two re-reviews** per gate. State the attempt every time:
   `Gate <n> — review attempt <a> of 3 (<b> re-review(s) remaining)`.
   Request a re-review only when remediation materially changes the
   reviewed decision/risk, or the original concern can't be verified with
   focused evidence — never for a mechanical or already-verified change.
4. Route bounded mechanical remediation to `fixer` (sandboxed, same
  discipline as `builder`, `workspace: inherit`). Route UI/UX regressions
  to `designer`, never to `fixer`.
5. If both re-reviews are exhausted and a material risk remains, record
   it in the progress file and ask the user to accept the risk, change
   scope, or authorize an exceptional additional review.
6. Do not start the next phase's tasks while this gate is open or its
   findings are unreconciled.

## Designer handoff guardrail

Once `designer` delivers, treat the result as accepted design intent for
every later phase: preserve layout, rhythm, hierarchy, motion, spacing,
color, affordances, responsiveness, and component feel. Route follow-up
visual, responsive, motion, hierarchy, polish, or component-feel changes
back to `designer`. Use `fixer` only for bounded mechanical follow-up that
preserves the design exactly (wiring, tests, type fixes, non-visual
behavior). If design intent itself must change, record why in the
progress file before changing it.

## Completion

Finish with the done-when check for every task in the final phase, plus a
concise summary to the user.
