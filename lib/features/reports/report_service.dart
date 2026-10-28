import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../dashboard/domain/password_health.dart';

final class ReportService {
  Future<Uint8List> build(PasswordHealth health) async {
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (_) => <pw.Widget>[
          pw.Text(
            'CyVault Security Summary',
            style: pw.TextStyle(fontSize: 24),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Generated: ${DateTime.now().toUtc().toIso8601String()}'),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: const <String>['Metric', 'Value'],
            data: <List<String>>[
              <String>['Vault items', '${health.total}'],
              <String>['Breached items', '${health.breached}'],
              <String>['Reused passwords', '${health.reused}'],
              <String>['Stale items', '${health.stale}'],
              <String>['Average risk', '${health.averageRisk}/100'],
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'This aggregate report intentionally excludes titles, usernames, URLs, notes, passwords, hashes, keys and recovery material.',
          ),
        ],
      ),
    );
    return document.save();
  }
}
