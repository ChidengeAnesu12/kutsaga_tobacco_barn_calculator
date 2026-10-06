import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.icon, required this.label, required this.value, this.highlighted = false});

  final IconData icon;
  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: highlighted ? AppColors.vibrantGreen.withValues(alpha: 0.08) : null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: highlighted ? AppColors.vibrantGreen : AppColors.deepBlue),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
            const SizedBox(width: 8),
            // Flexible + ellipsis, not a bare Text — at a large font
            // setting, something like "214.29 strings" wants more room
            // than a rigid Text would be given here, and would overflow
            // the Row rather than shrinking gracefully.
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: highlighted ? AppColors.vibrantGreen : AppColors.textPrimary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}