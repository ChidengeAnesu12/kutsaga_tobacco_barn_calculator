import 'barn_design_sample.dart';
import 'barn_type.dart';

/// Curated, static reference content for one barn type — from
/// Kutsaga's own pamphlet (overview, efficiency, nominal capacity,
/// features) and the Excel workbook's Design Database sheet (samples).
/// Hand-written reference copy, not a calculation — lives entirely
/// outside calculations/.
class BarnReferenceInfo {
  final BarnType barnType;
  final String overview;
  final String efficiencyLabel;
  final String nominalCapacityLabel;
  final List<String> features;
  final List<BarnDesignSample> samples;

  const BarnReferenceInfo({
    required this.barnType,
    required this.overview,
    required this.efficiencyLabel,
    required this.nominalCapacityLabel,
    required this.features,
    required this.samples,
  });
}