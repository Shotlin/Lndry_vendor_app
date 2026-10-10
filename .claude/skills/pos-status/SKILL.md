---
name: pos-status
description: Show where the POS-mode initiative stands — phase table, items done/remaining, blockers, and the next action. Read-only.
disable-model-invocation: true
---

# /pos-status — read-only progress report

1. Read `PROGRESS.md`. Count ticked vs unticked boxes per phase.
2. For each repo (`Lndry_vendor_app`, `../Lndry_backend`, `../Lndry_dashboard_frontend`): `git status --short | head`, `git log --oneline -5`, and whether local commits are unpushed (`git status -sb`).
3. Print a compact report: phase table with % done, current phase's next 3 unchecked items, blockers/open questions, uncommitted or unpushed work (flag it), and the exact next command (`/pos-next`).
4. Do not change any file.
