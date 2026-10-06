import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:tobacco_barn_calculator/models/barn_type.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/format_utils.dart';
import '../models/barn_owner_info.dart';
import '../models/calculation_result.dart';
import '../models/ventilation_result.dart';
import '../reports/barn_report_generator.dart';
import '../widgets/app_header.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/responsive_body.dart';
import '../widgets/result_card.dart';
import '../widgets/section_header.dart';
import '../widgets/warning_card.dart';

enum _ResultsTab { capacity, ventilation, furnace, ducts }

extension on _ResultsTab {
  String get pillLabel => switch (this) {
        _ResultsTab.capacity => 'Capacity',
        _ResultsTab.ventilation => 'Ventilation',
        _ResultsTab.furnace => 'Furnace',
        _ResultsTab.ducts => 'Ducts',
      };

  String get appBarTitle => this == _ResultsTab.capacity ? 'Calculation Results' : 'Engineering Recommendations';
}

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key, required this.result, required this.ownerInfo});

  final CalculationResult result;
  final BarnOwnerInfo ownerInfo;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  _ResultsTab _tab = _ResultsTab.capacity;
  bool _isExportingPdf = false;

  Future<void> _exportPdf() async {
    setState(() => _isExportingPdf = true);
    try {
      final bytes = await const BarnReportGenerator().generate(widget.result, widget.ownerInfo);
      if (!mounted) return;
      await Printing.layoutPdf(
        onLayout: (format) async => bytes,
        name: 'kutsaga_${sanitizeForFilename(widget.ownerInfo.ownerName)}_${widget.result.input.barnType.name}_barn_report.pdf',
      );
    } finally {
      if (mounted) setState(() => _isExportingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: _tab.appBarTitle,
        actions: [
          _isExportingPdf
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                )
              : IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  color: Colors.white,
                  tooltip: 'Export PDF',
                  onPressed: _exportPdf,
                ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: ResponsiveBody(
                child: _TabPillBar(current: _tab, onChanged: (t) => setState(() => _tab = t)),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ResponsiveBody(
                  child: switch (_tab) {
                    _ResultsTab.capacity => _CapacitySection(result: widget.result),
                    _ResultsTab.ventilation => _VentilationSection(result: widget.result),
                    _ResultsTab.furnace => _FurnaceSection(result: widget.result),
                    _ResultsTab.ducts => _DuctsSection(result: widget.result),
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ResponsiveBody(
                child: _NavigationRow(current: _tab, onChanged: (t) => setState(() => _tab = t)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabPillBar extends StatelessWidget {
  const _TabPillBar({required this.current, required this.onChanged});

  final _ResultsTab current;
  final ValueChanged<_ResultsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: _ResultsTab.values.map((t) {
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
                    t.pillLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 12.5),
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

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({required this.current, required this.onChanged});

  final _ResultsTab current;
  final ValueChanged<_ResultsTab> onChanged;

  static const _order = _ResultsTab.values;

  @override
  Widget build(BuildContext context) {
    final index = _order.indexOf(current);
    final isFirst = index == 0;
    final isLast = index == _order.length - 1;

    return Row(
      children: [
        if (!isFirst) ...[
          Expanded(child: OutlinedButton(onPressed: () => onChanged(_order[index - 1]), child: const Text('Back'))),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isLast ? () => Navigator.of(context).popUntil((r) => r.isFirst) : () => onChanged(_order[index + 1]),
            child: Text(isLast ? 'Start New Calculation' : 'Next: ${_order[index + 1].pillLabel}'),
          ),
        ),
      ],
    );
  }
}

class _CapacitySection extends StatelessWidget {
  const _CapacitySection({required this.result});
  final CalculationResult result;

  @override
  Widget build(BuildContext context) {
    final c = result.capacity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(icon: Icons.grid_view, title: 'Barn Capacity Results'),
        const SizedBox(height: 14),
        ResultCard(icon: Icons.grid_on, label: 'Floor Area', value: '${formatDecimal(c.floorAreaM2, 2)} m²'),
        const SizedBox(height: 10),
        ResultCard(icon: Icons.view_in_ar, label: 'Barn Volume', value: '${formatDecimal(c.volumeM3, 2)} m³'),
        const SizedBox(height: 10),
        ResultCard(icon: Icons.link, label: 'Clips per Tier', value: '${formatDecimal(c.clipsPerTier, 2)} clips'),
        const SizedBox(height: 10),
        ResultCard(icon: Icons.format_list_numbered, label: 'Total Long Clips / Strings', value: '${formatDecimal(c.totalStrings, 2)} strings'),
        const SizedBox(height: 10),
        ResultCard(icon: Icons.eco, label: 'Estimated Leaves', value: '${formatThousands(c.estimatedLeaves)} leaves'),
        const SizedBox(height: 10),
        ResultCard(icon: Icons.agriculture, label: 'Barn Capacity', value: '${formatDecimal(c.capacityHectares, 2)} hectares', highlighted: true),
      ],
    );
  }
}

class _VentilationSection extends StatelessWidget {
  const _VentilationSection({required this.result});
  final CalculationResult result;

  @override
  Widget build(BuildContext context) {
    final v = result.ventilation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: Icons.air,
          title: 'Ventilation Recommendations',
          subtitle: 'Recommended ventilation dimensions for ${result.input.barnType.label} barn.',
        ),
        const SizedBox(height: 14),
        switch (v) {
          Kcc1VentilationResult k => _kcc1(k),
          RocketVentilationResult r => _rocket(r),
          ConventionalVentilationResult c => _conventional(c),
        },
        const SizedBox(height: 16),
        const EngineeringDisclaimerCard(),
      ],
    );
  }

  Widget _kcc1(Kcc1VentilationResult v) => Column(children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Bottom Vents (Inlets)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _row('Length (mm)', formatDecimal(v.bottomVentLengthMm, 0)),
              _row('Height (mm)', formatDecimal(v.bottomVentHeightMm, 0)),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Top Vents (Outlets)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _row('Width (mm)', formatDecimal(v.topVentWidthMm, 0)),
              _row('Length (mm)', formatDecimal(v.topVentLengthMm, 0)),
            ]),
          ),
        ),
      ]);

  Widget _rocket(RocketVentilationResult v) => Column(children: [
        ResultCard(icon: Icons.air, label: 'Large Vent Length', value: '${formatDecimal(v.largeVentLengthMm, 0)} mm'),
        const SizedBox(height: 10),
        ResultCard(icon: Icons.air, label: 'Large Vent Height', value: '${formatDecimal(v.largeVentHeightMm, 0)} mm'),
        const SizedBox(height: 10),
        RecommendationCard(warning: v.smallVentSize),
        const SizedBox(height: 10),
        ResultCard(
          icon: Icons.numbers,
          label: 'Small Vent Quantity',
          value: '${formatDecimal(v.smallVentQuantityRaw, 1)}  (build ${v.smallVentQuantityRaw.ceil()})',
        ),
      ]);

  Widget _conventional(ConventionalVentilationResult v) => Column(children: [
        ResultCard(icon: Icons.crop_square, label: 'Total Vent Area', value: '${formatDecimal(v.totalVentAreaM2, 3)} m²'),
        const SizedBox(height: 10),
        ResultCard(icon: Icons.grid_view, label: 'Number of Vents', value: '${v.numberOfVents}'),
        const SizedBox(height: 10),
        ResultCard(icon: Icons.south, label: 'Vents at Bottom', value: '${v.bottomVents}'),
        const SizedBox(height: 10),
        ResultCard(icon: Icons.north, label: 'Vents at Top', value: '${v.topVents}'),
        const SizedBox(height: 10),
        ResultCard(icon: Icons.crop_square, label: 'Area per Vent', value: '${formatDecimal(v.areaPerVentM2, 4)} m²'),
        const SizedBox(height: 10),
        RecommendationCard(warning: v.equivalentVentSide),
      ]);

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _FurnaceSection extends StatelessWidget {
  const _FurnaceSection({required this.result});
  final CalculationResult result;

  @override
  Widget build(BuildContext context) {
    final f = result.furnace;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(icon: Icons.local_fire_department, title: 'Furnace Recommendations'),
        const SizedBox(height: 14),
        RecommendationCard(warning: f.length),
        const SizedBox(height: 10),
        RecommendationCard(warning: f.width),
        const SizedBox(height: 10),
        RecommendationCard(warning: f.height),
        const SizedBox(height: 16),
        const EngineeringDisclaimerCard(),
      ],
    );
  }
}

class _DuctsSection extends StatelessWidget {
  const _DuctsSection({required this.result});
  final CalculationResult result;

  @override
  Widget build(BuildContext context) {
    final d = result.duct;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(icon: Icons.settings_input_component, title: 'Duct Recommendations'),
        const SizedBox(height: 14),
        RecommendationCard(warning: d.ductWidth),
        const SizedBox(height: 10),
        RecommendationCard(warning: d.bottomDuctHeight),
        if (d.topDuctHeight != null) ...[
          const SizedBox(height: 10),
          RecommendationCard(warning: d.topDuctHeight!),
        ],
        const SizedBox(height: 16),
        const EngineeringDisclaimerCard(),
      ],
    );
  }
}