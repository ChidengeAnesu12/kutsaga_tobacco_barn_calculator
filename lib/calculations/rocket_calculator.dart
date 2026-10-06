import '../core/constants/engineering_limits.dart';
import '../core/constants/kutsaga_constants.dart';
import '../models/duct_result.dart';
import '../models/furnace_result.dart';
import '../models/ventilation_result.dart';
import 'engineering_validator.dart';

class RocketCalculator {
  const RocketCalculator();

  ({RocketVentilationResult ventilation, FurnaceResult furnace, DuctResult duct}) calculate(double volumeMm3) {
    final ratio = volumeMm3 / KutsagaConstants.rocketReferenceVolumeMm3;
    const validator = EngineeringValidator();

    final ventilation = RocketVentilationResult(
      largeVentLengthMm: 770 * ratio, // CALCULATOR!H18
      largeVentHeightMm: 1950 * ratio, // H19
      smallVentSize: validator.evaluate(
        dimensionLabel: 'Small vent size',
        calculatedMm: 125 * ratio, // H20
        minimumMm: EngineeringLimits.minRocketInletVentMm,
      ),
      // Fractional by design (Phase 1 finding #5) — round up for
      // construction in the UI, never here.
      smallVentQuantityRaw: 11 * ratio, // H21
    );

    final furnace = FurnaceResult(
      length: validator.evaluate(
        dimensionLabel: 'Furnace length',
        calculatedMm: 1521.5 * ratio, // H27
        minimumMm: EngineeringLimits.minFurnaceLengthMm,
      ),
      width: validator.evaluate(
        dimensionLabel: 'Furnace width',
        calculatedMm: 580 * ratio, // H28
        minimumMm: EngineeringLimits.minFurnaceWidthMm,
      ),
      height: validator.evaluate(
        dimensionLabel: 'Furnace height',
        calculatedMm: 630 * ratio, // H29
        minimumMm: EngineeringLimits.minFurnaceHeightMm,
      ),
    );

    final duct = DuctResult(
      ductWidth: validator.evaluate(
        dimensionLabel: 'Duct width',
        calculatedMm: 515 * ratio, // H31
        minimumMm: EngineeringLimits.minDuctWidthMm,
      ),
      bottomDuctHeight: validator.evaluate(
        dimensionLabel: 'Bottom duct height',
        calculatedMm: 420.5 * ratio, // H30
        minimumMm: EngineeringLimits.minDuctHeightMm,
      ),
      topDuctHeight: null, // no top-duct-height row for Rocket in the workbook
    );

    return (ventilation: ventilation, furnace: furnace, duct: duct);
  }
}