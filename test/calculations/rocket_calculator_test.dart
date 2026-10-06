import 'package:flutter_test/flutter_test.dart';
import 'package:tobacco_barn_calculator/calculations/rocket_calculator.dart';

void main() {
  const volumeMm3 = 78034445000.0;

  test('ventilation matches CALCULATOR!H18:H21', () {
    final result = const RocketCalculator().calculate(volumeMm3);
    expect(result.ventilation.largeVentLengthMm, closeTo(518.3758338335466, 1e-6));
    expect(result.ventilation.largeVentHeightMm, closeTo(1312.7699687992415, 1e-6));
    expect(result.ventilation.smallVentSize.calculatedMm, closeTo(84.15192107687446, 1e-6));
    expect(result.ventilation.smallVentQuantityRaw, closeTo(7.405369054764952, 1e-6));
  });

  test('small vent size is below the 100mm inlet minimum for this sample barn', () {
    final result = const RocketCalculator().calculate(volumeMm3);
    expect(result.ventilation.smallVentSize.belowMinimum, isTrue);
    expect(result.ventilation.smallVentSize.recommendedMm, 100);
  });

  test('furnace and duct match CALCULATOR!H27:H31', () {
    final result = const RocketCalculator().calculate(volumeMm3);
    expect(result.furnace.length.calculatedMm, closeTo(1024.2971833477159, 1e-6));
    expect(result.furnace.width.calculatedMm, closeTo(390.4649137966975, 1e-6));
    expect(result.furnace.height.calculatedMm, closeTo(424.12568222744727, 1e-6));
    expect(result.duct.bottomDuctHeight.calculatedMm, closeTo(283.08706250260565, 1e-6));
    expect(result.duct.ductWidth.calculatedMm, closeTo(346.70591483672274, 1e-6));
  });

  test('rocket has no top duct height', () {
    expect(const RocketCalculator().calculate(volumeMm3).duct.topDuctHeight, isNull);
  });

  test('furnace length (1024mm) clears the 1000mm minimum, unlike KCC1 at this size', () {
    final result = const RocketCalculator().calculate(volumeMm3);
    expect(result.furnace.length.belowMinimum, isFalse);
  });
}