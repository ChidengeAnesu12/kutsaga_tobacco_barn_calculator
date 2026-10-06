import 'barn_input.dart';
import 'capacity_result.dart';
import 'duct_result.dart';
import 'furnace_result.dart';
import 'ventilation_result.dart';

/// Everything one "Calculate" press produces. This is the only object
/// screens hold onto after the measurements screen.
class CalculationResult {
  final BarnInput input;
  final CapacityResult capacity;
  final VentilationResult ventilation;
  final FurnaceResult furnace;
  final DuctResult duct;

  const CalculationResult({
    required this.input,
    required this.capacity,
    required this.ventilation,
    required this.furnace,
    required this.duct,
  });
}