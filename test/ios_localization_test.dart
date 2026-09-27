import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Der App Store zeigt unter „Sprachen“ nur, wofür ein .lproj-Ordner im
/// App-Paket liegt – CFBundleLocalizations allein reicht nicht. Ohne diese
/// Ordner stand dort bis 2.1.0 nur „Deutsch“, obwohl die App 6 Sprachen kann.
void main() {
  final appLanguages = Directory('lib/l10n')
      .listSync()
      .map((f) => RegExp(r'app_(\w+)\.arb$').firstMatch(f.path)?.group(1))
      .whereType<String>()
      .toList()
    ..sort();

  test('app has the six expected languages', () {
    expect(appLanguages, ['de', 'en', 'es', 'fr', 'it', 'nl']);
  });

  final pbxproj = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
  final infoPlist = File('ios/Runner/Info.plist').readAsStringSync();

  for (final lang in appLanguages) {
    test('$lang: iOS language folder exists and is in the Xcode project', () {
      expect(File('ios/Runner/$lang.lproj/InfoPlist.strings').existsSync(), isTrue);
      expect(pbxproj, contains('path = $lang.lproj/InfoPlist.strings;'));
      expect(
        RegExp(r'knownRegions = \(([^)]*)\)').firstMatch(pbxproj)!.group(1),
        contains(RegExp('\\b$lang,')),
      );
    });

    test('$lang: listed in CFBundleLocalizations', () {
      expect(infoPlist, contains('<string>$lang</string>'));
    });
  }

  test('InfoPlist.strings is copied into the app bundle', () {
    expect(pbxproj, contains('/* InfoPlist.strings in Resources */,'));
  });
}
