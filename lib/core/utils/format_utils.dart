/// Presentation-only number formatting.
///
/// The calculation engine (Part 2) always returns full, unrounded
/// precision. Screens call these helpers only at the point of display —
/// never before, and never to feed a value back into another formula
/// (see master spec section 35: don't round intermediate calculations).
library;

String formatDecimal(double value, int decimals) => value.toStringAsFixed(decimals);

/// e.g. formatThousands(18214.71) == '18,215'
/// Written by hand instead of pulling in `intl` — it's one well-known
/// string operation, and the spec asks us to avoid unnecessary packages.
String formatThousands(double value) {
  final rounded = value.round();
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    if (i != 0 && remaining % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return rounded < 0 ? '-$buffer' : buffer.toString();
}

/// Turns free text (a person's name, say) into a safe filename
/// fragment — letters, digits, and underscores only.
String sanitizeForFilename(String value) {
  final cleaned = value.trim().replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_');
  return cleaned.isEmpty ? 'unknown' : cleaned;
}