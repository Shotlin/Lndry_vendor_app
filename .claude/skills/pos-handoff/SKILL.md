---
name: pos-handoff
description: Save the POS-mode work so a fresh session can continue — update PROGRESS.md, commit and push every touched repo on the feature branch. Use before ending a session.
disable-model-invocation: true
---

# /pos-handoff — leave the repo ready for the next session

1. Update `PROGRESS.md`: tick only verified items, correct the phase status, "Last updated", "Current phase", and add a Log entry (done, verified, not run, next step).
2. For each repo with changes (`Lndry_vendor_app`, `../Lndry_backend`, `../Lndry_dashboard_frontend`):
   - confirm branch is `claude/laundry-vendor-pos-modes-bs0o61`;
   - review `git status` and `git diff --stat` — no secrets, no `.env`, no build output, no stray files;
   - commit with a clear message (Co-Authored-By lines per the session's attribution instructions);
   - `git push -u origin claude/laundry-vendor-pos-modes-bs0o61` (retry on network errors: 2, 4, 8, 16 s).
3. Never push to another branch, never force-push, never open a PR unless the user asked.
4. Final message: what was saved, the commit hashes per repo, and "Next session: run `/pos-next`".
