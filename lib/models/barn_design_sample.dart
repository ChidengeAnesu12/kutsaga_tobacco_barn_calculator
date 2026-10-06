/// One real, as-built barn from Kutsaga's own Design Database — the
/// same sheet BarnHistoryRepository's "KCC1-1" style labels are modelled
/// on (Part 1, Phase 1 finding #9). Reference data to look up, never
/// read by BarnCalculator.
///
/// Several fields are nullable because the sheet genuinely doesn't
/// record them for every type: Rocket has no "Top Duct H" or "Vent L/H"
/// columns; "Small Vent" only applies to Rocket's inlet vents.
class BarnDesignSample {
  final String label; // e.g. "KCC1-1", matching the sheet's own naming
  final double lengthMm;
  final double widthMm;
  final double floorAreaM2;
  final double furnaceLengthMm;
  final double furnaceWidthMm;
  final double furnaceHeightMm;
  final double bottomDuctHeightMm;
  final double? topDuctHeightMm;
  final double ductWidthMm;
  final double? ventLengthMm;
  final double? ventHeightMm;
  final double? bigVentLengthMm;
  final double? bigVentHeightMm;
  final double? smallVentMm;
  final int? smallVentQuantity;

  const BarnDesignSample({
    required this.label,
    required this.lengthMm,
    required this.widthMm,
    required this.floorAreaM2,
    required this.furnaceLengthMm,
    required this.furnaceWidthMm,
    required this.furnaceHeightMm,
    required this.bottomDuctHeightMm,
    this.topDuctHeightMm,
    required this.ductWidthMm,
    this.ventLengthMm,
    this.ventHeightMm,
    this.bigVentLengthMm,
    this.bigVentHeightMm,
    this.smallVentMm,
    this.smallVentQuantity,
  });
}