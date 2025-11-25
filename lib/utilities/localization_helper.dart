/// Helper für Localization Key Konvertierung
class LocalizationHelper {
  /// Konvertiert iOS-Style Keys (item.rotes_auto) zu Flutter ARB Keys (itemRotesAuto)
  static String convertKeyToCamelCase(String key) {
    // Entferne Sonderzeichen außer . und _
    key = key.replaceAll(RegExp(r'[^\w._]'), '_');

    // Ersetze deutsche Umlaute
    key = key
        .replaceAll('ä', 'ae')
        .replaceAll('ö', 'oe')
        .replaceAll('ü', 'ue')
        .replaceAll('Ä', 'Ae')
        .replaceAll('Ö', 'Oe')
        .replaceAll('Ü', 'Ue')
        .replaceAll('ß', 'ss');

    // Split by . or _
    final parts = key.replaceAll('.', '_').split('_');
    final filtered = parts.where((p) => p.isNotEmpty).toList();

    if (filtered.isEmpty) return 'emptyKey';

    // Convert to camelCase: first part lowercase, rest capitalized
    String result = filtered[0].toLowerCase();
    for (var i = 1; i < filtered.length; i++) {
      result += filtered[i][0].toUpperCase() + filtered[i].substring(1).toLowerCase();
    }

    // Prefix if starts with number
    if (result.isNotEmpty && result[0].codeUnitAt(0) >= 48 && result[0].codeUnitAt(0) <= 57) {
      result = 'key${result[0].toUpperCase()}${result.substring(1)}';
    }

    // Fallback
    if (result.isEmpty || (result[0].codeUnitAt(0) < 65 && result[0].codeUnitAt(0) > 122)) {
      result = 'key$result';
    }

    return result;
  }
}
