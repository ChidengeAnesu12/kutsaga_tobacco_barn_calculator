import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import '../core/theme/app_colors.dart';
import '../models/barn_design_sample.dart';
import '../models/barn_reference_info.dart';
import '../widgets/app_header.dart';
import '../widgets/responsive_body.dart';
import 'owner_details_screen.dart';
import 'pdf_preview_screen.dart';

enum _DetailTab { overview, specifications, features }

class BarnDetailScreen extends StatefulWidget {
  const BarnDetailScreen({super.key, required this.info});
  final BarnReferenceInfo info;

  @override
  State<BarnDetailScreen> createState() => _BarnDetailScreenState();
}

class _BarnDetailScreenState extends State<BarnDetailScreen> {
  _DetailTab _tab = _DetailTab.overview;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;

    return Scaffold(
      appBar: AppHeader(title: info.title),
      body: SafeArea(
        child: ResponsiveBody(
          child: Column(
            children: [
              Image.asset(
                info.imageAsset,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _TabRow(
                  current: _tab,
                  onChanged: (t) => setState(() => _tab = t),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: switch (_tab) {
                    _DetailTab.overview => _OverviewTab(info: info),
                    _DetailTab.specifications => _SpecificationsTab(info: info),
                    _DetailTab.features => _FeaturesTab(info: info),
                  },
                ),
              ),
              if (info.calculatorBarnType != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OwnerDetailsScreen(
                            preselectedBarnType: info.calculatorBarnType!,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.calculate),
                      label: Text('Calculate with ${info.title}'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabRow extends StatelessWidget {
  const _TabRow({required this.current, required this.onChanged});
  final _DetailTab current;
  final ValueChanged<_DetailTab> onChanged;

  String _label(_DetailTab t) => switch (t) {
    _DetailTab.overview => 'Overview',
    _DetailTab.specifications => 'Specifications',
    _DetailTab.features => 'Features',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: _DetailTab.values.map((t) {
          final selected = t == current;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(t),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.vibrantGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                alignment: Alignment.center,
                child: MediaQuery.withClampedTextScaling(
                  maxScaleFactor: 1.15,
                  child: Text(
                    _label(t),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.info});
  final BarnReferenceInfo info;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this Barn',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(info.overview, style: const TextStyle(height: 1.4)),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _KeyFact(
                label: 'Fuel efficiency',
                value: info.efficiencyLabel,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KeyFact(
                label: 'Nominal capacity',
                value: info.nominalCapacityLabel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "Figures from Kutsaga's barn reference handbook — a typical design capacity for a "
          'standard full-size barn, not a live calculation for dimensions you enter.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.black45,
            fontStyle: FontStyle.italic,
          ),
        ),
        if (info.modelOverviews.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'Model overviews',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          for (final model in info.modelOverviews) ...[
            _ModelOverviewCard(model: model),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

class _ModelOverviewCard extends StatelessWidget {
  const _ModelOverviewCard({required this.model});
  final BarnModelOverview model;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.vibrantGreen,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              model.efficiencyLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
                color: AppColors.deepBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(model.overview, style: const TextStyle(height: 1.4)),
          ],
        ),
      ),
    );
  }
}

class _KeyFact extends StatelessWidget {
  const _KeyFact({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SpecificationsTab extends StatelessWidget {
  const _SpecificationsTab({required this.info});
  final BarnReferenceInfo info;

  Future<void> _sharePlan(BuildContext context, BarnPlanInfo plan) async {
    try {
      final bytes = await _loadAssetPdf(plan.assetPath);
      final shared = await Printing.sharePdf(
        bytes: bytes,
        filename: plan.fileName,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            shared ? 'Plan ready to share or save.' : 'Plan sharing cancelled.',
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Plan sharing failed: $error')));
    }
  }

  void _openPlan(BuildContext context, BarnPlanInfo plan) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(
          title: plan.title,
          fileName: plan.fileName,
          loadBytes: () => _loadAssetPdf(plan.assetPath),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (info.plans.isNotEmpty) ...[
          const Text(
            'Approved barn plans',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          for (final plan in info.plans) ...[
            _PlanCard(
              plan: plan,
              onOpen: () => _openPlan(context, plan),
              onShare: () => _sharePlan(context, plan),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
        ],
        if (info.samples.isNotEmpty) ...[
          Text(
            "Real, as-built barns from Kutsaga's own design records — not a prediction for "
            'dimensions you enter in the Calculator.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black45,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),
          for (final sample in info.samples) ...[
            _SampleCard(sample: sample),
            const SizedBox(height: 12),
          ],
        ] else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              info.calculatorBarnType == null
                  ? 'Approved plans and pamphlet references are provided above. Calculator sizing is currently available for KCC1, Rocket and Conventional barn models.'
                  : 'Use the Calculator to size a model for your own dimensions; approved plans are reference drawings.',
              style: const TextStyle(height: 1.4),
            ),
          ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.onOpen,
    required this.onShare,
  });
  final BarnPlanInfo plan;
  final VoidCallback onOpen;
  final VoidCallback onShare;

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
                const Icon(Icons.picture_as_pdf, color: AppColors.deepBlue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    plan.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan.description,
              style: const TextStyle(color: Colors.black54, height: 1.35),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.ios_share),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.sample});
  final BarnDesignSample sample;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sample.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.vibrantGreen,
              ),
            ),
            const SizedBox(height: 8),
            _row(
              'Barn size',
              '${sample.lengthMm.toStringAsFixed(0)} × ${sample.widthMm.toStringAsFixed(0)} mm',
            ),
            _row('Floor area', '${sample.floorAreaM2.toStringAsFixed(1)} m²'),
            _row(
              'Furnace',
              '${sample.furnaceLengthMm.toStringAsFixed(0)} × ${sample.furnaceWidthMm.toStringAsFixed(0)} × ${sample.furnaceHeightMm.toStringAsFixed(0)} mm',
            ),
            _row(
              'Bottom duct height',
              '${sample.bottomDuctHeightMm.toStringAsFixed(0)} mm',
            ),
            if (sample.topDuctHeightMm != null)
              _row(
                'Top duct height',
                '${sample.topDuctHeightMm!.toStringAsFixed(0)} mm',
              ),
            _row('Duct width', '${sample.ductWidthMm.toStringAsFixed(0)} mm'),
            if (sample.ventLengthMm != null && sample.ventHeightMm != null)
              _row(
                'Vent',
                '${sample.ventLengthMm!.toStringAsFixed(0)} × ${sample.ventHeightMm!.toStringAsFixed(0)} mm',
              ),
            if (sample.bigVentLengthMm != null &&
                sample.bigVentHeightMm != null)
              _row(
                'Large vent',
                '${sample.bigVentLengthMm!.toStringAsFixed(0)} × ${sample.bigVentHeightMm!.toStringAsFixed(0)} mm',
              ),
            if (sample.smallVentMm != null)
              _row(
                'Small vent',
                '${sample.smallVentMm!.toStringAsFixed(0)} mm${sample.smallVentQuantity != null ? ' × ${sample.smallVentQuantity}' : ''}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54, fontSize: 12.5),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
        ),
      ],
    ),
  );
}

class _FeaturesTab extends StatelessWidget {
  const _FeaturesTab({required this.info});
  final BarnReferenceInfo info;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final feature in info.features) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.check_circle,
                  size: 18,
                  color: AppColors.vibrantGreen,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(feature, style: const TextStyle(height: 1.4)),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

Future<Uint8List> _loadAssetPdf(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
