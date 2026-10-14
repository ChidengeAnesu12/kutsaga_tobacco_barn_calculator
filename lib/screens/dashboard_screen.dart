import 'package:flutter/material.dart';

import '../calculations/barn_calculator.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/format_utils.dart';
import '../history/barn_history_repository.dart';
import '../models/saved_barn_record.dart';
import '../reports/barn_report_generator.dart';
import '../widgets/app_header.dart';
import '../widgets/responsive_body.dart';
import 'pdf_preview_screen.dart';
import 'results_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _repository = BarnHistoryRepository();
  late Future<List<SavedBarnRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.loadAll();
  }

  Future<void> _reviewRecord(SavedBarnRecord record) async {
    final result = const BarnCalculator().calculate(record.input);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ResultsScreen(result: result, ownerInfo: record.ownerInfo),
      ),
    );
  }

  void _openPdfPreview(SavedBarnRecord record) {
    final result = const BarnCalculator().calculate(record.input);
    final fileName =
        'kutsaga_${sanitizeForFilename(record.ownerInfo.ownerName)}_${sanitizeForFilename(record.label.toLowerCase())}_barn_report.pdf';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(
          title: 'Barn Report',
          fileName: fileName,
          loadBytes: () =>
              const BarnReportGenerator().generate(result, record.ownerInfo),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Dashboard'),
      body: SafeArea(
        child: ResponsiveBody(
          child: RefreshIndicator(
            onRefresh: () async =>
                setState(() => _future = _repository.loadAll()),
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
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: Colors.black26,
                      ),
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
                    onTap: () => _reviewRecord(records[index]),
                    onExport: () => _openPdfPreview(records[index]),
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
  const _HistoryTile({
    required this.record,
    required this.onTap,
    required this.onExport,
  });

  final SavedBarnRecord record;
  final VoidCallback onTap;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final i = record.input;
    final d = record.savedAt;
    final dateLabel =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: AppColors.deepBlue.withValues(alpha: 0.1),
          child: Text(
            '${record.sequenceNumber}',
            style: const TextStyle(
              color: AppColors.deepBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          record.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${record.ownerInfo.ownerName.isNotEmpty ? '${record.ownerInfo.ownerName} · ' : ''}${i.lengthMm.toStringAsFixed(0)}×${i.widthMm.toStringAsFixed(0)}×${i.heightMm.toStringAsFixed(0)} mm  ·  $dateLabel',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.picture_as_pdf, color: AppColors.deepBlue),
          tooltip: 'Open PDF report',
          onPressed: onExport,
        ),
      ),
    );
  }
}
