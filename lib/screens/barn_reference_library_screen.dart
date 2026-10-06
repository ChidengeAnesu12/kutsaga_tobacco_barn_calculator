import 'package:flutter/material.dart';
import '../core/data/barn_reference_data.dart';
import '../core/theme/app_colors.dart';
import '../models/barn_reference_info.dart';
import '../models/barn_type.dart';
import '../widgets/app_header.dart';
import '../widgets/responsive_body.dart';
import 'barn_detail_screen.dart';

class BarnReferenceLibraryScreen extends StatelessWidget {
  const BarnReferenceLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Barn Reference Library'),
      body: SafeArea(
        child: ResponsiveBody(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Explore Kutsaga tobacco barn designs and their specifications.', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),
              for (final type in BarnType.values) ...[
                _LibraryCard(barnType: type),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LibraryCard extends StatelessWidget {
  const _LibraryCard({required this.barnType});
  final BarnType barnType;

  @override
  Widget build(BuildContext context) {
    final BarnReferenceInfo info = BarnReferenceData.all[barnType]!;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BarnDetailScreen(barnType: barnType))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(barnType.imageAsset, width: 100, height: 100, fit: BoxFit.cover),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(barnType.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(
                      barnType.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(info.nominalCapacityLabel, style: const TextStyle(color: AppColors.vibrantGreen, fontWeight: FontWeight.w600, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.chevron_right, color: Colors.black26)),
          ],
        ),
      ),
    );
  }
}