# app-store-android-pub — Agents

Repo-specific rules only. Architecture lives in `CORE.md` (which points to
`app-store-android-private`'s `CORE.md` for the shared app details). Global rules live in
`~/.claude/` via `AI-stuff` — referenced, not re-pasted.

## Working in this repo

- This is a **public mirror** — never add anything here that shouldn't be public: no keystore,
  no `key.properties`, no tokens, no private notes.
- This repo is not wired into the release pipeline — `app-store-android-private`'s
  `scripts/release.sh` does not publish here. When porting a fix from the private repo, update
  `RELEASE.md` to record what was ported and whether a release has shipped for it yet (follow the
  existing entries' format).
- Don't assume this mirror's code matches `app-store-android-private` HEAD — see `CORE.md` →
  "Sync lag" and check `RELEASE.md` first.
