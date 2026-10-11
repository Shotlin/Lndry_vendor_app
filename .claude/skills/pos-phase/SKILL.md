---
name: pos-phase
description: Run a specific POS-mode phase by number (1-4) instead of the automatic next one. Usage /pos-phase 2. Refuses to skip an unfinished earlier phase unless the user explicitly overrides.
argument-hint: "<1|2|3|4> [--force]"
disable-model-invocation: true
---

# /pos-phase $ARGUMENTS

1. Parse the phase number from `$ARGUMENTS` (1–4). If missing or invalid, show the phase table from PROGRESS.md and ask which one.
2. Read `PROGRESS.md`. If any earlier phase is not ✅ and `--force` was not given, stop and say which phase must finish first (suggest `/pos-next`).
3. If the requested phase is already ✅, ask whether to re-open it for fixes; do not redo finished work silently.
4. Otherwise follow the full procedure of the `pos-next` skill (steps 1 and 3–5) but for the requested phase: load context, implement `docs/pos-mode/PHASE-<N>.md`, verify, update PROGRESS.md, hand off.
