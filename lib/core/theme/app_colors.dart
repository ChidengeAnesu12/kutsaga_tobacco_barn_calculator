import 'package:flutter/material.dart';

/// Kutsaga's real brand colours — from the organisation's own brand
/// guide (CMYK: C80 M40 Y100 K38 / C85 M62 Y0 K0 / C72 M38 Y37 K68),
/// cross-checked by sampling pixels from the real logo file. The green
/// matched closely; the blue didn't (muted #2F67B0 in the actual
/// artwork vs. a vivid #2661FF from a literal CMYK conversion) — the
/// sampled value is used here, since it's what sits next to the real
/// logo asset in the app.
class AppColors {
  AppColors._();

  static const vibrantGreen = Color(0xFF225800); // dominant — the leaf in the real logo
  static const deepBlue = Color(0xFF2F67B0); // accent — the "test tube" detail in the real logo
  static const textPrimary = Color(0xFF173333); // CMYK-derived; no artwork region to cross-check against

  static const background = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);

  static const statusNormal = vibrantGreen;
  static const statusBelowMinimum = Color(0xFFF9A825);
  static const statusInvalid = Color(0xFFC62828);
}