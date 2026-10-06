import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/barn_type.dart';

class BarnTypeCard extends StatelessWidget {
  const BarnTypeCard({super.key, required this.barnType, required this.selected, required this.onTap});

  final BarnType barnType;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.vibrantGreen.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.vibrantGreen : Colors.black12, width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(barnType.imageAsset, width: 64, height: 64, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(barnType.label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    barnType.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
                  ),
                ],
              ),
            ),
            Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? AppColors.vibrantGreen : Colors.black26),
          ],
        ),
      ),
    );
  }
}