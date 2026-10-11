---
name: pos-next
description: Continue the POS-mode initiative. Reads PROGRESS.md, finds the first unfinished phase (resuming from the last unchecked item), implements it per docs/pos-mode/PHASE-N.md, verifies, updates PROGRESS.md, commits and pushes. Use at the start of every new session.
disable-model-invocation: true
---

# /pos-next — do the next piece of POS-mode work

You are continuing a multi-session project. Follow these steps exactly.

## 1. Load context (do not skip)
1. Read `CLAUDE.md` (rules) and `PROGRESS.md` (state) in `Lndry_vendor_app`.
2. Read `docs/pos-mode/00-MASTER-PLAN.md`.
3. Confirm the branch in every repo you will touch: `git -C <repo> branch --show-current` must be
   `claude/laundry-vendor-pos-modes-bs0o61` (create it from the current HEAD if missing). Repos: `../Lndry_backend`, `../Lndry_dashboard_frontend`, this repo. Never modify `../epic-laundry-desktop`.
4. Check tooling: `flutter --version`, `node -v`, `psql --version`. If Flutter is missing, try installing it (see CLAUDE.md); if impossible, note it in PROGRESS.md "Environment notes".

## 2. Choose the phase
- Find the first phase in the PROGRESS.md table that is not ✅.
  - If it is 🟡: resume — open its checklist, start at the first unchecked item.
  - If it is ⬜: first confirm every earlier phase is ✅ (Definition of Done met). If an earlier phase is not ✅, do that phase instead.
  - If all phases are ✅: report "POS mode complete", show known limitations from the Log, and stop.
- Set the phase to 🟡 and fill "Started" (today's date) if not already.
- Tell the user in 2–3 lines which phase and which item you are starting.

## 3. Implement
- Open `docs/pos-mode/PHASE-<N>.md` and work through its sections in order (backend → dashboard → Flutter, as written).
- Work in small steps; after each coherent step: run the relevant checks, tick the box in PROGRESS.md, and commit (in the repo that changed) with a clear message.
- Respect CLAUDE.md rules: no marketplace UI changes, no Epic changes, server is the money source of truth, `ENFORCE_OFFERING` stays off, honest status.
- If you hit a real gap in the plan (an endpoint missing, a metric that cannot be computed truthfully), handle it the way the phase doc says (add small tested backend code, or return null) and write it in the PROGRESS.md Log.
- If you are blocked or need a product decision, add it to "Blockers / open questions", mark the phase ⛔ only if you cannot proceed at all, and ask the user ONE concise question. Otherwise keep going with the documented default.

## 4. Verify (the phase's "Verify" block)
Run what can be run. Record exactly what ran and the result. Anything not run → "(written, not run)" + reason. Fix failures; do not weaken tests to pass.

## 5. Close the phase (only if Definition of Done is met)
- Re-read the phase's "Definition of done" and check each line against evidence.
- Mark the phase ✅, set "Completed" date, update "Current phase" and "Last updated" at the top of PROGRESS.md, add a Log entry (what shipped, what was verified, what was not).
- Run the `/pos-handoff` procedure (commit + push every touched repo).
- Tell the user: what is finished, what to test by hand (3–5 concrete steps), and say "Run `/pos-next` again in a new session to start Phase N+1."
- If Definition of Done is NOT met, leave the phase 🟡, list what remains, and still run the handoff so the work is saved.

Stop after finishing ONE phase. Do not start the next phase in the same run unless the user asks.
