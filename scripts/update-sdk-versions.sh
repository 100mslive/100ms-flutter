#!/usr/bin/env bash
#
# Update 100ms native SDK versions and Flutter package versions in lock-step.
# Mirrors the equivalent script in the 100ms-react-native repo.
#
# Usage: bash scripts/update-sdk-versions.sh [options]
# See --help for full flag list.
#

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

SDK_VERSIONS_JSON="${ROOT_DIR}/packages/hmssdk_flutter/lib/assets/sdk-versions.json"
HMSSDK_PUBSPEC="${ROOT_DIR}/packages/hmssdk_flutter/pubspec.yaml"
HMSSDK_EXAMPLE_PUBSPEC="${ROOT_DIR}/packages/hmssdk_flutter/example/pubspec.yaml"
ROOM_KIT_PUBSPEC="${ROOT_DIR}/packages/hms_room_kit/pubspec.yaml"
ROOM_KIT_EXAMPLE_PUBSPEC="${ROOT_DIR}/packages/hms_room_kit/example/pubspec.yaml"

# Files we may modify (used by the dirty-tree guard)
TRACKED_FILES=(
  "$SDK_VERSIONS_JSON"
  "$HMSSDK_PUBSPEC"
  "$HMSSDK_EXAMPLE_PUBSPEC"
  "$ROOM_KIT_PUBSPEC"
  "$ROOM_KIT_EXAMPLE_PUBSPEC"
)

# Directories where flutter pub get runs after edits
INSTALL_DIRS=(
  "packages/hmssdk_flutter"
  "packages/hmssdk_flutter/example"
  "packages/hms_room_kit"
  "packages/hms_room_kit/example"
)

# Allowed bump kinds for the package version flags
BUMP_KINDS=("skip" "patch" "minor" "major")

# ============================================================================
# COLORS / LOGGING
# ============================================================================

if [[ -t 1 ]]; then
  C_RED=$'\033[0;31m'
  C_GREEN=$'\033[0;32m'
  C_YELLOW=$'\033[1;33m'
  C_BLUE=$'\033[0;34m'
  C_DIM=$'\033[2m'
  C_RESET=$'\033[0m'
else
  C_RED=""; C_GREEN=""; C_YELLOW=""; C_BLUE=""; C_DIM=""; C_RESET=""
fi

err()  { printf "%s\n" "${C_RED}❌ $*${C_RESET}" >&2; }
warn() { printf "%s\n" "${C_YELLOW}⚠ $*${C_RESET}" >&2; }
info() { printf "%s\n" "${C_BLUE}$*${C_RESET}"; }
ok()   { printf "%s\n" "${C_GREEN}✓ $*${C_RESET}"; }

# ============================================================================
# CROSS-PLATFORM SED HELPER
# ============================================================================

if [[ "$(uname)" == "Darwin" ]]; then
  sed_inplace() { sed -i '' "$@"; }
else
  sed_inplace() { sed -i "$@"; }
fi

# ============================================================================
# DEFAULT FLAG VALUES
# ============================================================================

IOS_SDK=""
ANDROID_SDK=""
IOS_BROADCAST=""
IOS_HLS=""
IOS_NOISE_CANCEL=""
HMSSDK_BUMP=""
ROOM_KIT_BUMP=""
NO_INSTALL=false
YES=false
FORCE=false
DRY_RUN=false

# ============================================================================
# HELP
# ============================================================================

