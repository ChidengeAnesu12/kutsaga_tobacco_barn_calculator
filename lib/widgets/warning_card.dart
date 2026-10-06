import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/engineering_warning.dart';

enum EngineeringStatus { normal, belowMinimum, invalid }

extension on EngineeringStatus {
  Color get color => switch (this) {
        EngineeringStatus.normal => AppColors.statusNormal,
        EngineeringStatus.belowMinimum => AppColors.statusBelowMinimum,
        EngineeringStatus.invalid => AppColors.statusInvalid,
      };

  String get label => switch (this) {
        EngineeringStatus.normal => 'Within recommended range',
        EngineeringStatus.belowMinimum => 'Below minimum',
        EngineeringStatus.invalid => 'Invalid input',
      };

  IconData get icon => switch (this) {
        EngineeringStatus.normal => Icons.check_circle,
        EngineeringStatus.belowMinimum => Icons.warning_amber_rounded,
        EngineeringStatus.invalid => Icons.error,
      };
}

/// EngineeringWarning (Part 2) only ever produces `normal` or
/// `belowMinimum` — our validators mean an "invalid" value should never
/// reach a results screen. The `invalid` state exists in the *type* in
/// case that ever changes, not because any code path emits it today.
class EngineeringStatusBadge extends StatelessWidget {
  const EngineeringStatusBadge({super.key, required this.status});

  final EngineeringStatus status;

  factory EngineeringStatusBadge.fromWarning(EngineeringWarning warning) {
    return EngineeringStatusBadge(status: warning.belowMinimum ? EngineeringStatus.belowMinimum : EngineeringStatus.normal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: status.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, color: status.color, size: 15),
          const SizedBox(width: 5),
          Text(status.label, style: TextStyle(color: status.color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Spec section 20's disclaimer — "±150 mm" comes straight from the
/// workbook's LIMITATIONS!C2 note, not an invented figure.
class EngineeringDisclaimerCard extends StatelessWidget {
  const EngineeringDisclaimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.deepBlue.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.deepBlue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Calculated dimensions are estimates based on the supplied Kutsaga design data. '
              'Practical construction dimensions may vary (±150 mm). Verify dimensions against '
              'applicable engineering requirements before construction.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}