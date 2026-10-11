import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../models/pos/pos_money_model.dart';

enum ReportPreset { today, week, month, custom }

typedef ReportRange = ({String from, String to});

/// The dates a preset covers (the phone's own calendar). Custom ranges are chosen by the person.
ReportRange reportRangeFor(ReportPreset p, DateTime now) {
  final today = isoDay(now);
  switch (p) {
    case ReportPreset.today:
    case ReportPreset.custom:
      return (from: today, to: today);
    case ReportPreset.week:
      return (from: isoDay(DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6))), to: today);
    case ReportPreset.month:
      return (from: isoDay(DateTime(now.year, now.month, 1)), to: today);
  }
}

/// The server allows at most this many days in one report.
const int kMaxReportDays = 366;

final posReportProvider = FutureProvider.autoDispose.family<PosReport, ReportRange>(
  (ref, range) => ref.watch(posReportRepositoryProvider).report(from: range.from, to: range.to),
);

/// Hands a CSV file to the phone's share sheet. A seam so tests need no phone. A BOM is added so spreadsheets read
/// Hindi names correctly.
final posCsvSharerProvider = Provider<Future<void> Function(String fileName, String csv)>((ref) => (fileName, csv) async {
      final bytes = Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(csv)]);
      await SharePlus.instance.share(ShareParams(
        files: [XFile.fromData(bytes, mimeType: 'text/csv', name: fileName)],
        fileNameOverrides: [fileName],
        subject: fileName,
      ));
    });

String csvFileName(ReportRange r) => 'counter-sales-${r.from}-to-${r.to}.csv';
