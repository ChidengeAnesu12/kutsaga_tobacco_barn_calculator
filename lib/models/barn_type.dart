enum BarnType { kcc1, rocket, conventional }

extension BarnTypeDisplay on BarnType {
  String get label => switch (this) {
        BarnType.kcc1 => 'KCC1',
        BarnType.rocket => 'Rocket',
        BarnType.conventional => 'Conventional',
      };

  String get description => switch (this) {
        BarnType.kcc1 => 'Improved Kutsaga design with controlled ventilation.',
        BarnType.rocket => 'Energy-efficient design with a central flue.',
        BarnType.conventional => 'Traditional barn design.',
      };

  /// Real Kutsaga barn photographs — replaces the placeholder Icon this
  /// used to return (no icon fallback needed any more).
  String get imageAsset => switch (this) {
        BarnType.kcc1 => 'assets/images/barns/kcc1.jpg',
        BarnType.rocket => 'assets/images/barns/rocket.jpg',
        BarnType.conventional => 'assets/images/barns/conventional.jpg',
      };
}