print_help() {
  cat <<EOF
Usage: bash scripts/update-sdk-versions.sh [options]

Bumps native SDK versions and Flutter package versions in lock-step across the
monorepo. With no flags it prompts interactively (Enter to keep current value).

Native SDK version overrides (semver, e.g. 1.17.2):
  --ios-sdk <ver>            iOS HMSSDK version
  --android-sdk <ver>        Android HMSSDK version
  --ios-broadcast <ver>      iOSBroadcastExtension version
  --ios-hls <ver>            iOSHLSPlayerSDK version
  --ios-noise-cancel <ver>   iOSNoiseCancellationModels version

Flutter package bumps (skip|patch|minor|major):
  --hmssdk-bump <kind>       Bump hmssdk_flutter (and sdk-versions.json.flutter)
  --room-kit-bump <kind>     Bump hms_room_kit

Behavior:
  --dry-run                  Print proposed changes and exit (no writes,
                             no flutter pub get, no changelog refresh)
  --no-install               Skip 'flutter pub get' in the four affected dirs
  --yes                      Skip the apply confirmation
  --force                    Allow running with a dirty working tree
  -h, --help                 Show this message

Side-effects:
  - hms_room_kit's hmssdk_flutter dependency is always synced to the resolved
    hmssdk_flutter version (auto-corrects drift).
  - sdk-versions.json.flutter is kept in lockstep with hmssdk_flutter's pubspec
    version (the iOS Podspec uses sdk-versions.json.flutter as s.version).
  - After writes, runs flutter pub get in 4 dirs (parallel) to refresh lock files.
  - Then runs scripts/update-changelog-versions.js to refresh the version
    block at the bottom of ExampleAppChangelog.txt.
  - Reminds you to 'pod install' if iOS native versions changed.
EOF
}

# ============================================================================
# ARG PARSING
# ============================================================================

require_value() {
  local flag="$1" value="${2:-}"
  if [[ -z "$value" || "$value" == --* ]]; then
    err "Flag $flag requires a value"
    exit 1
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ios-sdk)          require_value "$1" "${2:-}"; IOS_SDK="$2"; shift 2 ;;
    --android-sdk)      require_value "$1" "${2:-}"; ANDROID_SDK="$2"; shift 2 ;;
    --ios-broadcast)    require_value "$1" "${2:-}"; IOS_BROADCAST="$2"; shift 2 ;;
    --ios-hls)          require_value "$1" "${2:-}"; IOS_HLS="$2"; shift 2 ;;
    --ios-noise-cancel) require_value "$1" "${2:-}"; IOS_NOISE_CANCEL="$2"; shift 2 ;;
    --hmssdk-bump)      require_value "$1" "${2:-}"; HMSSDK_BUMP="$2"; shift 2 ;;
    --room-kit-bump)    require_value "$1" "${2:-}"; ROOM_KIT_BUMP="$2"; shift 2 ;;
    --no-install)       NO_INSTALL=true; shift ;;
    --yes)              YES=true; shift ;;
    --force)            FORCE=true; shift ;;
    --dry-run)          DRY_RUN=true; shift ;;
    -h|--help)          print_help; exit 0 ;;
    *) err "Unknown argument: $1"; echo "Use --help for usage."; exit 1 ;;
  esac
done

# ============================================================================
# VALIDATION HELPERS
# ============================================================================

is_semver() {
  [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

assert_semver() {
  local label="$1" value="$2"
  if ! is_semver "$value"; then
    err "Invalid semver for $label: \"$value\" (expected MAJOR.MINOR.PATCH)"
    exit 1
  fi
}

is_valid_bump() {
  local v="$1"
  for k in "${BUMP_KINDS[@]}"; do [[ "$v" == "$k" ]] && return 0; done
  return 1
}

assert_bump() {
  local label="$1" value="$2"
  if ! is_valid_bump "$value"; then
    err "Invalid value for $label: \"$value\" (expected skip|patch|minor|major)"
    exit 1
  fi
}

# Validate flag values up front, before any prompts or reads.
[[ -n "$IOS_SDK" ]]          && assert_semver "--ios-sdk"          "$IOS_SDK"
[[ -n "$ANDROID_SDK" ]]      && assert_semver "--android-sdk"      "$ANDROID_SDK"
[[ -n "$IOS_BROADCAST" ]]    && assert_semver "--ios-broadcast"    "$IOS_BROADCAST"
[[ -n "$IOS_HLS" ]]          && assert_semver "--ios-hls"          "$IOS_HLS"
[[ -n "$IOS_NOISE_CANCEL" ]] && assert_semver "--ios-noise-cancel" "$IOS_NOISE_CANCEL"
[[ -n "$HMSSDK_BUMP" ]]      && assert_bump   "--hmssdk-bump"      "$HMSSDK_BUMP"
[[ -n "$ROOM_KIT_BUMP" ]]    && assert_bump   "--room-kit-bump"    "$ROOM_KIT_BUMP"

# ============================================================================
# READERS
# ============================================================================

# Read a top-level field from sdk-versions.json
read_sdk_field() {
  local field="$1"
  node -e "
    const fs = require('fs');
    const obj = JSON.parse(fs.readFileSync(process.argv[1], 'utf8'));
    process.stdout.write(String(obj[process.argv[2]] ?? ''));
  " "$SDK_VERSIONS_JSON" "$field"
}

# Read the top-level 'version:' line from a pubspec.yaml
read_pubspec_version() {
  local pubspec="$1"
  awk '/^version:[[:space:]]+/ { print $2; exit }' "$pubspec"
}

# Read the value of the 'hmssdk_flutter:' dep line in a pubspec.yaml
# (only meaningful for hms_room_kit's pubspec). Returns the raw token after the
# colon (could include a leading ^ or ~ operator).
read_hmssdk_dep_raw() {
  local pubspec="$1"
  awk '/^[[:space:]]+hmssdk_flutter:[[:space:]]+/ { print $2; exit }' "$pubspec"
}

# (parse_constraint helper removed — done inline below)

# ============================================================================
# SEMVER BUMP
# ============================================================================

bump_semver() {
  local version="$1" kind="$2"
  if [[ "$kind" == "skip" ]]; then
    echo "$version"
    return 0
  fi
  assert_semver "package version" "$version"
  IFS='.' read -ra parts <<< "$version"
  local maj="${parts[0]}" min="${parts[1]}" pat="${parts[2]}"
  case "$kind" in
    patch) echo "$maj.$min.$((pat + 1))" ;;
    minor) echo "$maj.$((min + 1)).0" ;;
    major) echo "$((maj + 1)).0.0" ;;
  esac
}

