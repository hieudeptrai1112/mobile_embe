import 'dart:ui';

/// Converts Figma hex strings (#RRGGBB or #RRGGBBAA) to Flutter [Color].
Color colorFromHex(String hex) {
  final h = hex.replaceFirst('#', '').toUpperCase();
  if (h.length == 8) {
    return Color(int.parse('0x${h.substring(6)}${h.substring(0, 6)}'));
  }
  return Color(int.parse('0xFF$h'));
}
