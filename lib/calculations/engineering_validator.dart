import '../models/engineering_warning.dart';

class EngineeringValidator {
  const EngineeringValidator();

  EngineeringWarning evaluate({
    required String dimensionLabel,
    required double calculatedMm,
    required double minimumMm,
  }) {
    return EngineeringWarning(
      dimensionLabel: dimensionLabel,
      calculatedMm: calculatedMm,
      minimumMm: minimumMm,
    );
  }
}