# ============================================================================
# INTERACTIVE PROMPTS (only used if a value isn't supplied via flag)
# ============================================================================

ask() {
  local question="$1" default="$2" response
  if [[ -n "$default" ]]; then
    read -r -p "$question [$default]: " response || true
  else
    read -r -p "$question: " response || true
  fi
  if [[ -z "$response" ]]; then
    echo "$default"
  else
    echo "$response"
  fi
}

is_interactive() {
  [[ -t 0 && -t 1 ]]
}

# ============================================================================
# READ CURRENT STATE
# ============================================================================

CURRENT_IOS_SDK=$(read_sdk_field ios)
CURRENT_ANDROID_SDK=$(read_sdk_field android)
CURRENT_IOS_BROADCAST=$(read_sdk_field iOSBroadcastExtension)
CURRENT_IOS_HLS=$(read_sdk_field iOSHLSPlayerSDK)
CURRENT_IOS_NOISE_CANCEL=$(read_sdk_field iOSNoiseCancellationModels)
CURRENT_FLUTTER_FIELD=$(read_sdk_field flutter)

CURRENT_HMSSDK_VERSION=$(read_pubspec_version "$HMSSDK_PUBSPEC")
CURRENT_HMSSDK_EXAMPLE_VERSION=$(read_pubspec_version "$HMSSDK_EXAMPLE_PUBSPEC")
CURRENT_ROOM_KIT_VERSION=$(read_pubspec_version "$ROOM_KIT_PUBSPEC")
CURRENT_ROOM_KIT_EXAMPLE_VERSION=$(read_pubspec_version "$ROOM_KIT_EXAMPLE_PUBSPEC")
CURRENT_ROOM_KIT_HMSSDK_DEP_RAW=$(read_hmssdk_dep_raw "$ROOM_KIT_PUBSPEC")

# Parse the operator (so we can preserve it on write). Inline regex match
# avoids subshell + read parsing pitfalls with whitespace IFS.
ROOM_KIT_DEP_OP=""
ROOM_KIT_DEP_VER="$CURRENT_ROOM_KIT_HMSSDK_DEP_RAW"
if [[ "$CURRENT_ROOM_KIT_HMSSDK_DEP_RAW" =~ ^([\^~])(.+)$ ]]; then
  ROOM_KIT_DEP_OP="${BASH_REMATCH[1]}"
  ROOM_KIT_DEP_VER="${BASH_REMATCH[2]}"
fi

# ============================================================================
# RESOLVE TARGETS
# ============================================================================

