# app-store-android-pub — Core

Public source mirror of `app-store-android-private` (the "PNSJY Store" native Android
installer app — see that repo's `CORE.md` for the full architecture, tech stack, and feature
registry; not re-pasted here). Unlike `Cards-pub`/`TwinClean-pub`, this repo carries actual
**source code**, manually kept in sync with the private repo — there is no automated mirror
script and no GitHub Releases are published from here (confirmed empty).

## Why it's public

It exists so the store app's source can be inspected with **no secrets** — no signing keystore,
no `key.properties`, no tokens (all gitignored/absent). Per `app-store-android-private`'s own
`CORE.md`, this mirror is *not* part of the release/distribution flow: `scripts/release.sh`
there publishes only to `app-store-android-private` itself and the `app-store-web` hub (tag
`store`); it does not push here.

## Sync lag

Fixes land in `app-store-android-private` first and get ported here by hand afterward — see
`RELEASE.md`, which tracks what's been ported vs. what's still pending (e.g. the double-tap
race-condition fix was ported in commit `3a576a4` but had not yet shipped a corresponding release
here as of that entry). Check `RELEASE.md` before assuming this mirror is current.
