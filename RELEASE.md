# Releases

Distribution: this is the public mirror of the store app's source. Release
APKs -- including this app's own build -- publish to the `app-store-web` hub
repo's GitHub Releases under the stable tag `store` (see that hub repo's
`AGENTS.md`). Self-update reads that same tag directly
(`lib/services/self_update.dart` / `lib/config.dart`).

## v1.0.6+7 (2026-07-07)

- Fixed a real double-tap race condition in `install_button.dart`:
  `_busy` was only set to `true` *after* an `await` on
  `LogService().hasSubmittedInfo()` (and potentially the `InfoGateSheet`
  dialog), so a fast double-tap on "Get APK"/"Update" could slip a second
  call past the `_busy` guard before either call had set it. Both calls
  then downloaded concurrently to the identical local file path
  (`"${app.id}-${version}.apk"`), interleaving writes from two HTTP
  streams into the same file and producing a corrupted APK that Android's
  installer rejected with "App not installed as package appears to be
  invalid." Root-caused via a real user report installing TwinClean (the
  GitHub release showed `downloadCount: 2` for a single install attempt,
  and the release asset itself was verified byte-identical and correctly
  signed, ruling out a bad upload). `_busy` is now claimed synchronously
  at the very top of `_installOrUpdate()`, before any `await`.
- Verified: analyze/test clean, fresh install on an emulator launches
  without regressions, uploaded release asset checksum-verified against
  the local build after the upload.

- Hub: https://github.com/jitendrajangidcodes-cloud/app-store-web/releases/tag/store

## v1.0.5+6 (2026-07-06)

- Download logging (introduced inactive in v1.0.4) is now live: the Apps
  Script endpoint is deployed and wired into `LogService._endpoint`. Verified
  working end-to-end (Python `requests` POST returned `{"ok":true}`) after
  fixing a real bug in the script itself (`LockService` acquisition ran
  outside its try/catch, so any failure there returned Google's generic
  error page instead of a usable response) -- see the download-log Apps
  Script (`scripts/download-log/Code.gs`) in the source repo.

- Hub: https://github.com/jitendrajangidcodes-cloud/app-store-web/releases/tag/store

## v1.0.4+5 (2026-07-05)

- Fixed the install popup silently failing to appear: `installApk()` fired
  the install intent blind, never checking `canRequestPackageInstalls()`
  first. If that permission wasn't already granted, Android blocked with its
  own warning screen instead of the real install prompt. Now checks first,
  and if not granted, shows an "Open Settings" prompt and auto-retries the
  install handoff on app resume.
- Fixed downloaded APKs being deleted if the app closed before install:
  `cleanupApks()` wiped every `.apk` in the cache dir on every launch and
  every screen navigation. Now only sweeps files untouched for 15+ minutes.
- Downloads now resume via HTTP Range requests after a network drop or a
  Wi-Fi/mobile-data switch, instead of restarting from byte 0; reuses an
  already-complete file outright instead of re-fetching it.
- Download failures now show a Retry action instead of a dead-end snackbar.
- Added an optional download log (name + device info, once per device) for
  the web + store app surfaces only -- inactive until the Apps Script
  endpoint is deployed and wired in (see the download-log script's README in
  the source repo).

- Hub: https://github.com/jitendrajangidcodes-cloud/app-store-web/releases/tag/store

## v1.0.3+4 (2026-07-04)

- Update button now shows live download progress and reports errors (no more
  dead-looking tap)
- Single, cleaner brand header on the home screen
- Pull-to-refresh updates in place instead of flashing like a web reload
- Installs every app and its own updates from the one hub

- Hub: https://github.com/jitendrajangidcodes-cloud/app-store-web/releases/tag/store
