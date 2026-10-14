enum BarnType { kcc1, rocket, conventional }

extension BarnTypeDisplay on BarnType {
  String get label => switch (this) {
    BarnType.kcc1 => 'KCC1',
    BarnType.rocket => 'Rocket',
    BarnType.conventional => 'Convectional Model Types',
  };

  String get description => switch (this) {
    BarnType.kcc1 => 'Improved Kutsaga design with controlled ventilation.',
    BarnType.rocket => 'Energy-efficient design with a central flue.',
    BarnType.conventional => 'Traditional and low-cost Kutsaga model options.',
  };

  /// Real Kutsaga barn photographs — replaces the placeholder Icon this
  /// used to return (no icon fallback needed any more).
  String get imageAsset => switch (this) {
    BarnType.kcc1 => 'assets/images/barns/kcc1_barn.jpg',
    BarnType.rocket => 'assets/images/barns/rocket_barn.jpg',
    BarnType.conventional => 'assets/images/barns/conventional_barn.jpg',
  };
}
