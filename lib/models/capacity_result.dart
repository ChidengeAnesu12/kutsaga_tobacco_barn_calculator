class CapacityResult {
  final double floorAreaM2;
  final double volumeM3;
  final double volumeMm3; // preserved raw — the engineering formulas need it
  final double clipsPerTier;
  final double totalStrings;
  final double estimatedLeaves;
  final double capacityHectares;

  const CapacityResult({
    required this.floorAreaM2,
    required this.volumeM3,
    required this.volumeMm3,
    required this.clipsPerTier,
    required this.totalStrings,
    required this.estimatedLeaves,
    required this.capacityHectares,
  });
}