import 'barn_type.dart';

/// A single, already-validated set of user inputs. By the time this
/// object exists, every field has passed the checks in validators.dart —
/// but the constructor re-checks anyway. A calculation engine should
/// never assume its caller was careful.
class BarnInput {
  final double lengthMm;
  final double widthMm;
  final double heightMm;
  final int poleTiers;
  final int horizontalPoles;
  final BarnType barnType;

  BarnInput({
    required this.lengthMm,
    required this.widthMm,
    required this.heightMm,
    required this.poleTiers,
    required this.horizontalPoles,
    required this.barnType,
  }) {
    if (lengthMm <= 0 || !lengthMm.isFinite) {
      throw ArgumentError.value(lengthMm, 'lengthMm', 'must be a finite number > 0');
    }
    if (widthMm <= 0 || !widthMm.isFinite) {
      throw ArgumentError.value(widthMm, 'widthMm', 'must be a finite number > 0');
    }
    if (heightMm <= 0 || !heightMm.isFinite) {
      throw ArgumentError.value(heightMm, 'heightMm', 'must be a finite number > 0');
    }
    if (poleTiers < 1) {
      throw ArgumentError.value(poleTiers, 'poleTiers', 'must be >= 1');
    }
    if (horizontalPoles < 2) {
      throw ArgumentError.value(
        horizontalPoles,
        'horizontalPoles',
        'must be >= 2 (formula computes horizontalPoles - 1)',
      );
    }
  }

  /// Raw volume in mm³ — the value every ventilation/furnace/duct
  /// formula actually divides by a reference volume. Never convert
  /// this to m³ before using it in those formulas (see Phase 1 finding
  /// #1 — that's exactly the bug we're correcting elsewhere, not
  /// reintroducing here).
  double get volumeMm3 => lengthMm * widthMm * heightMm;
}