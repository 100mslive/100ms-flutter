---
name: update-sdk-versions
description: Bump 100ms native SDK versions (HMSSDK iOS/Android) and the hmssdk_flutter / hms_room_kit Flutter package versions in lock-step across this monorepo. Use when the user mentions updating/bumping SDK versions, "new HMSSDK release for Flutter", "sync sdk-versions.json", "bump hmssdk_flutter version", "bump hms_room_kit version", or asks to refresh native SDKs after a release on CocoaPods/Maven.
---

# Update SDK Versions (Flutter)

This monorepo has **five** files that must stay in sync whenever 100ms ships a new native SDK release. The task is repetitive and easy to get wrong by hand. The `scripts/update-sdk-versions.sh` script does the whole bump in one pass.

## When to use this skill

Invoke when the user asks any of:
- "Update SDK versions to 1.17.2 / 2.9.84"
- "Bump HMSSDK iOS / Android"
- "Refresh 100ms native SDKs"
- "Bump hmssdk_flutter patch / minor / major"
- "Sync sdk-versions.json with the latest 100ms release"

## When NOT to use this skill

- Sample-app marketing version bumps (`versionCode` / `versionName` in `build.gradle`, `CFBundleVersion` in `Info.plist`) — that's `release-apps.sh` via Fastlane.
- Changes to `packages/hmssdk_flutter/ios/hmssdk_flutter.podspec` or `packages/hmssdk_flutter/android/build.gradle` directly — those read `sdk-versions.json` programmatically (`JSON.parse` and `JsonSlurper`); never edit them by hand for SDK version changes.
- Hand-editing the "Current Version Info" block at the bottom of `packages/hmssdk_flutter/example/ExampleAppChangelog.txt` — the script regenerates it via the existing `update-changelog-versions.js`.
- Sample apps under `sample apps/` — by design, the script does not touch those (pre-existing version drift in those apps is left as-is).

## How to invoke

Always ask the user for the target versions first (the script does NOT auto-fetch from CocoaPods/Maven by design). Ask:

1. New iOS HMSSDK version (current value in `packages/hmssdk_flutter/lib/assets/sdk-versions.json` → `ios`)
2. New Android HMSSDK version (current value in `sdk-versions.json` → `android`)
3. Should `hmssdk_flutter` get a patch / minor / major bump (or skip)?
4. Should `hms_room_kit` get a patch / minor / major bump (or skip)?

The ancillary iOS pods (`iOSBroadcastExtension`, `iOSHLSPlayerSDK`, `iOSNoiseCancellationModels`) change rarely — only ask if the user mentions them.

Then run from the repo root:

```bash
bash scripts/update-sdk-versions.sh \
  --ios-sdk <ver> \
  --android-sdk <ver> \
  --hmssdk-bump <skip|patch|minor|major> \
  --room-kit-bump <skip|patch|minor|major> \
  --yes
```

Or via the npm alias: `npm --prefix scripts run update-sdk-versions -- ...same flags...`.

Use `--yes` only after you've echoed the proposed changes back to the user and they've confirmed. Without `--yes`, the script prompts; in a non-interactive Claude run you must pass it.

Add `--ios-broadcast`, `--ios-hls`, `--ios-noise-cancel` when the user has provided new ancillary versions.

**Tip — preview without committing:** add `--dry-run` to print proposed changes and exit without writing anything, running `flutter pub get`, or refreshing the changelog. Useful when the user wants to "see what would change" before agreeing. Since it's read-only, `--dry-run` ignores the dirty-tree guard.

## What the script does

1. Updates `packages/hmssdk_flutter/lib/assets/sdk-versions.json` (the Podspec and Android `build.gradle` read from this — they're not edited).
2. Bumps `packages/hmssdk_flutter/pubspec.yaml` and its example.
3. Bumps `packages/hms_room_kit/pubspec.yaml` and its example.
4. **Always** sets `hms_room_kit`'s `hmssdk_flutter:` dependency to the resolved hmssdk_flutter version (preserves the existing constraint operator: `^`, `~`, or exact). Auto-corrects drift even when `--hmssdk-bump=skip`.
5. Maintains the **lockstep invariant**: `sdk-versions.json.flutter` always matches the new `hmssdk_flutter` pubspec version (the iOS Podspec uses `sdk-versions.json.flutter` as `s.version`).
6. Runs `flutter pub get` in 4 directories in parallel to refresh `pubspec.lock` files.
7. **Validates iOS native versions** by running `pod install --repo-update` in `packages/hmssdk_flutter/example/ios` (only if any iOS native field changed). If the version doesn't exist on CocoaPods or there's a transitive conflict, the script exits non-zero with a clear error. A successful run also refreshes `Podfile.lock` and `Pods/` so they land in the change set.
8. **Validates the Android native version** by running `./gradlew :app:dependencies --refresh-dependencies` in `packages/hmssdk_flutter/example/android` (only if `--android-sdk` changed). Catches non-existent Maven artifacts.
9. Both native validations are skipped by `--no-install`. On either failure the script aborts; revert with `git checkout .` (the dirty-tree guard ensures the working tree was clean on entry, so the revert is safe and complete).
10. Runs `node scripts/update-changelog-versions.js` to refresh the version block at the bottom of `ExampleAppChangelog.txt`.
11. Prints a suggested conventional-commit message.

## After the script completes

1. **If iOS native versions changed**, run `pod install` so `Podfile.lock` picks up the new HMSSDK pod versions:
   ```bash
   cd packages/hmssdk_flutter/example/ios && pod install
   ```
2. Show the user `git status` and `git diff --stat` so they can review.
3. Offer to commit using the suggested conventional-commit message the script printed. Use `LEFTHOOK=0 git commit --no-verify` if pre-existing repo lint debt blocks the commit.
4. **The script never commits or pushes** — you must do that explicitly after user review.

## Notes / gotchas

- **The script does not commit.** It mutates files only. The user reviews and commits manually.
- **Always work on a new branch.** Don't run on `main` directly. Use a worktree if the current branch has unrelated WIP.
- The dirty-tree guard refuses to run if any of the 5 source-of-truth files have uncommitted changes. Use `--force` to override (rare).
- The script is idempotent: running with current values is a no-op.
- Pre-commit Husky/lefthook hooks may block commits on pre-existing lint debt unrelated to a version bump — bypass with `--no-verify` for chore commits like this.
- A GitHub Actions workflow at `.github/workflows/bump-sdk-versions.yml` exposes the same script via `workflow_dispatch` and opens a PR with `peter-evans/create-pull-request@v6`.
