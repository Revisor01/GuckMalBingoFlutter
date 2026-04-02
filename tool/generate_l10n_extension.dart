// Generates lib/utilities/app_localizations_extension.dart from app_de.arb.
// Usage: dart run tool/generate_l10n_extension.dart

import 'dart:convert';
import 'dart:io';

void main() {
  final arbFile = File('lib/l10n/app_de.arb');
  if (!arbFile.existsSync()) {
    stderr.writeln('ERROR: lib/l10n/app_de.arb not found. Run from project root.');
    exit(1);
  }

  final Map<String, dynamic> arb = jsonDecode(arbFile.readAsStringSync());

  // Collect keys that have placeholders (these are methods, not getters)
  final keysWithPlaceholders = <String>{};
  for (final key in arb.keys) {
    if (key.startsWith('@') && key != '@@locale') {
      final meta = arb[key];
      if (meta is Map && meta.containsKey('placeholders')) {
        // Strip leading '@' to get the actual key name
        keysWithPlaceholders.add(key.substring(1));
      }
    }
  }

  // Filter: keep only simple getter keys
  final keys = arb.keys.where((key) {
    if (key.startsWith('@')) return false; // skip @@locale and @metadata keys
    if (keysWithPlaceholders.contains(key)) return false; // skip placeholder methods
    return true;
  }).toList()
    ..sort();

  // Generate output
  final buffer = StringBuffer();
  buffer.writeln('// GENERATED FILE — DO NOT EDIT BY HAND');
  buffer.writeln('// Run: dart run tool/generate_l10n_extension.dart');
  buffer.writeln();
  buffer.writeln("import '../l10n/app_localizations.dart';");
  buffer.writeln();
  buffer.writeln('extension AppLocalizationsX on AppLocalizations {');
  buffer.writeln('  static final _map = <String, String Function(AppLocalizations)>{');

  for (final key in keys) {
    buffer.writeln("    '$key': (l) => l.$key,");
  }

  buffer.writeln('  };');
  buffer.writeln();
  buffer.writeln('  String? getByKey(String key) => _map[key]?.call(this);');
  buffer.writeln('}');

  final outFile = File('lib/utilities/app_localizations_extension.dart');
  outFile.writeAsStringSync(buffer.toString());

  stdout.writeln('Generated ${keys.length} keys in ${outFile.path}');
}
