import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ARB Localization Key Completeness', () {
    late Map<String, dynamic> templateArb;
    late Set<String> templateKeys;
    final locales = ['de', 'en', 'es', 'fr', 'it', 'nl'];

    setUp(() {
      final templateFile = File('lib/l10n/app_de.arb');
      templateArb = jsonDecode(templateFile.readAsStringSync());
      // Filter out metadata keys (starting with @)
      templateKeys = templateArb.keys
          .where((key) => !key.startsWith('@'))
          .toSet();
    });

    for (final locale in ['en', 'es', 'fr', 'it', 'nl']) {
      test('app_$locale.arb contains all keys from template (app_de.arb)', () {
        final file = File('lib/l10n/app_$locale.arb');
        expect(file.existsSync(), isTrue,
            reason: 'app_$locale.arb does not exist');

        final arb = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        final localeKeys = arb.keys
            .where((key) => !key.startsWith('@'))
            .toSet();

        final missingKeys = templateKeys.difference(localeKeys);
        expect(missingKeys, isEmpty,
            reason: 'app_$locale.arb is missing keys: ${missingKeys.join(', ')}');
      });
    }

    test('template (app_de.arb) has content', () {
      expect(templateKeys, isNotEmpty);
      expect(templateKeys.length, greaterThan(100),
          reason: 'Template should have >100 localization keys');
    });
  });
}
