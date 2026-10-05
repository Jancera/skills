---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

# Grilling

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

> [!IMPORTANT]
> **Interview Only — No Implementation**: Grilling is strictly an alignment and discovery protocol. **NEVER modify codebase files or implement changes during or at the conclusion of a grilling session.** Do not touch source code until the user explicitly commands an implementation step after grilling concludes.

## Interview Rounds

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

## Zero-Guessing Invariant

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), inspect the repo or dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

## Session Completion & Handoff

The session is done when the frontier is empty: every branch of the design tree has been visited, and nothing is left silently assumed.

When the session finishes:

1. **Summarize Outcomes**: Present a clear, concise summary of the settled decisions, technical trade-offs agreed upon, and overall shared understanding.
2. **Stop and Do NOT Implement**: Under no circumstances should you start modifying code or creating implementation files on your own.
3. **Present Next-Step Options**: Ask the user what they want to do with the grilling session information:
   - **Author a Spec**: Run `/to-spec` to synthesize the conversation into a structured, testable specification.
   - **Document Decisions**: Save the decisions as architectural decision records (ADRs) or design notes (e.g., via `domain-modeling`).
   - **Plan Deepwork**: If large/multi-phase, prepare task breakdown and phase gates for `/deepwork`.
   - **Direct Implementation**: Implement directly with the main agent (only if the user explicitly instructs it).
4. **Wait for User Decision**: Await explicit instructions from the user before proceeding with any action.
