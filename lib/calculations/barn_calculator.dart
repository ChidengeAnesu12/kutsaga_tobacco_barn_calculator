import '../models/barn_input.dart';
import '../models/barn_type.dart';
import '../models/calculation_result.dart';
import 'capacity_calculator.dart';
import 'conventional_calculator.dart';
import 'kcc1_calculator.dart';
import 'rocket_calculator.dart';

class BarnCalculator {
  const BarnCalculator({
    this.capacityCalculator = const CapacityCalculator(),
    this.kcc1Calculator = const Kcc1Calculator(),
    this.rocketCalculator = const RocketCalculator(),
    this.conventionalCalculator = const ConventionalCalculator(),
  });

  final CapacityCalculator capacityCalculator;
  final Kcc1Calculator kcc1Calculator;
  final RocketCalculator rocketCalculator;
  final ConventionalCalculator conventionalCalculator;

  CalculationResult calculate(BarnInput input) {
    final capacity = capacityCalculator.calculate(input);

    // Exhaustive switch over an enum: if BarnType ever gains a 4th
    // value, this refuses to compile until you add a case for it.
    switch (input.barnType) {
      case BarnType.kcc1:
        final r = kcc1Calculator.calculate(input.volumeMm3);
        return CalculationResult(input: input, capacity: capacity, ventilation: r.ventilation, furnace: r.furnace, duct: r.duct);
      case BarnType.rocket:
        final r = rocketCalculator.calculate(input.volumeMm3);
        return CalculationResult(input: input, capacity: capacity, ventilation: r.ventilation, furnace: r.furnace, duct: r.duct);
      case BarnType.conventional:
        final r = conventionalCalculator.calculate(floorAreaM2: capacity.floorAreaM2, volumeMm3: input.volumeMm3);
        return CalculationResult(input: input, capacity: capacity, ventilation: r.ventilation, furnace: r.furnace, duct: r.duct);
    }
  }
}