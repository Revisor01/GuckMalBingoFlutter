#!/bin/bash
# Xcode Cloud nach dem Klonen: Build-Nummer, Signierung, Flutter, Pods. Test: tool/xcode_cloud_test.sh
set -euo pipefail

REPO="${CI_PRIMARY_REPOSITORY_PATH:?Nur fuer Xcode Cloud gedacht.}"
APP="$REPO"
PUBSPEC="$APP/pubspec.yaml"
PBXPROJ="$APP/ios/Runner.xcodeproj/project.pbxproj"
RELEASE_KONFIG='97C147071CF9000F007C117D /* Release */ = {'

fehler() { echo "FEHLER: $*" >&2; exit 1; }

# Liegt die Cloud-Build-Nummer nicht ueber pubspec, lehnt App Store Connect erst nach dem Build ab.
[ "$(grep -c '^version: ' "$PUBSPEC")" = 1 ] || fehler "pubspec.yaml hat nicht genau eine version-Zeile."
ZEILE=$(grep '^version: ' "$PUBSPEC")
[[ "$ZEILE" =~ ^version:\ ([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)$ ]] || fehler "'$ZEILE' hat nicht die Form X.Y.Z+BUILD."
VERSION="${BASH_REMATCH[1]}"
BUILD_ALT="${BASH_REMATCH[2]}"
[[ "${CI_BUILD_NUMBER:?}" =~ ^[0-9]+$ ]] || fehler "CI_BUILD_NUMBER '$CI_BUILD_NUMBER' ist keine Zahl."
if [ "$CI_BUILD_NUMBER" -le "$BUILD_ALT" ]; then
  fehler "Xcode-Cloud-Build $CI_BUILD_NUMBER liegt nicht ueber $BUILD_ALT aus pubspec.yaml. In App Store Connect unter Xcode Cloud > Settings > Build Number die naechste Nummer hoeher setzen."
fi

# Nur der Klon wird auf automatisches Signieren umgestellt, und nur bei genau den erwarteten Zeilen.
if ! awk -v kopf="$RELEASE_KONFIG" '
  index($0, kopf) { drin = 1; bloecke++ }
  drin && index($0, "\"CODE_SIGN_IDENTITY[sdk=iphoneos*]\" = \"Apple Distribution\";") { sub(/Apple Distribution/, "Apple Development"); a++ }
  drin && index($0, "CODE_SIGN_STYLE = Manual;") { sub(/Manual/, "Automatic"); b++ }
  drin && index($0, "PROVISIONING_PROFILE_SPECIFIER = \"GuckMal AppStore\";") { sub(/"GuckMal AppStore"/, "\"\""); c++ }
  drin && index($0, "name = Release;") { drin = 0 }
  { print }
  END { exit !(bloecke == 1 && a == 1 && b == 1 && c == 1) }
' "$PBXPROJ" > "$PBXPROJ.neu"; then
  rm -f "$PBXPROJ.neu"
  fehler "Die Release-Konfiguration von Runner signiert nicht wie erwartet fest (Apple Distribution, Manual, Profil 'GuckMal AppStore')."
fi
mv "$PBXPROJ.neu" "$PBXPROJ"

sed -i.vorher "s/^version: .*/version: $VERSION+$CI_BUILD_NUMBER/" "$PUBSPEC"
rm "$PUBSPEC.vorher"
echo "Version $VERSION, Build $CI_BUILD_NUMBER, Signieren automatisch."

export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_CLEANUP=1
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
export PATH="$HOME/flutter/bin:$PATH"
flutter precache --ios

cd "$APP"
flutter pub get
grep -qx "FLUTTER_BUILD_NUMBER=$CI_BUILD_NUMBER" ios/Flutter/Generated.xcconfig \
  || fehler "Generated.xcconfig traegt nicht Build $CI_BUILD_NUMBER."

brew install cocoapods
cd "$APP/ios"
for versuch in 1 2 3; do
  pod install && break
  [ "$versuch" -lt 3 ] || fehler "pod install nach 3 Versuchen fehlgeschlagen."
  sleep 20
done
