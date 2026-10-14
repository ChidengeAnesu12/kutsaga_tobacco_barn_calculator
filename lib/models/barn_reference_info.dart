import 'barn_design_sample.dart';
import 'barn_type.dart';

class BarnModelOverview {
  final String title;
  final String overview;
  final String efficiencyLabel;

  const BarnModelOverview({
    required this.title,
    required this.overview,
    required this.efficiencyLabel,
  });
}

class BarnPlanInfo {
  final String title;
  final String description;
  final String assetPath;
  final String fileName;

  const BarnPlanInfo({
    required this.title,
    required this.description,
    required this.assetPath,
    required this.fileName,
  });
}

/// Curated, static reference content for one barn type — from
/// Kutsaga's own pamphlet (overview, efficiency, nominal capacity,
/// features) and the Excel workbook's Design Database sheet (samples).
/// Hand-written reference copy, not a calculation — lives entirely
/// outside calculations/.
class BarnReferenceInfo {
  final String id;
  final String title;
  final String description;
  final String imageAsset;
  final BarnType? calculatorBarnType;
  final String overview;
  final String efficiencyLabel;
  final String nominalCapacityLabel;
  final List<BarnModelOverview> modelOverviews;
  final List<BarnPlanInfo> plans;
  final List<String> features;
  final List<BarnDesignSample> samples;

  const BarnReferenceInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAsset,
    this.calculatorBarnType,
    required this.overview,
    required this.efficiencyLabel,
    required this.nominalCapacityLabel,
    this.modelOverviews = const [],
    this.plans = const [],
    required this.features,
    required this.samples,
  });
}
