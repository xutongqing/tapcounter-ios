#!/bin/bash
set -euo pipefail

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$project_dir"
mkdir -p build outputs

xcodebuild \
  -project TapCounter.xcodeproj \
  -scheme TapCounter \
  -configuration Release \
  -sdk iphoneos \
  -destination 'generic/platform=iOS' \
  -derivedDataPath build/device \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY='' \
  build > build/device-build.log 2>&1 || {
    tail -n 80 build/device-build.log
    exit 1
  }

package_dir="$(mktemp -d "$project_dir/build/package.XXXXXX")"
trap 'rm -rf "$package_dir"' EXIT
mkdir -p "$package_dir/Payload"
ditto build/device/Build/Products/Release-iphoneos/TapCounter.app "$package_dir/Payload/TapCounter.app"
(
  cd "$package_dir"
  /usr/bin/zip -q -r "$package_dir/TapCounter-unsigned.ipa" Payload
)
mv "$package_dir/TapCounter-unsigned.ipa" "$project_dir/outputs/TapCounter-unsigned.ipa"
printf 'Created: %s\n' "$project_dir/outputs/TapCounter-unsigned.ipa"
