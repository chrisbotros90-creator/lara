#!/bin/bash
set -euo pipefail

rm -rf build/
mkdir -p build

echo "Build Started!"
echo

# Auto-detect latest installed iOS SDK
SDK=$(xcodebuild -showsdks 2>/dev/null | grep "iphoneos" | grep -v simulator | tail -1 | grep -oE 'iphoneos[0-9.]+')
echo "Using SDK: $SDK"
echo

xcodebuild \
  -project lara.xcodeproj \
  -scheme lara \
  -configuration Debug \
  -sdk "$SDK" \
  ARCHS=arm64e \
  ONLY_ACTIVE_ARCH=NO \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGN_ENTITLEMENTS="Config/lara.entitlements" \
  IPHONEOS_DEPLOYMENT_TARGET=16.0 \
  ENABLE_BITCODE=NO \
  archive \
  -archivePath "$PWD/build/lara.xcarchive"

APP_PATH="$PWD/build/lara.xcarchive/Products/Applications/lara.app"
if [ ! -d "$APP_PATH" ]; then
  echo "ERROR: Missing app at $APP_PATH"
  exit 1
fi

rm -rf "$PWD/build/Payload"
mkdir -p "$PWD/build/Payload"
cp -R "$APP_PATH" "$PWD/build/Payload/"

plutil -replace UIFileSharingEnabled -bool YES "$PWD/build/Payload/lara.app/Info.plist"

if ! command -v ldid >/dev/null 2>&1; then
  echo "ERROR: ldid not installed. Run: brew install ldid" >&2
  exit 1
fi

ldid -SConfig/lara.entitlements "$PWD/build/Payload/lara.app/lara"
(cd "$PWD/build" && /usr/bin/zip -qry lara.ipa Payload)

echo
echo "Build successful!"
echo "IPA at: build/lara.ipa"
exit 0
