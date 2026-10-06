import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tobacco_barn_calculator/models/barn_type.dart';

import '../core/utils/format_utils.dart';
import '../models/calculation_result.dart';
import '../models/engineering_warning.dart';
import '../models/ventilation_result.dart';
import '../models/barn_owner_info.dart';

/// Builds the full, all-sections PDF report from one CalculationResult.
/// Lives outside calculations/ (must stay pure Dart) and outside
/// screens/ (must stay free of report-layout code) — same separation
/// principle as the rest of the app, extended to a third concern.
class BarnReportGenerator {
  const BarnReportGenerator();

  // Keep in sync with core/theme/app_colors.dart by hand — PdfColor and
  // Flutter's Color are different types from different packages, so
  // the same hex value has to be declared twice, not shared directly.
  static const _deepBlue = PdfColor.fromInt(0xFF0A2A92);
  static const _vibrantGreen = PdfColor.fromInt(0xFF2E7D32);
  static const _amber = PdfColor.fromInt(0xFFF9A825);
  static const _lightGray = PdfColor.fromInt(0xFFF8F9FA);

  Future<Uint8List> generate(CalculationResult result, BarnOwnerInfo ownerInfo) async {
final regular = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'));
final medium = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Medium.ttf'));
final semiBold = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-SemiBold.ttf'));
final bold = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Bold.ttf'));

    final doc = pw.Document(theme: pw.ThemeData.withFont(base: regular, bold: bold));

    doc.addPage(
      pw.MultiPage(
        // MultiPage, not a fixed-size Page — a Rocket barn with a
        // below-minimum warning renders more content than a KCC1 barn
        // with none, and a fixed page would clip it rather than add a
        // second page.
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        header: (context) => _header(medium),
        footer: (context) => _footer(context, regular),
        build: (context) => [
        _titleBlock(result, ownerInfo, semiBold, regular, medium),
          pw.SizedBox(height: 16),
          _sectionTitle('Barn Capacity', semiBold),
          _capacityTable(result, regular, medium),
          pw.SizedBox(height: 20),
          _sectionTitle('Ventilation', semiBold),
          ..._ventilationRows(result, regular, medium),
          pw.SizedBox(height: 20),
          _sectionTitle('Furnace', semiBold),
          _recommendationRow('Furnace length', result.furnace.length, regular, medium),
          _recommendationRow('Furnace width', result.furnace.width, regular, medium),
          _recommendationRow('Furnace height', result.furnace.height, regular, medium),
          pw.SizedBox(height: 20),
          _sectionTitle('Ducts', semiBold),
          _recommendationRow('Duct width', result.duct.ductWidth, regular, medium),
          _recommendationRow('Bottom duct height', result.duct.bottomDuctHeight, regular, medium),
          // Null for Rocket — same reasoning as the Results screen in Part 3.
          if (result.duct.topDuctHeight != null)
            _recommendationRow('Top duct height', result.duct.topDuctHeight!, regular, medium),
          pw.SizedBox(height: 24),
          _disclaimer(regular),
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _header(pw.Font medium) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('KUTSAGA', style: pw.TextStyle(font: medium, color: _deepBlue, fontSize: 12, letterSpacing: 1.2)),
          pw.Text('Tobacco Barn Calculator', style: pw.TextStyle(font: medium, color: PdfColors.grey600, fontSize: 9)),
        ],
      );

  pw.Widget _footer(pw.Context context, pw.Font regular) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: pw.TextStyle(font: regular, color: PdfColors.grey500, fontSize: 8)),
      );

