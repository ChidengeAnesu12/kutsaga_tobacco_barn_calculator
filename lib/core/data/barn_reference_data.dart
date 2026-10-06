import '../../models/barn_design_sample.dart';
import '../../models/barn_reference_info.dart';
import '../../models/barn_type.dart';

/// Reference content for the Barn Reference Library screens.
///
/// overview/efficiencyLabel/nominalCapacityLabel/features come from
/// Kutsaga's own "Kutsaga Barns" pamphlet. samples come from the Excel
/// workbook's Design Database sheet — real, as-built barns Kutsaga has
/// actually measured, re-verified cell-by-cell for this message rather
/// than trusted from memory.
///
/// A sample's dimensions are NOT a prediction of what BarnCalculator
/// would output for those same inputs — see the Specifications tab's
/// own disclaimer for why.
class BarnReferenceData {
  BarnReferenceData._();

  static const Map<BarnType, BarnReferenceInfo> all = {
    BarnType.kcc1: BarnReferenceInfo(
      barnType: BarnType.kcc1,
      overview:
          'The KCC1 uses counter-current airflow to pre-heat incoming air with '
          'heat already in the barn, so hot air moves through the tobacco more '
          'efficiently. The result is more uniform drying, better leaf quality, '
          'and lower fuel use than a Conventional barn.',
      efficiencyLabel: '3.5 kg coal per 1 kg of tobacco',
      nominalCapacityLabel: '1.6 ha (typical design capacity)',
      features: [
        'Counter-current airflow pre-heats incoming air before it reaches the leaf',
        'Promotes uniform drying across the curing chamber',
        'Lower fuel consumption than a Conventional barn for a comparable cure',
      ],
      samples: [
        BarnDesignSample(label: 'KCC1-1', lengthMm: 6340, widthMm: 5960, floorAreaM2: 37.7864, furnaceLengthMm: 1400, furnaceWidthMm: 430, furnaceHeightMm: 590, bottomDuctHeightMm: 360, topDuctHeightMm: 180, ductWidthMm: 620, ventLengthMm: 360, ventHeightMm: 180, bigVentLengthMm: 500, bigVentHeightMm: 500),
        BarnDesignSample(label: 'KCC1-2', lengthMm: 6000, widthMm: 6000, floorAreaM2: 36.0, furnaceLengthMm: 2100, furnaceWidthMm: 470, furnaceHeightMm: 660, bottomDuctHeightMm: 360, topDuctHeightMm: 270, ductWidthMm: 590, ventLengthMm: 360, ventHeightMm: 270, bigVentLengthMm: 500, bigVentHeightMm: 500),
        BarnDesignSample(label: 'KCC1-3', lengthMm: 6420, widthMm: 5930, floorAreaM2: 38.0706, furnaceLengthMm: 1785, furnaceWidthMm: 500, furnaceHeightMm: 690, bottomDuctHeightMm: 400, topDuctHeightMm: 275, ductWidthMm: 630, ventLengthMm: 400, ventHeightMm: 200, bigVentLengthMm: 500, bigVentHeightMm: 500),
      ],
    ),
    BarnType.rocket: BarnReferenceInfo(
      barnType: BarnType.rocket,
      overview:
          'The Rocket relies on natural draft: inlet vents on one side feed hot, '
          'dry air from the furnace into the barn, while a large outlet vent and '
          'central chimney draw moisture-laden air out. Warm air rising through '
          'the chimney keeps that circulation going without any fan.',
      efficiencyLabel: '4.25 kg wood or coal per 1 kg of tobacco',
      nominalCapacityLabel: '0.5 ha (typical design capacity)',
      features: [
        'Natural-draft design — no powered fan required',
        'Central chimney drives continuous airflow as warm air rises',
        'Long-established, proven design with a track record for reliable cures',
      ],
      samples: [
        BarnDesignSample(label: 'Rocket-1', lengthMm: 6430, widthMm: 4500, floorAreaM2: 28.935, furnaceLengthMm: 1243, furnaceWidthMm: 720, furnaceHeightMm: 710, bottomDuctHeightMm: 441, ductWidthMm: 530, bigVentLengthMm: 840, bigVentHeightMm: 2300, smallVentMm: 150, smallVentQuantity: 10),
        BarnDesignSample(label: 'Rocket-2', lengthMm: 4500, widthMm: 4300, floorAreaM2: 19.35, furnaceLengthMm: 1800, furnaceWidthMm: 440, furnaceHeightMm: 550, bottomDuctHeightMm: 400, ductWidthMm: 500, bigVentLengthMm: 700, bigVentHeightMm: 1600, smallVentMm: 100, smallVentQuantity: 12),
      ],
    ),
    BarnType.conventional: BarnReferenceInfo(
      barnType: BarnType.conventional,
      overview:
          'The Conventional barn is a durable, time-tested natural-airflow design '
          'burning fuelwood, with optional coal and auxiliary fans. It has no '
          'single fixed size — getting good results means correctly matching the '
          'barn, furnace rating, ducting and ventilation openings to each other.',
      efficiencyLabel: '9 kg coal per 1 kg of tobacco',
      nominalCapacityLabel: '2 ha (typical design capacity)',
      features: [
        'Simple, durable construction with a long track record',
        'Flexible fuel — fuelwood, with optional coal and auxiliary fans',
        'Must be carefully sized: barn, furnace, ducting and vents all need to be matched',
      ],
      samples: [], // No as-built samples in the Design Database — every Conventional barn is sized individually (see overview).
    ),
  };
}