TARGET_IOS_SDK="$IOS_SDK"
TARGET_ANDROID_SDK="$ANDROID_SDK"
TARGET_IOS_BROADCAST="$IOS_BROADCAST"
TARGET_IOS_HLS="$IOS_HLS"
TARGET_IOS_NOISE_CANCEL="$IOS_NOISE_CANCEL"
TARGET_HMSSDK_BUMP="$HMSSDK_BUMP"
TARGET_ROOM_KIT_BUMP="$ROOM_KIT_BUMP"

if is_interactive; then
  # Prompt for any missing values. Press Enter to keep the current.
  [[ -z "$TARGET_IOS_SDK"          ]] && TARGET_IOS_SDK=$(ask          "iOS HMSSDK version"          "$CURRENT_IOS_SDK")
  [[ -z "$TARGET_ANDROID_SDK"      ]] && TARGET_ANDROID_SDK=$(ask      "Android HMSSDK version"      "$CURRENT_ANDROID_SDK")
  [[ -z "$TARGET_IOS_BROADCAST"    ]] && TARGET_IOS_BROADCAST=$(ask    "iOSBroadcastExtension"       "$CURRENT_IOS_BROADCAST")
  [[ -z "$TARGET_IOS_HLS"          ]] && TARGET_IOS_HLS=$(ask          "iOSHLSPlayerSDK"             "$CURRENT_IOS_HLS")
  [[ -z "$TARGET_IOS_NOISE_CANCEL" ]] && TARGET_IOS_NOISE_CANCEL=$(ask "iOSNoiseCancellationModels"  "$CURRENT_IOS_NOISE_CANCEL")
  [[ -z "$TARGET_HMSSDK_BUMP"      ]] && TARGET_HMSSDK_BUMP=$(ask      "Bump hmssdk_flutter (current $CURRENT_HMSSDK_VERSION) [skip/patch/minor/major]" "patch")
  [[ -z "$TARGET_ROOM_KIT_BUMP"    ]] && TARGET_ROOM_KIT_BUMP=$(ask    "Bump hms_room_kit (current $CURRENT_ROOM_KIT_VERSION) [skip/patch/minor/major]" "patch")
else
  [[ -z "$TARGET_IOS_SDK"          ]] && TARGET_IOS_SDK="$CURRENT_IOS_SDK"
  [[ -z "$TARGET_ANDROID_SDK"      ]] && TARGET_ANDROID_SDK="$CURRENT_ANDROID_SDK"
  [[ -z "$TARGET_IOS_BROADCAST"    ]] && TARGET_IOS_BROADCAST="$CURRENT_IOS_BROADCAST"
  [[ -z "$TARGET_IOS_HLS"          ]] && TARGET_IOS_HLS="$CURRENT_IOS_HLS"
  [[ -z "$TARGET_IOS_NOISE_CANCEL" ]] && TARGET_IOS_NOISE_CANCEL="$CURRENT_IOS_NOISE_CANCEL"
  [[ -z "$TARGET_HMSSDK_BUMP"      ]] && TARGET_HMSSDK_BUMP="skip"
  [[ -z "$TARGET_ROOM_KIT_BUMP"    ]] && TARGET_ROOM_KIT_BUMP="skip"
fi

# Re-validate (interactive responses might be malformed)
assert_semver "iOS HMSSDK"                "$TARGET_IOS_SDK"
assert_semver "Android HMSSDK"            "$TARGET_ANDROID_SDK"
assert_semver "iOSBroadcastExtension"     "$TARGET_IOS_BROADCAST"
assert_semver "iOSHLSPlayerSDK"           "$TARGET_IOS_HLS"
assert_semver "iOSNoiseCancellationModels" "$TARGET_IOS_NOISE_CANCEL"
assert_bump   "hmssdk_flutter bump"        "$TARGET_HMSSDK_BUMP"
assert_bump   "hms_room_kit bump"          "$TARGET_ROOM_KIT_BUMP"

# Compute new package versions
NEW_HMSSDK_VERSION=$(bump_semver "$CURRENT_HMSSDK_VERSION" "$TARGET_HMSSDK_BUMP")
NEW_ROOM_KIT_VERSION=$(bump_semver "$CURRENT_ROOM_KIT_VERSION" "$TARGET_ROOM_KIT_BUMP")

# Lockstep: sdk-versions.json.flutter tracks the hmssdk_flutter pubspec version.
NEW_FLUTTER_FIELD="$NEW_HMSSDK_VERSION"

