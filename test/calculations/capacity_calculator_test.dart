import 'package:flutter_test/flutter_test.dart';
import 'package:tobacco_barn_calculator/calculations/capacity_calculator.dart';
import 'package:tobacco_barn_calculator/models/barn_input.dart';
import 'package:tobacco_barn_calculator/models/barn_type.dart';

void main() {
  final sampleInput = BarnInput(
    lengthMm: 4390,
    widthMm: 4870,
    heightMm: 3650,
    poleTiers: 3,
    horizontalPoles: 5,
    barnType: BarnType.kcc1,
  );

  test('floor area matches CALCULATOR!E5', () {
    expect(const CapacityCalculator().calculate(sampleInput).floorAreaM2, closeTo(21.3793, 1e-6));
  });

  test('raw volume in mm3 matches CALCULATOR!F6', () {
    expect(const CapacityCalculator().calculate(sampleInput).volumeMm3, closeTo(78034445000, 1));
  });

  test('volume in m3 uses the corrected /1e9 conversion, not the workbook\'s /1e6 display bug', () {
    final result = const CapacityCalculator().calculate(sampleInput);
    expect(result.volumeM3, closeTo(78.034445, 1e-6));
    expect(result.volumeM3, isNot(closeTo(78034.445, 1)));
  });

  test('clips per tier matches CALCULATOR!E8', () {
    expect(const CapacityCalculator().calculate(sampleInput).clipsPerTier, closeTo(17.392857142857142, 1e-9));
  });

  test('total strings matches CALCULATOR!E9', () {
    expect(const CapacityCalculator().calculate(sampleInput).totalStrings, closeTo(208.71428571428572, 1e-6));
  });

  test('estimated leaves matches CALCULATOR!E10', () {
    expect(const CapacityCalculator().calculate(sampleInput).estimatedLeaves, closeTo(17740.714285714286, 1e-6));
  });

  test('capacity in hectares matches CALCULATOR!E11', () {
    expect(const CapacityCalculator().calculate(sampleInput).capacityHectares, closeTo(0.5913571428571429, 1e-9));
  });
}