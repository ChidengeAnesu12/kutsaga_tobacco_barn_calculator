/// Pure, widget-free validation helpers.
///
/// Each returns `null` when valid, or a short user-facing message when
/// not — the exact signature `TextFormField.validator` expects, so a
/// screen can wire one in directly:
///
///   TextFormField(validator: (v) => validatePositiveNumber(v, 'Barn length'))
///
/// Being plain functions (no BuildContext, no widgets) means we can
/// unit-test every validation rule with plain `test()` calls in Part 2 —
/// no pumping a widget tree required.
library;

String? validatePositiveNumber(String? rawValue, String fieldLabel) {
  if (rawValue == null || rawValue.trim().isEmpty) {
    return '$fieldLabel is required.';
  }
  // tryParse (not parse + try/catch) because "the user typed garbage"
  // is an expected, routine case here — not an exceptional one.
  final parsed = double.tryParse(rawValue.trim());
  if (parsed == null || parsed.isNaN || parsed.isInfinite) {
    return '$fieldLabel must be a valid number.';
  }
  if (parsed <= 0) {
    return '$fieldLabel must be greater than 0.';
  }
  return null;
}

String? validatePoleTiers(String? rawValue) {
  if (rawValue == null || rawValue.trim().isEmpty) {
    return 'Number of pole tiers is required.';
  }
  final parsed = int.tryParse(rawValue.trim());
  if (parsed == null) {
    return 'Number of pole tiers must be a whole number.';
  }
  if (parsed < 1) {
    return 'Number of pole tiers must be at least 1.';
  }
  return null;
}

String? validateHorizontalPoles(String? rawValue) {
  if (rawValue == null || rawValue.trim().isEmpty) {
    return 'Number of horizontal poles is required.';
  }
  final parsed = int.tryParse(rawValue.trim());
  if (parsed == null) {
    return 'Number of horizontal poles must be a whole number.';
  }
  // Formula computes (horizontalPoles - 1); 2 is the smallest value
  // that keeps that term at least 1.
  if (parsed < 2) {
    return 'Number of horizontal poles must be at least 2.';
  }
  return null;
}

String? validateRequiredText(String? rawValue, String fieldLabel) {
  if (rawValue == null || rawValue.trim().isEmpty) {
    return '$fieldLabel is required.';
  }
  return null;
}