# Auto-sync room-kit's hmssdk_flutter dep to the resolved hmssdk_flutter version,
# preserving the existing operator (^, ~, exact).
NEW_ROOM_KIT_HMSSDK_DEP="${ROOM_KIT_DEP_OP}${NEW_HMSSDK_VERSION}"

# ============================================================================
# BUILD CHANGE MANIFEST
# ============================================================================

CHANGES=()
record_change() { CHANGES+=("$1"); }

if [[ "$CURRENT_IOS_SDK"          != "$TARGET_IOS_SDK"          ]]; then record_change "sdk-versions.json [ios]: $CURRENT_IOS_SDK -> $TARGET_IOS_SDK"; fi
if [[ "$CURRENT_ANDROID_SDK"      != "$TARGET_ANDROID_SDK"      ]]; then record_change "sdk-versions.json [android]: $CURRENT_ANDROID_SDK -> $TARGET_ANDROID_SDK"; fi
if [[ "$CURRENT_IOS_BROADCAST"    != "$TARGET_IOS_BROADCAST"    ]]; then record_change "sdk-versions.json [iOSBroadcastExtension]: $CURRENT_IOS_BROADCAST -> $TARGET_IOS_BROADCAST"; fi
if [[ "$CURRENT_IOS_HLS"          != "$TARGET_IOS_HLS"          ]]; then record_change "sdk-versions.json [iOSHLSPlayerSDK]: $CURRENT_IOS_HLS -> $TARGET_IOS_HLS"; fi
if [[ "$CURRENT_IOS_NOISE_CANCEL" != "$TARGET_IOS_NOISE_CANCEL" ]]; then record_change "sdk-versions.json [iOSNoiseCancellationModels]: $CURRENT_IOS_NOISE_CANCEL -> $TARGET_IOS_NOISE_CANCEL"; fi
if [[ "$CURRENT_FLUTTER_FIELD"    != "$NEW_FLUTTER_FIELD"       ]]; then record_change "sdk-versions.json [flutter]: $CURRENT_FLUTTER_FIELD -> $NEW_FLUTTER_FIELD"; fi

if [[ "$CURRENT_HMSSDK_VERSION"         != "$NEW_HMSSDK_VERSION"   ]]; then record_change "packages/hmssdk_flutter/pubspec.yaml version: $CURRENT_HMSSDK_VERSION -> $NEW_HMSSDK_VERSION"; fi
if [[ "$CURRENT_HMSSDK_EXAMPLE_VERSION" != "$NEW_HMSSDK_VERSION"   ]]; then record_change "packages/hmssdk_flutter/example/pubspec.yaml version: $CURRENT_HMSSDK_EXAMPLE_VERSION -> $NEW_HMSSDK_VERSION"; fi
if [[ "$CURRENT_ROOM_KIT_VERSION"       != "$NEW_ROOM_KIT_VERSION" ]]; then record_change "packages/hms_room_kit/pubspec.yaml version: $CURRENT_ROOM_KIT_VERSION -> $NEW_ROOM_KIT_VERSION"; fi
if [[ "$CURRENT_ROOM_KIT_HMSSDK_DEP_RAW" != "$NEW_ROOM_KIT_HMSSDK_DEP" ]]; then record_change "packages/hms_room_kit/pubspec.yaml hmssdk_flutter dep: $CURRENT_ROOM_KIT_HMSSDK_DEP_RAW -> $NEW_ROOM_KIT_HMSSDK_DEP"; fi
if [[ "$CURRENT_ROOM_KIT_EXAMPLE_VERSION" != "$NEW_ROOM_KIT_VERSION" ]]; then record_change "packages/hms_room_kit/example/pubspec.yaml version: $CURRENT_ROOM_KIT_EXAMPLE_VERSION -> $NEW_ROOM_KIT_VERSION"; fi

