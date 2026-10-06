import 'package:flutter_test/flutter_test.dart';
import 'package:tobacco_barn_calculator/core/utils/validators.dart';
import 'package:tobacco_barn_calculator/models/barn_input.dart';
import 'package:tobacco_barn_calculator/models/barn_type.dart';

void main() {
  group('BarnInput constructor rejects invalid data', () {
    test('zero length throws', () {
      expect(
        () => BarnInput(lengthMm: 0, widthMm: 100, heightMm: 100, poleTiers: 1, horizontalPoles: 2, barnType: BarnType.kcc1),
        throwsArgumentError,
      );
    });

    test('negative width throws', () {
      expect(
        () => BarnInput(lengthMm: 100, widthMm: -50, heightMm: 100, poleTiers: 1, horizontalPoles: 2, barnType: BarnType.kcc1),
        throwsArgumentError,
      );
    });

    test('NaN height throws', () {
      expect(
        () => BarnInput(lengthMm: 100, widthMm: 100, heightMm: double.nan, poleTiers: 1, horizontalPoles: 2, barnType: BarnType.kcc1),
        throwsArgumentError,
      );
    });

    test('infinite length throws', () {
      expect(
        () => BarnInput(lengthMm: double.infinity, widthMm: 100, heightMm: 100, poleTiers: 1, horizontalPoles: 2, barnType: BarnType.kcc1),
        throwsArgumentError,
      );
    });

    test('horizontalPoles below 2 throws (formula computes poles - 1)', () {
      expect(
        () => BarnInput(lengthMm: 100, widthMm: 100, heightMm: 100, poleTiers: 1, horizontalPoles: 1, barnType: BarnType.kcc1),
        throwsArgumentError,
      );
    });

    test('poleTiers below 1 throws', () {
      expect(
        () => BarnInput(lengthMm: 100, widthMm: 100, heightMm: 100, poleTiers: 0, horizontalPoles: 2, barnType: BarnType.kcc1),
        throwsArgumentError,
      );
    });
  });

  group('validators return user-friendly messages before construction', () {
    test('empty string is rejected', () => expect(validatePositiveNumber('', 'Barn length'), 'Barn length is required.'));
    test('non-numeric text is rejected', () => expect(validatePositiveNumber('abc', 'Barn length'), 'Barn length must be a valid number.'));
    test('zero is rejected', () => expect(validatePositiveNumber('0', 'Barn length'), 'Barn length must be greater than 0.'));
    test('valid positive number passes', () => expect(validatePositiveNumber('4390', 'Barn length'), isNull));
    test('one horizontal pole is rejected', () => expect(validateHorizontalPoles('1'), isNotNull));
    test('two horizontal poles passes', () => expect(validateHorizontalPoles('2'), isNull));
  });
}