import 'package:flutter_test/flutter_test.dart';
import 'package:tobacco_barn_calculator/models/engineering_warning.dart';

void main() {
  test('recommendedMm is the calculated value when at/above minimum', () {
    const w = EngineeringWarning(dimensionLabel: 'Test', calculatedMm: 400, minimumMm: 350);
    expect(w.belowMinimum, isFalse);
    expect(w.recommendedMm, 400);
  });

  test('recommendedMm clamps up to the minimum when calculated is below it', () {
    const w = EngineeringWarning(dimensionLabel: 'Test', calculatedMm: 287, minimumMm: 350);
    expect(w.belowMinimum, isTrue);
    expect(w.recommendedMm, 350);
    expect(w.calculatedMm, 287); // never overwritten
  });

  test('exactly at the minimum counts as not below', () {
    expect(const EngineeringWarning(dimensionLabel: 'Test', calculatedMm: 350, minimumMm: 350).belowMinimum, isFalse);
  });
}