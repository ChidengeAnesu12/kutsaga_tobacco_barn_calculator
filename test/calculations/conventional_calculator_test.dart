import 'package:flutter_test/flutter_test.dart';
import 'package:tobacco_barn_calculator/calculations/conventional_calculator.dart';
import 'package:tobacco_barn_calculator/calculations/kcc1_calculator.dart';

void main() {
  const floorAreaM2 = 21.3793;
  const volumeMm3 = 78034445000.0;

  test('ventilation matches CALCULATOR!K18:K23', () {
    final result = const ConventionalCalculator().calculate(floorAreaM2: floorAreaM2, volumeMm3: volumeMm3);
    expect(result.ventilation.totalVentAreaM2, closeTo(0.5344825, 1e-7));
    expect(result.ventilation.numberOfVents, 8);
    expect(result.ventilation.bottomVents, 4);
    expect(result.ventilation.topVents, 4);
    expect(result.ventilation.areaPerVentM2, closeTo(0.0668103125, 1e-9));
    expect(result.ventilation.equivalentVentSide.calculatedMm, closeTo(258.47690902670587, 1e-6));
  });

  test('equivalent vent side is below the 300mm minimum for this sample barn', () {
    final result = const ConventionalCalculator().calculate(floorAreaM2: floorAreaM2, volumeMm3: volumeMm3);
    expect(result.ventilation.equivalentVentSide.belowMinimum, isTrue);
  });

  test('furnace and duct are identical to KCC1 — same shared formula', () {
    final conventional = const ConventionalCalculator().calculate(floorAreaM2: floorAreaM2, volumeMm3: volumeMm3);
    final kcc1 = const Kcc1Calculator().calculate(volumeMm3);
    expect(conventional.furnace.length.calculatedMm, kcc1.furnace.length.calculatedMm);
    expect(conventional.duct.ductWidth.calculatedMm, kcc1.duct.ductWidth.calculatedMm);
  });
}