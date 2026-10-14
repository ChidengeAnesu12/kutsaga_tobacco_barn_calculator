import '../../models/barn_design_sample.dart';
import '../../models/barn_reference_info.dart';
import '../../models/barn_type.dart';

/// Reference content for the Barn Reference Library screens.
///
/// Overview, efficiency, plan, and model text comes from Kutsaga's
/// integrated curing systems handbook and approved plan PDFs. Samples
/// come from the Excel workbook's Design Database sheet - real,
/// as-built barns Kutsaga has actually measured.
///
/// A sample's dimensions are not a prediction of what BarnCalculator
/// would output for those same inputs; see the Specifications tab's
/// own disclaimer for why.
class BarnReferenceData {
  BarnReferenceData._();

  static const List<BarnReferenceInfo> all = [
    BarnReferenceInfo(
      id: 'family',
      title: 'Family Barn',
      description: 'Small-scale high-efficiency wood-fired curing barn.',
      imageAsset: 'assets/images/barns/family_barn.jpg',
      overview:
          'The Family Barn is a small-scale Kutsaga curing structure designed '
          'for growers curing up to 0.58 hectares of tobacco. Its composite '
          'wall structure and Tsotso furnace integration help retain heat, '
          'support steady curing temperatures and reduce fuelwood use while '
          'still keeping the structure practical for family-level production.',
      efficiencyLabel: '2 kg wood per 1 kg of tobacco',
      nominalCapacityLabel: '0.58 ha (typical design capacity)',
      plans: [
        BarnPlanInfo(
          title: 'Family Barn plan',
          description: 'Family Barn approved technical drawing set.',
          assetPath: 'assets/plans/family_barn_plan.pdf',
          fileName: 'family_barn_plan.pdf',
        ),
      ],
      features: [
        'Composite insulated wall structure improves heat retention',
        'Tsotso furnace integration supports lower fuelwood consumption',
        'Designed for small-scale growers who need a practical high-efficiency barn',
      ],
      samples: [],
    ),
    BarnReferenceInfo(
      id: 'gunny',
      title: 'Gunny Barn',
      description: 'Low-cost hessian-bag curing barn for smallholder growers.',
      imageAsset: 'assets/images/barns/gunny_barn.jpg',
      overview:
          'The Gunny Barn is a low-cost curing option built around tightly '
          'secured hessian bag walls fixed to a brick base and treated with a '
          'thermal coating made from anthill soil, cow dung and lime. It gives '
          'smallholder growers an accessible curing structure while using the '
          'same heat-exchanger and Tsotso furnace principles found in other '
          'Kutsaga barn options.',
      efficiencyLabel: '3.4 kg wood per 1 kg of tobacco',
      nominalCapacityLabel: '0.3 ha (typical design capacity)',
      plans: [
        BarnPlanInfo(
          title: 'Gunny Barn plan',
          description: 'Gunny Barn approved technical drawing set.',
          assetPath: 'assets/plans/gunny_barn_plan.pdf',
          fileName: 'gunny_barn_plan.pdf',
        ),
      ],
      features: [
        'Hessian bag walls lower construction cost and material requirements',
        'Anthill soil, cow dung and lime coating improves wall insulation',
        'Suitable for smallholder growers needing an affordable Kutsaga curing option',
      ],
      samples: [],
    ),
    BarnReferenceInfo(
      id: 'kcc1',
      title: 'KCC1 Barn',
      description: 'Counter-current medium-scale Kutsaga curing design.',
      imageAsset: 'assets/images/barns/kcc1_barn.jpg',
      calculatorBarnType: BarnType.kcc1,
      overview:
          'The KCC1 is a wood-fired tobacco curing barn engineered to handle '
          'larger production volumes of up to 1.0 hectares per curing cycle. '
          'It features a counter-current duct-based heat distribution system '
          'with metal sheet ducts separating the top and bottom ducts. Heated '
          'air moves from the furnace in one direction while incoming cold air '
          'is routed through the top duct, allowing outside ventilation air to '
          'be pre-heated before entering the barn. This reduces direct '
          'radiation and supports better quality cures at higher fuel '
          'efficiency.',
      efficiencyLabel: '4 kg wood per 1 kg of tobacco',
      nominalCapacityLabel: '1 ha (typical design capacity)',
      plans: [
        BarnPlanInfo(
          title: 'KCC1 approved barn plan',
          description: 'Kutsaga Counter Current 1 technical drawing set.',
          assetPath: 'assets/plans/kcc1_approved_plan.pdf',
          fileName: 'kcc1_approved_plan.pdf',
        ),
      ],
      features: [
        'Counter-current airflow pre-heats incoming air before it reaches the leaf',
        'Promotes uniform drying across the curing chamber',
        'Lower fuel consumption than a Conventional barn for a comparable cure',
      ],
      samples: [
        BarnDesignSample(
          label: 'KCC1-1',
          lengthMm: 6340,
          widthMm: 5960,
          floorAreaM2: 37.7864,
          furnaceLengthMm: 1400,
          furnaceWidthMm: 430,
          furnaceHeightMm: 590,
          bottomDuctHeightMm: 360,
          topDuctHeightMm: 180,
          ductWidthMm: 620,
          ventLengthMm: 360,
          ventHeightMm: 180,
          bigVentLengthMm: 500,
          bigVentHeightMm: 500,
        ),
        BarnDesignSample(
          label: 'KCC1-2',
          lengthMm: 6000,
          widthMm: 6000,
          floorAreaM2: 36.0,
          furnaceLengthMm: 2100,
          furnaceWidthMm: 470,
          furnaceHeightMm: 660,
          bottomDuctHeightMm: 360,
          topDuctHeightMm: 270,
          ductWidthMm: 590,
          ventLengthMm: 360,
          ventHeightMm: 270,
          bigVentLengthMm: 500,
          bigVentHeightMm: 500,
        ),
        BarnDesignSample(
          label: 'KCC1-3',
          lengthMm: 6420,
          widthMm: 5930,
          floorAreaM2: 38.0706,
          furnaceLengthMm: 1785,
          furnaceWidthMm: 500,
          furnaceHeightMm: 690,
          bottomDuctHeightMm: 400,
          topDuctHeightMm: 275,
          ductWidthMm: 630,
          ventLengthMm: 400,
          ventHeightMm: 200,
          bigVentLengthMm: 500,
          bigVentHeightMm: 500,
        ),
      ],
    ),
    BarnReferenceInfo(
      id: 'rocket',
      title: 'Rocket Barn',
      description: 'Natural-draft curing barn with efficient heat movement.',
      imageAsset: 'assets/images/barns/rocket_barn.jpg',
      calculatorBarnType: BarnType.rocket,
      overview:
          'The Rocket Barn is a capable curing structure designed for 0.5 '
          'hectares of tobacco. It operates primarily on wood and can be '
          'retrofitted with the BE-21 furnace for coal or the Tsotso furnace '
          'where small biomass fuel is preferred. Its thatch ceiling with '
          '250-micron black plastic insulation reduces heat loss and improves '
          'curing consistency.',
      efficiencyLabel: '4.5 kg wood per 1 kg of tobacco',
      nominalCapacityLabel: '0.5 ha (typical design capacity)',
      plans: [
        BarnPlanInfo(
          title: 'Rocket approved barn plan',
          description: 'Rocket Barn technical drawing set.',
          assetPath: 'assets/plans/rocket_approved_plan.pdf',
          fileName: 'rocket_approved_plan.pdf',
        ),
      ],
      features: [
        'Natural draft airflow draws hot, dry air through the leaf',
        'Large outlet vent and central chimney improve upward draft',
        'Can use wood, with BE-21 and Tsotso furnace retrofit options',
      ],
      samples: [
        BarnDesignSample(
          label: 'Rocket-1',
          lengthMm: 6430,
          widthMm: 4500,
          floorAreaM2: 28.935,
          furnaceLengthMm: 1243,
          furnaceWidthMm: 720,
          furnaceHeightMm: 710,
          bottomDuctHeightMm: 441,
          ductWidthMm: 530,
          bigVentLengthMm: 840,
          bigVentHeightMm: 2300,
          smallVentMm: 150,
          smallVentQuantity: 10,
        ),
        BarnDesignSample(
          label: 'Rocket-2',
          lengthMm: 4500,
          widthMm: 4300,
          floorAreaM2: 19.35,
          furnaceLengthMm: 1800,
          furnaceWidthMm: 440,
          furnaceHeightMm: 550,
          bottomDuctHeightMm: 400,
          ductWidthMm: 500,
          bigVentLengthMm: 700,
          bigVentHeightMm: 1600,
          smallVentMm: 100,
          smallVentQuantity: 12,
        ),
      ],
    ),
    BarnReferenceInfo(
      id: 'gas-cure',
      title: 'Gas-Cure Barn',
      description: 'Automated LPG or biogas curing system.',
      imageAsset: 'assets/images/barns/gas_cure_barn.jpg',
      overview:
          'The Gas-Cure Barn uses LPG or biogas with automated controls to '
          'support cleaner combustion, precise temperature management and '
          'consistent curing conditions. It is intended for growers or '
          'operations that need high cure quality and are able to support a '
          'higher-technology fuel and control system.',
      efficiencyLabel: 'Controlled LPG or biogas combustion',
      nominalCapacityLabel: 'Capacity depends on installation',
      plans: [
        BarnPlanInfo(
          title: 'Gas-Cure Barn reference',
          description:
              'Gas-Cure Barn reference page from the Kutsaga pamphlet.',
          assetPath: 'assets/plans/gas_cure_barn_reference.pdf',
          fileName: 'gas_cure_barn_reference.pdf',
        ),
      ],
      features: [
        'Automated controls support stable temperature management',
        'Clean combustion improves curing consistency and reduces smoke-related quality risks',
        'Premium technology option for growers prioritising high-quality cures',
      ],
      samples: [],
    ),
    BarnReferenceInfo(
      id: 'conventional',
      title: 'Conventional Barn',
      description: 'Traditional natural-airflow barn with retrofit potential.',
      imageAsset: 'assets/images/barns/conventional_barn.jpg',
      calculatorBarnType: BarnType.conventional,
      overview:
          'The Conventional Barn is a long-established tobacco curing design '
          'with a typical capacity of up to 2 hectares. It has historically '
          'used high fuel input, but the pamphlet highlights retrofit '
          'opportunities that can improve airflow, heat transfer and fuel '
          'efficiency for existing structures.',
      efficiencyLabel: 'More than 9 kg coal per 1 kg of tobacco',
      nominalCapacityLabel: '2 ha (typical design capacity)',
      plans: [
        BarnPlanInfo(
          title: 'Conventional Barn reference',
          description:
              'Conventional Barn reference page from the Kutsaga pamphlet.',
          assetPath: 'assets/plans/conventional_barn_reference.pdf',
          fileName: 'conventional_barn_reference.pdf',
        ),
      ],
      features: [
        'Long-established curing structure with wide field familiarity',
        'Fuel consumption can be high without airflow and heat-transfer upgrades',
        'Retrofits can reduce fuel use by improving ducts, vents and furnace performance',
      ],
      samples: [],
    ),
    BarnReferenceInfo(
      id: 'tunnel-2ha',
      title: '2-Hectare Tunnel Barn',
      description: 'Medium-scale insulated tunnel curing system.',
      imageAsset: 'assets/images/barns/tunnel_2ha_barn.jpg',
      overview:
          'The 2-Hectare Tunnel Barn is a medium-scale tunnel curing option '
          'intended for higher-throughput operations, outgrower schemes or '
          'cooperative use. Its insulated curing chamber and tunnel layout '
          'support controlled airflow and more consistent heat distribution '
          'across larger curing loads.',
      efficiencyLabel: 'Fuel efficiency depends on tunnel configuration',
      nominalCapacityLabel: '2 ha (typical design capacity)',
      plans: [
        BarnPlanInfo(
          title: '2-Hectare Tunnel Barn reference',
          description:
              '2-Hectare Tunnel Barn reference page from the Kutsaga pamphlet.',
          assetPath: 'assets/plans/tunnel_2ha_reference.pdf',
          fileName: 'tunnel_2ha_reference.pdf',
        ),
      ],
      features: [
        'Tunnel layout supports medium-scale batch handling',
        'Insulated curing chamber helps stabilise curing conditions',
        'Suitable for grouped production, outgrower schemes and cooperative operations',
      ],
      samples: [],
    ),
    BarnReferenceInfo(
      id: 'rocket-tunnel',
      title: 'Kutsaga Rocket Tunnel Barn',
      description: 'Large-scale 6-10 ha tunnel with Rocket heat exchange.',
      imageAsset: 'assets/images/barns/rocket_tunnel_barn.jpg',
      overview:
          'The Kutsaga Rocket Tunnel Barn is a high-capacity tunnel curing '
          'system designed for 6 to 10 hectares. It combines Rocket-style heat '
          'exchange and ventilation principles with a continuous tunnel '
          'arrangement, allowing larger curing volumes to move through '
          'multiple curing zones.',
      efficiencyLabel: 'Rocket heat-exchanger tunnel system',
      nominalCapacityLabel: '6-10 ha (typical design capacity)',
      plans: [
        BarnPlanInfo(
          title: 'Kutsaga Rocket Tunnel Barn plan',
          description:
              'Rocket Tunnel overview and 6HA barn technical drawing set.',
          assetPath: 'assets/plans/rocket_tunnel_6ha_plan.pdf',
          fileName: 'rocket_tunnel_6ha_plan.pdf',
        ),
      ],
      features: [
        'Designed for 6-10 hectares of curing capacity',
        'Multiple tunnel zones support large-volume curing flow',
        'Combines tunnel throughput with Rocket heat-exchanger and ventilation principles',
      ],
      samples: [],
    ),
  ];

  static BarnReferenceInfo? forCalculatorType(BarnType barnType) {
    for (final info in all) {
      if (info.calculatorBarnType == barnType) {
        return info;
      }
    }
    return null;
  }
}
