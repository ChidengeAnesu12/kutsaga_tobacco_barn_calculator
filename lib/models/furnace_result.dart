import 'engineering_warning.dart';

/// Same shape for all three barn types — KCC1/Conventional share one
/// formula, Rocket has its own, but the *result* shape is identical.
class FurnaceResult {
  final EngineeringWarning length;
  final EngineeringWarning width;
  final EngineeringWarning height;

  const FurnaceResult({
    required this.length,
    required this.width,
    required this.height,
  });
}