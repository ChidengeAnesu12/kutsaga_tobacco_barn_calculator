import 'package:flutter/material.dart';
import '../core/utils/format_utils.dart';
import '../models/engineering_warning.dart';
import 'warning_card.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key, required this.warning});

  final EngineeringWarning warning;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    warning.dimensionLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                EngineeringStatusBadge.fromWarning(warning),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _col(context, 'Calculated', '${formatDecimal(warning.calculatedMm, 0)} mm')),
                Expanded(child: _col(context, 'Minimum recommended', '${formatDecimal(warning.recommendedMm, 0)} mm')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // No ellipsis here deliberately — each half of this Row has a whole
  // Column to itself, so letting "1,150 mm" wrap to a second line if it
  // needs to is a better accommodation than truncating it.
  Widget _col(BuildContext context, String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black54)),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      );
}