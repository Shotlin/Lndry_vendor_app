---
name: pos-verify
description: Run the verification gates for the current POS-mode phase (backend tests, dashboard tests, Flutter analyze/test) and report honestly what passed, failed, or could not run. Does not change product code.
disable-model-invocation: true
---

# /pos-verify — evidence, not optimism

1. Read `PROGRESS.md` to find the current phase, then the "Verify" block of `docs/pos-mode/PHASE-<N>.md`.
2. Run each command that is possible in this environment (check tool availability first). Capture pass/fail counts and the first failure's output.
3. Report a table: command → ✅ passed / ❌ failed / ⏭ not run (reason). Never report a skipped command as passed.
4. Then check the phase's "Definition of done" lines one by one and mark each Met / Not met / Unverified with the evidence.
5. Append a one-line result to the PROGRESS.md Log (`Verify Phase N: …`). Do not tick checklist boxes here and do not edit product code — if something fails, tell the user and suggest `/pos-next` to fix it.
