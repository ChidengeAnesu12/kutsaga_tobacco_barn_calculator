import '../core/constants/engineering_limits.dart';
import '../core/constants/kutsaga_constants.dart';
import '../models/duct_result.dart';
import '../models/furnace_result.dart';
import '../models/ventilation_result.dart';
import 'engineering_validator.dart';

/// Furnace + duct dimensions for KCC1 — and, per Phase 1, the exact
/// same formulas Conventional barns use. Imported by
/// conventional_calculator.dart rather than duplicated there.
({FurnaceResult furnace, DuctResult duct}) calculateKcc1StyleFurnaceAndDuct(double volumeMm3) {
  final ratio = volumeMm3 / KutsagaConstants.kcc1ReferenceVolumeMm3;
  const validator = EngineeringValidator();

  final furnace = FurnaceResult(
    length: validator.evaluate(
      dimensionLabel: 'Furnace length',
      calculatedMm: 1762 * ratio, // CALCULATOR!E27
      minimumMm: EngineeringLimits.minFurnaceLengthMm,
    ),
    width: validator.evaluate(
      dimensionLabel: 'Furnace width',
      calculatedMm: 466.6 * ratio, // E28
      minimumMm: EngineeringLimits.minFurnaceWidthMm,
    ),
    height: validator.evaluate(
      dimensionLabel: 'Furnace height',
      calculatedMm: 646.6 * ratio, // E29
      minimumMm: EngineeringLimits.minFurnaceHeightMm,
    ),
  );

  final duct = DuctResult(
    ductWidth: validator.evaluate(
      dimensionLabel: 'Duct width',
      calculatedMm: 613 * ratio, // E32
      minimumMm: EngineeringLimits.minDuctWidthMm,
    ),
    bottomDuctHeight: validator.evaluate(
      dimensionLabel: 'Bottom duct height',
      calculatedMm: 425 * ratio, // E30
      minimumMm: EngineeringLimits.minDuctHeightMm,
    ),
    topDuctHeight: validator.evaluate(
      dimensionLabel: 'Top duct height',
      calculatedMm: 320 * ratio, // E31
      minimumMm: EngineeringLimits.minDuctHeightMm,
    ),
  );

  return (furnace: furnace, duct: duct);
}

/// Two of these four numbers are direct reuses of the duct values above
/// (E18 = duct width − 230; E19 = top duct height) — a real cell
/// cross-reference in the sheet, not a coincidence (Phase 1 finding #4).
/// We pass in the *calculated* duct values, never the clamped/
/// recommended ones, so a below-minimum duct never silently changes a
/// vent size.
Kcc1VentilationResult calculateKcc1Ventilation({
  required double ductWidthMm,
  required double topDuctHeightMm,
}) {
  final bottomVentLengthMm = ductWidthMm - 230; // CALCULATOR!E18
  final bottomVentHeightMm = topDuctHeightMm; // E19
  final topVentWidthMm = ((bottomVentLengthMm * bottomVentHeightMm) * 6 / 4) / 480; // E20
  final topVentLengthMm = ((bottomVentLengthMm * bottomVentHeightMm) * 6 / 4) / 383; // E21

  return Kcc1VentilationResult(
    bottomVentLengthMm: bottomVentLengthMm,
    bottomVentHeightMm: bottomVentHeightMm,
    topVentWidthMm: topVentWidthMm,
    topVentLengthMm: topVentLengthMm,
  );
}

class Kcc1Calculator {
  const Kcc1Calculator();

  ({Kcc1VentilationResult ventilation, FurnaceResult furnace, DuctResult duct}) calculate(double volumeMm3) {
    final furnaceAndDuct = calculateKcc1StyleFurnaceAndDuct(volumeMm3);
    final ventilation = calculateKcc1Ventilation(
      ductWidthMm: furnaceAndDuct.duct.ductWidth.calculatedMm,
      // Safe non-null assertion: this function always constructs
      // topDuctHeight itself, a few lines above.
      topDuctHeightMm: furnaceAndDuct.duct.topDuctHeight!.calculatedMm,
    );
    return (ventilation: ventilation, furnace: furnaceAndDuct.furnace, duct: furnaceAndDuct.duct);
  }
}