  pw.Widget _titleBlock(CalculationResult result, BarnOwnerInfo ownerInfo, pw.Font semiBold, pw.Font regular, pw.Font medium) {
  final input = result.input;
  final now = DateTime.now();
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Barn Calculation Report', style: pw.TextStyle(font: semiBold, fontSize: 20, color: _deepBlue)),
      pw.SizedBox(height: 4),
      pw.Text(
        'Generated ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
        style: pw.TextStyle(font: regular, fontSize: 9, color: PdfColors.grey600),
      ),
      pw.SizedBox(height: 10),
      pw.Text('Prepared for', style: pw.TextStyle(font: regular, fontSize: 8, color: PdfColors.grey600)),
      pw.SizedBox(height: 2),
      pw.Text('${ownerInfo.ownerName}  —  ${ownerInfo.location}', style: pw.TextStyle(font: medium, fontSize: 12, color: _deepBlue)),
      pw.SizedBox(height: 12),
        pw.Container(
          padding: pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(color: _lightGray, borderRadius: pw.BorderRadius.circular(6)),
          // Wrap, not Row — "Conventional" is a longer label than
          // "KCC1"/"Rocket" and a Row would throw rather than clip.
          child: pw.Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _inputPair('Barn type', input.barnType.label, regular, medium),
              _inputPair('Length', '${formatDecimal(input.lengthMm, 0)} mm', regular, medium),
              _inputPair('Width', '${formatDecimal(input.widthMm, 0)} mm', regular, medium),
              _inputPair('Height', '${formatDecimal(input.heightMm, 0)} mm', regular, medium),
              _inputPair('Tiers', '${input.poleTiers}', regular, medium),
              _inputPair('Poles', '${input.horizontalPoles}', regular, medium),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _inputPair(String label, String value, pw.Font regular, pw.Font medium) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(font: regular, fontSize: 7, color: PdfColors.grey600)),
          pw.Text(value, style: pw.TextStyle(font: medium, fontSize: 9)), // medium weight, not faux-bold on the regular font
        ],
      );

  pw.Widget _sectionTitle(String title, pw.Font semiBold) => pw.Container(
        padding: pw.EdgeInsets.only(bottom: 6),
        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _deepBlue, width: 1))),
        child: pw.Text(title, style: pw.TextStyle(font: semiBold, fontSize: 13, color: _deepBlue)),
      );

  pw.Widget _capacityTable(CalculationResult result, pw.Font regular, pw.Font medium) {
    final c = result.capacity;
    final rows = <List<String>>[
      ['Floor area', '${formatDecimal(c.floorAreaM2, 2)} m²'],
      ['Barn volume', '${formatDecimal(c.volumeM3, 2)} m³'],
      ['Clips per tier', formatDecimal(c.clipsPerTier, 2)],
      ['Total long clips / strings', formatDecimal(c.totalStrings, 2)],
      ['Estimated leaves', formatThousands(c.estimatedLeaves)],
      ['Barn capacity', '${formatDecimal(c.capacityHectares, 2)} hectares'],
    ];
    return pw.Table(
      columnWidths: {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
      children: rows
          .map((r) => pw.TableRow(children: [
                pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 4), child: pw.Text(r[0], style: pw.TextStyle(font: regular, fontSize: 10))),
                pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 4), child: pw.Text(r[1], style: pw.TextStyle(font: medium, fontSize: 10))),
              ]))
          .toList(),
    );
  }

  List<pw.Widget> _ventilationRows(CalculationResult result, pw.Font regular, pw.Font medium) {
    // Same exhaustive switch as the Results screen (Part 3) — a 4th
    // barn type still fails to compile here until handled.
    return switch (result.ventilation) {
      Kcc1VentilationResult v => [
          _plainRow('Bottom vent length', '${formatDecimal(v.bottomVentLengthMm, 0)} mm', regular, medium),
          _plainRow('Bottom vent height', '${formatDecimal(v.bottomVentHeightMm, 0)} mm', regular, medium),
          _plainRow('Top vent width', '${formatDecimal(v.topVentWidthMm, 0)} mm', regular, medium),
          _plainRow('Top vent length', '${formatDecimal(v.topVentLengthMm, 0)} mm', regular, medium),
        ],
      RocketVentilationResult v => [
          _plainRow('Large vent length', '${formatDecimal(v.largeVentLengthMm, 0)} mm', regular, medium),
          _plainRow('Large vent height', '${formatDecimal(v.largeVentHeightMm, 0)} mm', regular, medium),
          _recommendationRow('Small vent size', v.smallVentSize, regular, medium),
          _plainRow('Small vent quantity', '${formatDecimal(v.smallVentQuantityRaw, 1)}  (build ${v.smallVentQuantityRaw.ceil()})', regular, medium),
        ],
      ConventionalVentilationResult v => [
          _plainRow('Total vent area', '${formatDecimal(v.totalVentAreaM2, 3)} m²', regular, medium),
          _plainRow('Number of vents', '${v.numberOfVents}', regular, medium),
          _plainRow('Vents at bottom', '${v.bottomVents}', regular, medium),
          _plainRow('Vents at top', '${v.topVents}', regular, medium),
          _plainRow('Area per vent', '${formatDecimal(v.areaPerVentM2, 4)} m²', regular, medium),
          _recommendationRow('Equivalent vent side', v.equivalentVentSide, regular, medium),
        ],
    };
  }

  pw.Widget _plainRow(String label, String value, pw.Font regular, pw.Font medium) => pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label, style: pw.TextStyle(font: regular, fontSize: 10)),
            pw.Text(value, style: pw.TextStyle(font: medium, fontSize: 10)),
          ],
        ),
      );

  // Mirrors RecommendationCard from the app (Part 3): calculated,
  // recommended, and status — never one substituted for the other.
  pw.Widget _recommendationRow(String label, EngineeringWarning warning, pw.Font regular, pw.Font medium) {
    final statusColor = warning.belowMinimum ? _amber : _vibrantGreen;
    final statusLabel = warning.belowMinimum ? 'Below minimum' : 'Within recommended range';
    return pw.Container(
      margin: pw.EdgeInsets.only(bottom: 6),
      padding: pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(color: _lightGray, borderRadius: pw.BorderRadius.circular(4)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(label, style: pw.TextStyle(font: medium, fontSize: 10)),
              pw.Container(
                padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: pw.BoxDecoration(color: statusColor, borderRadius: pw.BorderRadius.circular(8)),
                child: pw.Text(statusLabel, style: pw.TextStyle(font: medium, fontSize: 7, color: PdfColors.white)),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Wrap(spacing: 16, children: [
            pw.Text('Calculated: ${formatDecimal(warning.calculatedMm, 0)} mm', style: pw.TextStyle(font: regular, fontSize: 9, color: PdfColors.grey700)),
            pw.Text('Minimum recommended: ${formatDecimal(warning.recommendedMm, 0)} mm', style: pw.TextStyle(font: regular, fontSize: 9, color: PdfColors.grey700)),
          ]),
        ],
      ),
    );
  }

  pw.Widget _disclaimer(pw.Font regular) => pw.Container(
        padding: pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(color: PdfColors.amber50, borderRadius: pw.BorderRadius.circular(6)),
        child: pw.Text(
          'Calculated dimensions are estimates based on the supplied Kutsaga design data. Practical '
          'construction dimensions may vary (±150 mm). Verify dimensions against applicable engineering '
          'requirements before construction.',
          style: pw.TextStyle(font: regular, fontSize: 8, color: PdfColors.grey800),
        ),
      );
}