import 'dart:math' show sqrt;

import '../core/constants/engineering_limits.dart';
import '../models/duct_result.dart';
import '../models/furnace_result.dart';
import '../models/ventilation_result.dart';
import 'engineering_validator.dart';
import 'kcc1_calculator.dart' show calculateKcc1StyleFurnaceAndDuct;

class ConventionalCalculator {
  const ConventionalCalculator();

  ({ConventionalVentilationResult ventilation, FurnaceResult furnace, DuctResult duct}) calculate({
    required double floorAreaM2,
    required double volumeMm3,
  }) {
    const numberOfVents = 8; // CALCULATOR!K19
    const bottomVents = 4; // K20
    const topVents = 4; // K21

    final totalVentAreaM2 = 0.025 * floorAreaM2; // K18
    final areaPerVentM2 = totalVentAreaM2 / numberOfVents; // K22
    final equivalentSideMm = sqrt(areaPerVentM2) * 1000; // K23

    final ventilation = ConventionalVentilationResult(
      totalVentAreaM2: totalVentAreaM2,
      numberOfVents: numberOfVents,
      bottomVents: bottomVents,
      topVents: topVents,
      areaPerVentM2: areaPerVentM2,
      equivalentVentSide: const EngineeringValidator().evaluate(
        dimensionLabel: 'Vent opening (equivalent square side)',
        calculatedMm: equivalentSideMm,
        minimumMm: EngineeringLimits.minConventionalVentMm,
      ),
    );

    // Conventional shares KCC1's exact furnace/duct formulas (Phase 1
    // finding) — reused, not duplicated.
    final furnaceAndDuct = calculateKcc1StyleFurnaceAndDuct(volumeMm3);

    return (ventilation: ventilation, furnace: furnaceAndDuct.furnace, duct: furnaceAndDuct.duct);
  }
}