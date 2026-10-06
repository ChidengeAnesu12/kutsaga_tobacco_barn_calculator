/// Centralised, immutable Kutsaga design constants.
///
/// Not every constant below is actually consumed by a formula in the
/// current version of the Excel workbook (see the Phase 1 findings at
/// the top of the build guide). They're kept here — centralised,
/// documented, never scattered as magic numbers — because Kutsaga's own
/// spreadsheet lists them as fixed design data even where no formula
/// currently multiplies by them. Each constant is tagged [USED] or
/// [REFERENCE ONLY] so nobody "fixes" a formula to force one in later.
class KutsagaConstants {
  KutsagaConstants._(); // Namespace, not an object — never instantiate this.

  // ---- [USED] Capacity formulas (CALCULATOR!A12:B24, E8:E11) ----------
  /// Hook-to-hook spacing along a pole, in mm.
  /// clipsPerTier = barnWidthMm / hookToHookMm   (CALCULATOR!E8)
  static const double hookToHookMm = 280;

  /// Average leaves tied to one clip/string.
  /// estimatedLeaves = totalStrings * averageLeavesPerClip (CALCULATOR!E10)
  static const double averageLeavesPerClip = 85;

  /// Leaves that make up one hectare-equivalent of cured tobacco.
  /// capacityHa = estimatedLeaves / leavesPerHectare (CALCULATOR!E11)
  static const double leavesPerHectare = 30000;

  // ---- [USED] Reference volumes that scale every ventilation/furnace/
  // duct dimension for KCC1+Conventional vs. Rocket. -------------------
  static const double kcc1ReferenceVolumeMm3 = 188932000000;
  static const double rocketReferenceVolumeMm3 = 115913047500;

  // ---- [REFERENCE ONLY] Not wired into any current formula -----------
  static const double poleToPoleHorizontalMm = 1045;
  static const double poleToPoleVerticalMm = 925;
  static const double poleToDuctVerticalMm = 1100;
  static const double topPoleToRoofMm = 270;
  static const double vSlotOpeningMm = 25;
  static const double vSlotAngleDegrees = 137.7;
  static const double baffleWallLengthMm = 400;
  static const double baffleWallHeightMm = 700;
  static const int baffleWallSteps = 3;
}