import 'barn_input.dart';
import 'barn_owner_info.dart';
import 'barn_type.dart';

class SavedBarnRecord {
  final String id;
  final int sequenceNumber;
  final DateTime savedAt;
  final BarnInput input;
  final BarnOwnerInfo ownerInfo;

  SavedBarnRecord({
    required this.id,
    required this.sequenceNumber,
    required this.savedAt,
    required this.input,
    required this.ownerInfo,
  });

  String get label => '${input.barnType.label}-$sequenceNumber';

  Map<String, dynamic> toJson() => {
        'id': id,
        'sequenceNumber': sequenceNumber,
        'savedAt': savedAt.toIso8601String(),
        'barnType': input.barnType.name,
        'lengthMm': input.lengthMm,
        'widthMm': input.widthMm,
        'heightMm': input.heightMm,
        'poleTiers': input.poleTiers,
        'horizontalPoles': input.horizontalPoles,
        'ownerName': ownerInfo.ownerName,
        'location': ownerInfo.location,
      };

  factory SavedBarnRecord.fromJson(Map<String, dynamic> json) {
    return SavedBarnRecord(
      id: json['id'] as String,
      sequenceNumber: json['sequenceNumber'] as int,
      savedAt: DateTime.parse(json['savedAt'] as String),
      input: BarnInput(
        lengthMm: (json['lengthMm'] as num).toDouble(),
        widthMm: (json['widthMm'] as num).toDouble(),
        heightMm: (json['heightMm'] as num).toDouble(),
        poleTiers: json['poleTiers'] as int,
        horizontalPoles: json['horizontalPoles'] as int,
        barnType: BarnType.values.byName(json['barnType'] as String),
      ),
      // Tolerant of records saved before this field existed — an older
      // history entry just shows blank rather than failing to load.
      ownerInfo: BarnOwnerInfo(
        ownerName: json['ownerName'] as String? ?? '',
        location: json['location'] as String? ?? '',
      ),
    );
  }
}