import 'package:flutter_test/flutter_test.dart';
import 'package:tobacco_barn_calculator/calculations/kcc1_calculator.dart';

void main() {
  const volumeMm3 = 78034445000.0;

  test('furnace dimensions match CALCULATOR!E27:E29', () {
    final result = const Kcc1Calculator().calculate(volumeMm3);
    expect(result.furnace.length.calculatedMm, closeTo(727.7575640442063, 1e-6));
    expect(result.furnace.width.calculatedMm, closeTo(192.7194548144306, 1e-6));
    expect(result.furnace.height.calculatedMm, closeTo(267.0647224239409, 1e-6));
  });

  test('this sample barn is below every furnace minimum', () {
    // Small demo barn vs. formulas fit to full-size Kutsaga barns — see
    // Phase 1 finding #9 about the Design Database's real dimensions.
    final result = const Kcc1Calculator().calculate(volumeMm3);
    expect(result.furnace.length.belowMinimum, isTrue);
    expect(result.furnace.length.recommendedMm, 1000);
    expect(result.furnace.width.belowMinimum, isTrue);
    expect(result.furnace.height.belowMinimum, isTrue);
  });

  test('duct dimensions match CALCULATOR!E30:E32', () {
    final result = const Kcc1Calculator().calculate(volumeMm3);
    expect(result.duct.bottomDuctHeight.calculatedMm, closeTo(175.53743741134377, 1e-6));
    expect(result.duct.topDuctHeight!.calculatedMm, closeTo(132.1693646391294, 1e-6));
    expect(result.duct.ductWidth.calculatedMm, closeTo(253.1869391368323, 1e-6));
  });

  test('ventilation matches CALCULATOR!E18:E21, reusing the duct values', () {
    final result = const Kcc1Calculator().calculate(volumeMm3);
    expect(result.ventilation.bottomVentLengthMm, closeTo(23.186939136832308, 1e-6));
    expect(result.ventilation.bottomVentHeightMm, closeTo(132.1693646391294, 1e-6));
    expect(result.ventilation.topVentWidthMm, closeTo(9.576884417629032, 1e-6));
    expect(result.ventilation.topVentLengthMm, closeTo(12.002361672224374, 1e-6));
  });
}