#!/bin/bash
# Prueft ios/ci_scripts/ci_post_clone.sh gegen Kopien von pubspec.yaml und
# project.pbxproj. git, flutter, brew, pod und sleep sind Attrappen, die ihre
# Aufrufe mitschreiben; das Skript laeuft sonst erst in Xcode Cloud.
set -euo pipefail

WURZEL=$(cd "$(dirname "$0")/.." && pwd)
SKRIPT="$WURZEL/ios/ci_scripts/ci_post_clone.sh"
PBX=ios/Runner.xcodeproj/project.pbxproj
ARBEIT=$(mktemp -d)
trap 'rm -rf "$ARBEIT"' EXIT
LOG="$ARBEIT/aufrufe"
fehlschlaege=0

pruefe() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; fehlschlaege=$((fehlschlaege + 1)); fi; }

mkdir -p "$ARBEIT/bin" "$ARBEIT/home/flutter/bin"
for name in git brew sleep; do
  printf '#!/bin/bash\necho "%s $*" >> "%s"\n' "$name" "$LOG" > "$ARBEIT/bin/$name"
done
# pod schlaegt so oft fehl, wie POD_FEHLER angibt.
cat > "$ARBEIT/bin/pod" <<EOF
#!/bin/bash
echo "pod \$*" >> "$LOG"
n=\$(grep -c '^pod ' "$LOG")
[ "\$n" -gt "\${POD_FEHLER:-0}" ]
EOF
# flutter pub get schreibt Generated.xcconfig aus pubspec.yaml wie das echte.
cat > "$ARBEIT/home/flutter/bin/flutter" <<EOF
#!/bin/bash
echo "flutter \$*" >> "$LOG"
if [ "\$1" = pub ]; then
  v=\$(sed -n 's/^version: //p' pubspec.yaml)
  printf 'FLUTTER_BUILD_NAME=%s\nFLUTTER_BUILD_NUMBER=%s\n' "\${v%+*}" "\${v#*+}" > ios/Flutter/Generated.xcconfig
fi
EOF
chmod +x "$ARBEIT"/bin/* "$ARBEIT/home/flutter/bin/flutter"

kopie() {
  local d="$ARBEIT/$1"
  mkdir -p "$d/ios/Flutter"
  cp "$WURZEL/pubspec.yaml" "$d/"
  cp -R "$WURZEL/ios/Runner.xcodeproj" "$d/ios/"
  echo "$d"
}
ohne_release() {
  awk 'index($0, "97C147071CF9000F007C117D /* Release */ = {") { d = 1 } !d { print } d && index($0, "name = Release;") { d = 0 }' "$1"
}
lauf() {
  : > "$LOG"
  HOME="$ARBEIT/home" PATH="$ARBEIT/bin:$PATH" CI_PRIMARY_REPOSITORY_PATH="$1" CI_BUILD_NUMBER="$2" \
    POD_FEHLER="${3:-0}" "$SKRIPT" > "$ARBEIT/ausgabe" 2>&1
}

ALT=$(sed -n 's/^version: //p' "$WURZEL/pubspec.yaml")
NAME="${ALT%+*}"
BUILD="${ALT#*+}"
NEU=$((BUILD + 1))

echo "Build $NEU wird uebernommen"
d=$(kopie neu)
pruefe "Skript endet ohne Fehler" "lauf '$d' $NEU"
pruefe "pubspec.yaml traegt $NAME+$NEU" "grep -qx 'version: $NAME+$NEU' '$d/pubspec.yaml'"
pruefe "pubspec.yaml sonst unveraendert" "[ \"\$(diff '$WURZEL/pubspec.yaml' '$d/pubspec.yaml' | grep -c '^[<>]')\" = 2 ]"
erwartet=$(printf '%s\n' \
  '> 				"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Development";' \
  '> 				CODE_SIGN_STYLE = Automatic;' \
  '> 				PROVISIONING_PROFILE_SPECIFIER = "";')
pruefe "genau drei Signier-Zeilen umgestellt" "[ \"\$(diff '$WURZEL/$PBX' '$d/$PBX' | grep '^>')\" = \"\$erwartet\" ]"
pruefe "ausserhalb der Release-Konfiguration von Runner nichts geaendert" "[ \"\$(ohne_release '$WURZEL/$PBX')\" = \"\$(ohne_release '$d/$PBX')\" ]"
pruefe "kein festes Profil mehr" "! grep -qE 'GuckMal AppStore|Apple Distribution|CODE_SIGN_STYLE = Manual;' '$d/$PBX'"
pruefe "Aufrufe in dieser Reihenfolge" "[ \"\$(cut -d' ' -f1-3 '$LOG')\" = \"\$(printf 'git clone https://github.com/flutter/flutter.git\nflutter precache --ios\nflutter pub get\nbrew install cocoapods\npod install')\" ]"

echo "Build $BUILD (gleich) wird abgelehnt, ohne etwas zu aendern"
d=$(kopie gleich)
pruefe "Skript bricht ab" "! lauf '$d' $BUILD"
pruefe "Hinweis auf App Store Connect" "grep -q 'Xcode Cloud > Settings > Build Number' '$ARBEIT/ausgabe'"
pruefe "pubspec.yaml unveraendert" "cmp -s '$WURZEL/pubspec.yaml' '$d/pubspec.yaml'"
pruefe "project.pbxproj unveraendert" "cmp -s '$WURZEL/$PBX' '$d/$PBX'"
pruefe "nichts installiert" "[ ! -s '$LOG' ]"

echo "Schon umgestellte Signierung wird abgelehnt"
d="$ARBEIT/neu"
cp "$d/$PBX" "$ARBEIT/umgestellt"
pruefe "Skript bricht ab" "! lauf '$d' $((NEU + 1))"
pruefe "project.pbxproj unveraendert" "cmp -s '$ARBEIT/umgestellt' '$d/$PBX'"
pruefe "nichts installiert" "[ ! -s '$LOG' ]"

echo "pod install wird bis zu dreimal versucht"
d=$(kopie zweimal)
pruefe "zwei Fehlschlaege, dann Erfolg" "lauf '$d' $NEU 2"
pruefe "drei pod-Aufrufe" "[ \"\$(grep -c '^pod ' '$LOG')\" = 3 ]"
d=$(kopie dreimal)
pruefe "drei Fehlschlaege brechen ab" "! lauf '$d' $NEU 3"
pruefe "nicht mehr als drei Versuche" "[ \"\$(grep -c '^pod ' '$LOG')\" = 3 ]"

[ "$fehlschlaege" = 0 ] || { echo "$fehlschlaege Pruefungen fehlgeschlagen."; exit 1; }
echo "Alle Pruefungen bestanden."
