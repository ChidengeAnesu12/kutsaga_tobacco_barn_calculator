import '../core/constants/kutsaga_constants.dart';
import '../models/barn_input.dart';
import '../models/capacity_result.dart';

class CapacityCalculator {
  const CapacityCalculator();

  CapacityResult calculate(BarnInput input) {
    final floorAreaM2 = input.lengthMm * input.widthMm / 1e6; // CALCULATOR!E5
    final volumeMm3 = input.volumeMm3; // CALCULATOR!F6

    // Corrected physical conversion — Excel's own E6 divides by 1e6 and
    // mislabels the result "m³" (Phase 1 finding #1).
    final volumeM3 = volumeMm3 / 1e9;

    final clipsPerTier = input.widthMm / KutsagaConstants.hookToHookMm; // E8
    final totalStrings = (input.horizontalPoles - 1) * input.poleTiers * clipsPerTier; // E9
    final estimatedLeaves = totalStrings * KutsagaConstants.averageLeavesPerClip; // E10
    final capacityHectares = estimatedLeaves / KutsagaConstants.leavesPerHectare; // E11

    return CapacityResult(
      floorAreaM2: floorAreaM2,
      volumeM3: volumeM3,
      volumeMm3: volumeMm3,
      clipsPerTier: clipsPerTier,
      totalStrings: totalStrings,
      estimatedLeaves: estimatedLeaves,
      capacityHectares: capacityHectares,
    );
  }
}