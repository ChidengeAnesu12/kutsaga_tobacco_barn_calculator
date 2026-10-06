/// Minimum practical construction dimensions, from the "LIMITATIONS" sheet.
/// These never silently overwrite a calculated value — see
/// EngineeringValidator in Part 2 for how calculated vs. recommended vs.
/// below-minimum status gets built from these.
class EngineeringLimits {
  EngineeringLimits._();

  static const double minFurnaceWidthMm = 350;
  static const double minFurnaceLengthMm = 1000;
  static const double minFurnaceHeightMm = 500;
  static const double minDuctWidthMm = 540;

  /// LIMITATIONS!C9 gives one "Duct Height" minimum, not separate values
  /// for KCC1's bottom vs. top duct height. We apply it to both —
  /// flagged explicitly here rather than silently picking one.
  static const double minDuctHeightMm = 300;

  static const double minConventionalVentMm = 300; // 300 × 300 square
  static const double minRocketInletVentMm = 100; // 100 × 100 square
}