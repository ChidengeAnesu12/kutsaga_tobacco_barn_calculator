import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/barn_input.dart';
import '../models/saved_barn_record.dart';
import '../models/barn_owner_info.dart';

/// Reads and writes SavedBarnRecords to a single JSON file in the app's
/// own private document storage — no Android permission needed, and it
/// survives closing the app (though not uninstalling it, which is the
/// same, expected behaviour every app's local data has).
///
/// [directoryProvider] defaults to the real platform location but can
/// be swapped out — same constructor-injection pattern BarnCalculator
/// used for its four calculators in Part 2.
class BarnHistoryRepository {
  BarnHistoryRepository({Future<Directory> Function()? directoryProvider})
      : _directoryProvider = directoryProvider ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _directoryProvider;

  Future<File> _historyFile() async {
    final dir = await _directoryProvider();
    return File('${dir.path}/barn_history.json');
  }

  /// Most recently saved first — the order a dashboard should show.
  Future<List<SavedBarnRecord>> loadAll() async {
    final file = await _historyFile();
    if (!await file.exists()) return [];

    try {
      final raw = await file.readAsString();
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      final records = list.map(SavedBarnRecord.fromJson).toList();
      records.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      return records;
    } catch (_) {
      // A hand-edited or corrupted file shouldn't crash the dashboard —
      // treat it as empty rather than throwing. (Worth knowing: this
      // currently blanks the whole list rather than skipping just the
      // one bad entry — fine for now, an easy follow-up if it ever
      // actually happens.)
      return [];
    }
  }

  /// Assigns the next sequence number for this barn type — highest
  /// existing + 1, not a count, so labels stay unique even if a delete
  /// feature gets added later — and appends the record.
  Future<SavedBarnRecord> save(BarnInput input, BarnOwnerInfo ownerInfo) async {
  final existing = await loadAll();
  final sameType = existing.where((r) => r.input.barnType == input.barnType);
  final nextSequence = sameType.isEmpty ? 1 : sameType.map((r) => r.sequenceNumber).reduce((a, b) => a > b ? a : b) + 1;

  final record = SavedBarnRecord(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    sequenceNumber: nextSequence,
    savedAt: DateTime.now(),
    input: input,
    ownerInfo: ownerInfo,
  );

  final updated = [record, ...existing];
  final file = await _historyFile();
  await file.writeAsString(jsonEncode(updated.map((r) => r.toJson()).toList()));
  return record;
}
}