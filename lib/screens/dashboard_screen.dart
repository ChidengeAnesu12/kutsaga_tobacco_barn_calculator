import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../calculations/barn_calculator.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/format_utils.dart';
import '../history/barn_history_repository.dart';
import '../models/saved_barn_record.dart';
import '../reports/barn_report_generator.dart';
import '../widgets/app_header.dart';
import '../widgets/responsive_body.dart';
import 'results_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _repository = BarnHistoryRepository();
  late Future<List<SavedBarnRecord>> _future;
  String? _exportingRecordId;

  @override
  void initState() {
    super.initState();
    _future = _repository.loadAll();
  }

  Future<void> _reviewRecord(SavedBarnRecord record) async {
    final result = const BarnCalculator().calculate(record.input);
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ResultsScreen(result: result, ownerInfo: record.ownerInfo)));
  }

  Future<void> _redownloadPdf(SavedBarnRecord record) async {
    setState(() => _exportingRecordId = record.id);
    try {
      final result = const BarnCalculator().calculate(record.input);
      final bytes = await const BarnReportGenerator().generate(result, record.ownerInfo);
      if (!mounted) return;
      await Printing.layoutPdf(
        onLayout: (format) async => bytes,
        name: 'kutsaga_${sanitizeForFilename(record.ownerInfo.ownerName)}_${record.label.toLowerCase()}_barn_report.pdf',
      );
    } finally {
      if (mounted) setState(() => _exportingRecordId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Dashboard'),
      body: SafeArea(
        child: ResponsiveBody(
          child: RefreshIndicator(
            onRefresh: () async => setState(() => _future = _repository.loadAll()),
            child: FutureBuilder<List<SavedBarnRecord>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final records = snapshot.data ?? [];
                if (records.isEmpty) {
                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: const [
                      SizedBox(height: 80),
                      Icon(Icons.inventory_2_outlined, size: 48, color: Colors.black26),
                      SizedBox(height: 12),
                      Text(
                        'No saved calculations yet. Every barn you calculate is saved here automatically.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _HistoryTile(
                    record: records[index],
                    isExporting: _exportingRecordId == records[index].id,
                    onTap: () => _reviewRecord(records[index]),
                    onExport: () => _redownloadPdf(records[index]),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.record, required this.isExporting, required this.onTap, required this.onExport});

  final SavedBarnRecord record;
  final bool isExporting;
  final VoidCallback onTap;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final i = record.input;
    final d = record.savedAt;
    final dateLabel = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: AppColors.deepBlue.withOpacity(0.1),
          child: Text('${record.sequenceNumber}', style: const TextStyle(color: AppColors.deepBlue, fontWeight: FontWeight.bold)),
        ),
        title: Text(record.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${record.ownerInfo.ownerName.isNotEmpty ? '${record.ownerInfo.ownerName} · ' : ''}${i.lengthMm.toStringAsFixed(0)}×${i.widthMm.toStringAsFixed(0)}×${i.heightMm.toStringAsFixed(0)} mm  ·  $dateLabel',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isExporting
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : IconButton(icon: const Icon(Icons.picture_as_pdf, color: AppColors.deepBlue), tooltip: 'Export PDF', onPressed: onExport),
      ),
    );
  }
}