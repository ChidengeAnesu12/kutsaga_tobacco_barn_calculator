/// A calculated dimension checked against Kutsaga's published minimum.
/// belowMinimum and recommendedMm are derived getters, not stored
/// fields — they can never drift out of sync with calculatedMm.
class EngineeringWarning {
  final String dimensionLabel;
  final double calculatedMm;
  final double minimumMm;

  const EngineeringWarning({
    required this.dimensionLabel,
    required this.calculatedMm,
    required this.minimumMm,
  });

  bool get belowMinimum => calculatedMm < minimumMm;

  /// max(calculated, minimum) — offered alongside calculatedMm, never
  /// replacing it (master spec section 19: no silent substitution).
  double get recommendedMm => belowMinimum ? minimumMm : calculatedMm;
}