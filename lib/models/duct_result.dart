import 'engineering_warning.dart';

class DuctResult {
  final EngineeringWarning ductWidth;
  final EngineeringWarning bottomDuctHeight;

  /// Null for Rocket — the workbook has no "top duct height" row for
  /// Rocket barns (Phase 1 finding).
  final EngineeringWarning? topDuctHeight;

  const DuctResult({
    required this.ductWidth,
    required this.bottomDuctHeight,
    this.topDuctHeight,
  });
}