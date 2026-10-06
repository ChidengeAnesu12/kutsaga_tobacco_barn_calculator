import 'engineering_warning.dart';

/// sealed → every switch over this type must handle all three subtypes,
/// or the app doesn't compile. That's deliberate: see the note above.
sealed class VentilationResult {
  const VentilationResult();
}

class Kcc1VentilationResult extends VentilationResult {
  final double bottomVentLengthMm;
  final double bottomVentHeightMm;
  final double topVentWidthMm;
  final double topVentLengthMm;

  const Kcc1VentilationResult({
    required this.bottomVentLengthMm,
    required this.bottomVentHeightMm,
    required this.topVentWidthMm,
    required this.topVentLengthMm,
  });
}

class RocketVentilationResult extends VentilationResult {
  final double largeVentLengthMm;
  final double largeVentHeightMm;
  final EngineeringWarning smallVentSize;

  /// Fractional by design (Phase 1 finding #5) — not an
  /// EngineeringWarning, since the workbook has no minimum on "quantity."
  final double smallVentQuantityRaw;

  const RocketVentilationResult({
    required this.largeVentLengthMm,
    required this.largeVentHeightMm,
    required this.smallVentSize,
    required this.smallVentQuantityRaw,
  });
}

class ConventionalVentilationResult extends VentilationResult {
  final double totalVentAreaM2;
  final int numberOfVents;
  final int bottomVents;
  final int topVents;
  final double areaPerVentM2;
  final EngineeringWarning equivalentVentSide;

  const ConventionalVentilationResult({
    required this.totalVentAreaM2,
    required this.numberOfVents,
    required this.bottomVents,
    required this.topVents,
    required this.areaPerVentM2,
    required this.equivalentVentSide,
  });
}