if [[ ${#CHANGES[@]} -eq 0 ]]; then
  ok "Nothing to do — all versions already match the requested values."
  exit 0
fi

# ============================================================================
# PREVIEW
# ============================================================================

echo
info "Proposed changes:"
echo
for c in "${CHANGES[@]}"; do
  printf "  %s\n" "$c"
done
echo

# Dry-run exits before any writes.
if [[ "$DRY_RUN" == true ]]; then
  echo "${C_DIM}(dry-run — no files written, flutter pub get skipped, changelog not refreshed)${C_RESET}"
  exit 0
fi

# ============================================================================
# CONFIRM
# ============================================================================

if [[ "$YES" != true ]]; then
  if ! is_interactive; then
    err "Refusing to apply non-interactively without --yes."
    exit 1
  fi
  read -r -p "Apply these changes? [y/N]: " confirm || true
  if [[ ! "$confirm" =~ ^[Yy] ]]; then
    info "Aborted."
    exit 0
  fi
fi

# ============================================================================
# DIRTY-TREE GUARD
# ============================================================================

if [[ "$FORCE" != true ]]; then
  if dirty=$(git -C "$ROOT_DIR" status --porcelain -- "${TRACKED_FILES[@]}" 2>/dev/null); then
    if [[ -n "$dirty" ]]; then
      err "Working tree has uncommitted changes in version files:"
      printf "%s\n" "$dirty" >&2
      err "Commit/stash first, or rerun with --force."
      exit 1
    fi
  fi
fi

# ============================================================================
# WRITE FILES (only those with actual changes)
# ============================================================================

# Compute which files need writing. Each boolean is true iff the file has at
# least one value-level change.
SDK_JSON_CHANGED=false
[[ "$CURRENT_IOS_SDK"          != "$TARGET_IOS_SDK"          ]] && SDK_JSON_CHANGED=true
[[ "$CURRENT_ANDROID_SDK"      != "$TARGET_ANDROID_SDK"      ]] && SDK_JSON_CHANGED=true
[[ "$CURRENT_IOS_BROADCAST"    != "$TARGET_IOS_BROADCAST"    ]] && SDK_JSON_CHANGED=true
[[ "$CURRENT_IOS_HLS"          != "$TARGET_IOS_HLS"          ]] && SDK_JSON_CHANGED=true
[[ "$CURRENT_IOS_NOISE_CANCEL" != "$TARGET_IOS_NOISE_CANCEL" ]] && SDK_JSON_CHANGED=true
[[ "$CURRENT_FLUTTER_FIELD"    != "$NEW_FLUTTER_FIELD"       ]] && SDK_JSON_CHANGED=true

HMSSDK_PUBSPEC_CHANGED=false
[[ "$CURRENT_HMSSDK_VERSION" != "$NEW_HMSSDK_VERSION" ]] && HMSSDK_PUBSPEC_CHANGED=true

HMSSDK_EXAMPLE_PUBSPEC_CHANGED=false
[[ "$CURRENT_HMSSDK_EXAMPLE_VERSION" != "$NEW_HMSSDK_VERSION" ]] && HMSSDK_EXAMPLE_PUBSPEC_CHANGED=true

ROOM_KIT_PUBSPEC_CHANGED=false
[[ "$CURRENT_ROOM_KIT_VERSION"           != "$NEW_ROOM_KIT_VERSION"     ]] && ROOM_KIT_PUBSPEC_CHANGED=true
[[ "$CURRENT_ROOM_KIT_HMSSDK_DEP_RAW"    != "$NEW_ROOM_KIT_HMSSDK_DEP"  ]] && ROOM_KIT_PUBSPEC_CHANGED=true

ROOM_KIT_EXAMPLE_PUBSPEC_CHANGED=false
[[ "$CURRENT_ROOM_KIT_EXAMPLE_VERSION" != "$NEW_ROOM_KIT_VERSION" ]] && ROOM_KIT_EXAMPLE_PUBSPEC_CHANGED=true

# 1. sdk-versions.json — only rewrite if values changed.
if [[ "$SDK_JSON_CHANGED" == true ]]; then
  node -e '
    const fs = require("fs");
    const path = process.argv[1];
    const obj = JSON.parse(fs.readFileSync(path, "utf8"));
    for (let i = 2; i < process.argv.length; i += 2) {
      obj[process.argv[i]] = process.argv[i + 1];
    }
    fs.writeFileSync(path, JSON.stringify(obj, null, 2) + "\n");
  ' "$SDK_VERSIONS_JSON" \
    ios "$TARGET_IOS_SDK" \
    android "$TARGET_ANDROID_SDK" \
    iOSBroadcastExtension "$TARGET_IOS_BROADCAST" \
    iOSHLSPlayerSDK "$TARGET_IOS_HLS" \
    iOSNoiseCancellationModels "$TARGET_IOS_NOISE_CANCEL" \
    flutter "$NEW_FLUTTER_FIELD"
  ok "wrote packages/hmssdk_flutter/lib/assets/sdk-versions.json"
fi

# 2-5. Update version: lines in pubspecs that need it.
write_pubspec_version() {
  local pubspec="$1" new_version="$2"
  sed_inplace -E "s|^(version:[[:space:]]+).*$|\1${new_version}|" "$pubspec"
}

if [[ "$HMSSDK_PUBSPEC_CHANGED" == true ]]; then
  write_pubspec_version "$HMSSDK_PUBSPEC" "$NEW_HMSSDK_VERSION"
  ok "wrote packages/hmssdk_flutter/pubspec.yaml"
fi

if [[ "$HMSSDK_EXAMPLE_PUBSPEC_CHANGED" == true ]]; then
  write_pubspec_version "$HMSSDK_EXAMPLE_PUBSPEC" "$NEW_HMSSDK_VERSION"
  ok "wrote packages/hmssdk_flutter/example/pubspec.yaml"
fi

if [[ "$ROOM_KIT_EXAMPLE_PUBSPEC_CHANGED" == true ]]; then
  write_pubspec_version "$ROOM_KIT_EXAMPLE_PUBSPEC" "$NEW_ROOM_KIT_VERSION"
  ok "wrote packages/hms_room_kit/example/pubspec.yaml"
fi

if [[ "$ROOM_KIT_PUBSPEC_CHANGED" == true ]]; then
  # Update version line if the package version itself changed.
  if [[ "$CURRENT_ROOM_KIT_VERSION" != "$NEW_ROOM_KIT_VERSION" ]]; then
    write_pubspec_version "$ROOM_KIT_PUBSPEC" "$NEW_ROOM_KIT_VERSION"
  fi
  # Update the hmssdk_flutter dep line if the dep value changed.
  # Captures the prefix (indent + key + spacing), then the existing operator
  # + version core (greedy until whitespace). Replaces with the new value.
  if [[ "$CURRENT_ROOM_KIT_HMSSDK_DEP_RAW" != "$NEW_ROOM_KIT_HMSSDK_DEP" ]]; then
    sed_inplace -E "s|^([[:space:]]+hmssdk_flutter:[[:space:]]+)[\^~]?[0-9][^[:space:]]*|\1${NEW_ROOM_KIT_HMSSDK_DEP}|" "$ROOM_KIT_PUBSPEC"
  fi
  ok "wrote packages/hms_room_kit/pubspec.yaml"
fi

# ============================================================================
# FLUTTER PUB GET (parallel)
# ============================================================================

if [[ "$NO_INSTALL" == true ]]; then
  echo
  warn "(skipped flutter pub get — lock files not refreshed)"
else
  echo
  info "Running flutter pub get in 4 directories in parallel..."
  pids=()
  for dir in "${INSTALL_DIRS[@]}"; do
    (
      cd "$ROOT_DIR/$dir"
      flutter pub get >/dev/null 2>&1 && printf "  ${C_GREEN}✓${C_RESET} %s\n" "$dir" \
        || { printf "  ${C_RED}✗${C_RESET} %s\n" "$dir"; exit 1; }
    ) &
    pids+=($!)
  done
  failed=0
  for pid in "${pids[@]}"; do
    wait "$pid" || failed=1
  done
  if [[ "$failed" == 1 ]]; then
    err "One or more flutter pub get invocations failed."
    exit 1
  fi
fi

# ============================================================================
# CHANGELOG REFRESH
# ============================================================================

echo
info "Updating ExampleAppChangelog.txt version block..."
node "$SCRIPT_DIR/update-changelog-versions.js"

# ============================================================================
# SUMMARY
# ============================================================================

echo
ok "Done."
echo
echo "Suggested commit message:"
echo "-----"
{
  # Pick a headline based on whether this is a real bump or a drift-only fix.
  if [[ "$CURRENT_HMSSDK_VERSION"   != "$NEW_HMSSDK_VERSION"   ]] || \
     [[ "$CURRENT_ROOM_KIT_VERSION" != "$NEW_ROOM_KIT_VERSION" ]] || \
     [[ "$CURRENT_IOS_SDK"          != "$TARGET_IOS_SDK"       ]] || \
     [[ "$CURRENT_ANDROID_SDK"      != "$TARGET_ANDROID_SDK"   ]]; then
    echo "chore: bump native SDK versions and Flutter packages"
  else
    echo "chore: sync drifted version fields"
  fi
  echo
  if [[ "$CURRENT_IOS_SDK"          != "$TARGET_IOS_SDK"          ]]; then echo "- HMSSDK iOS: $CURRENT_IOS_SDK -> $TARGET_IOS_SDK"; fi
  if [[ "$CURRENT_ANDROID_SDK"      != "$TARGET_ANDROID_SDK"      ]]; then echo "- HMSSDK Android: $CURRENT_ANDROID_SDK -> $TARGET_ANDROID_SDK"; fi
  if [[ "$CURRENT_IOS_BROADCAST"    != "$TARGET_IOS_BROADCAST"    ]]; then echo "- iOSBroadcastExtension: $CURRENT_IOS_BROADCAST -> $TARGET_IOS_BROADCAST"; fi
  if [[ "$CURRENT_IOS_HLS"          != "$TARGET_IOS_HLS"          ]]; then echo "- iOSHLSPlayerSDK: $CURRENT_IOS_HLS -> $TARGET_IOS_HLS"; fi
  if [[ "$CURRENT_IOS_NOISE_CANCEL" != "$TARGET_IOS_NOISE_CANCEL" ]]; then echo "- iOSNoiseCancellationModels: $CURRENT_IOS_NOISE_CANCEL -> $TARGET_IOS_NOISE_CANCEL"; fi
  if [[ "$CURRENT_HMSSDK_VERSION" != "$NEW_HMSSDK_VERSION"   ]]; then echo "- hmssdk_flutter: $CURRENT_HMSSDK_VERSION -> $NEW_HMSSDK_VERSION"; fi
  if [[ "$CURRENT_HMSSDK_EXAMPLE_VERSION" != "$NEW_HMSSDK_VERSION" && "$CURRENT_HMSSDK_VERSION" == "$NEW_HMSSDK_VERSION" ]]; then echo "- hmssdk_flutter example pubspec: $CURRENT_HMSSDK_EXAMPLE_VERSION -> $NEW_HMSSDK_VERSION (drift auto-correction)"; fi
  if [[ "$CURRENT_ROOM_KIT_VERSION" != "$NEW_ROOM_KIT_VERSION" ]]; then echo "- hms_room_kit: $CURRENT_ROOM_KIT_VERSION -> $NEW_ROOM_KIT_VERSION"; fi
  if [[ "$CURRENT_ROOM_KIT_EXAMPLE_VERSION" != "$NEW_ROOM_KIT_VERSION" && "$CURRENT_ROOM_KIT_VERSION" == "$NEW_ROOM_KIT_VERSION" ]]; then echo "- hms_room_kit example pubspec: $CURRENT_ROOM_KIT_EXAMPLE_VERSION -> $NEW_ROOM_KIT_VERSION (drift auto-correction)"; fi
  if [[ "$CURRENT_ROOM_KIT_HMSSDK_DEP_RAW" != "$NEW_ROOM_KIT_HMSSDK_DEP" && "$CURRENT_HMSSDK_VERSION" == "$NEW_HMSSDK_VERSION" ]]; then echo "- hms_room_kit hmssdk_flutter dep: $CURRENT_ROOM_KIT_HMSSDK_DEP_RAW -> $NEW_ROOM_KIT_HMSSDK_DEP (drift auto-correction)"; fi
}
echo "-----"

# Pod install reminder if any iOS native version changed.
if [[ "$CURRENT_IOS_SDK"          != "$TARGET_IOS_SDK"          ]] || \
   [[ "$CURRENT_IOS_BROADCAST"    != "$TARGET_IOS_BROADCAST"    ]] || \
   [[ "$CURRENT_IOS_HLS"          != "$TARGET_IOS_HLS"          ]] || \
   [[ "$CURRENT_IOS_NOISE_CANCEL" != "$TARGET_IOS_NOISE_CANCEL" ]]; then
  echo
  warn "iOS native version changed. Refresh CocoaPods before any iOS build:"
  echo "  cd packages/hmssdk_flutter/example/ios && pod install"
fi
