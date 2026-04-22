
// export.dart

import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportService {
  static String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
static String _buildPeriodDisplay(String periodLabel, DateTime selectedDate) {
  if (periodLabel == 'Daily') {
    return 'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
  } else if (periodLabel == 'Monthly') {
    return 'Month: ${selectedDate.month}/${selectedDate.year}';
  } else {
    return 'Year: ${selectedDate.year}';
  }
}
  static List<MapEntry<String, dynamic>> _sortedEntries(Map<String, dynamic> map) {
    final entries = map.entries.toList();
    entries.sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }

  static pw.Widget _buildKeyValueBlock(
    String title,
    Map<String, dynamic> data,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 0.7),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          ..._sortedEntries(data).map(
            (entry) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Text('${entry.key}: ${entry.value ?? ""}'),
            ),
          ),
        ],
      ),
    );
  }

  static Future<Uint8List> _buildFullAdminReport({
    required String location,
    required DateTime selectedDate,
    required String periodLabel,
    required int visitors,
    required int security,
    required int zones,
    required List<Map<String, dynamic>> zoneDocs,
    required List<Map<String, dynamic>> userDocs,
    required List<Map<String, dynamic>> readingDocs,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'Rushd Admin Report',
            style: pw.TextStyle(
              fontSize: 26,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Location: $location"),
          pw.Text("Period Type: $periodLabel"),
pw.Text(_buildPeriodDisplay(periodLabel, selectedDate)),
          pw.Divider(),
          pw.Text(
            "Summary",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text("Visitors: $visitors"),
          pw.Text("Security Staff: $security"),
          pw.Text("Zones: $zones"),
          pw.SizedBox(height: 20),
          pw.Text(
            "Zones Full Data",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          if (zoneDocs.isEmpty)
            pw.Text("No zones found for this location.")
          else
            ...zoneDocs.asMap().entries.map(
              (entry) => _buildKeyValueBlock(
                'Zone ${entry.key + 1}',
                entry.value,
              ),
            ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Users Full Data",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          if (userDocs.isEmpty)
            pw.Text("No users found for this location.")
          else
            ...userDocs.asMap().entries.map(
              (entry) => _buildKeyValueBlock(
                'User ${entry.key + 1}',
                entry.value,
              ),
            ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Sensor Readings Full Data",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          if (readingDocs.isEmpty)
            pw.Text("No sensor readings found for the selected period.")
          else
            ...readingDocs.asMap().entries.map(
              (entry) => _buildKeyValueBlock(
                'Reading ${entry.key + 1}',
                entry.value,
              ),
            ),
        ],
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  static Future<void> exportFullReport({
    required String location,
    required DateTime selectedDate,
    required String periodLabel,
    required int visitors,
    required int security,
    required int zones,
    required List<Map<String, dynamic>> zoneDocs,
    required List<Map<String, dynamic>> userDocs,
    required List<Map<String, dynamic>> readingDocs,
  }) async {
    final bytes = await _buildFullAdminReport(
      location: location,
      selectedDate: selectedDate,
      periodLabel: periodLabel,
      visitors: visitors,
      security: security,
      zones: zones,
      zoneDocs: zoneDocs,
      userDocs: userDocs,
      readingDocs: readingDocs,
    );

    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }

  static Future<void> shareFullReport({
    required String location,
    required DateTime selectedDate,
    required String periodLabel,
    required int visitors,
    required int security,
    required int zones,
    required List<Map<String, dynamic>> zoneDocs,
    required List<Map<String, dynamic>> userDocs,
    required List<Map<String, dynamic>> readingDocs,
  }) async {
    final bytes = await _buildFullAdminReport(
      location: location,
      selectedDate: selectedDate,
      periodLabel: periodLabel,
      visitors: visitors,
      security: security,
      zones: zones,
      zoneDocs: zoneDocs,
      userDocs: userDocs,
      readingDocs: readingDocs,
    );

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'rushd_report.pdf',
    );
  }

  static Future<Uint8List> _buildZonesReportPdf({
    required String location,
    required List<Map<String, dynamic>> zoneDocs,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'Zones List Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Location: $location'),
          pw.SizedBox(height: 10),
          pw.Text('Total Zones: ${zoneDocs.length}'),
          pw.SizedBox(height: 20),
          if (zoneDocs.isEmpty)
            pw.Text('No zones found for this location.')
          else
            ...zoneDocs.asMap().entries.map(
              (entry) => _buildKeyValueBlock(
                'Zone ${entry.key + 1}',
                entry.value,
              ),
            ),
        ],
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  static Future<Uint8List> _buildSecurityReportPdf({
    required String location,
    required List<Map<String, dynamic>> userDocs,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'Security Staff Report',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Location: $location'),
          pw.SizedBox(height: 10),
          pw.Text('Total Users: ${userDocs.length}'),
          pw.SizedBox(height: 20),
          if (userDocs.isEmpty)
            pw.Text('No users found for this location.')
          else
            ...userDocs.asMap().entries.map(
              (entry) => _buildKeyValueBlock(
                'User ${entry.key + 1}',
                entry.value,
              ),
            ),
        ],
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  static Future<void> exportZonesReport({
    required String location,
    required List<Map<String, dynamic>> zoneDocs,
  }) async {
    final bytes = await _buildZonesReportPdf(
      location: location,
      zoneDocs: zoneDocs,
    );

    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
    );
  }

  static Future<void> shareZonesReport({
    required String location,
    required List<Map<String, dynamic>> zoneDocs,
  }) async {
    final bytes = await _buildZonesReportPdf(
      location: location,
      zoneDocs: zoneDocs,
    );

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'zones_report.pdf',
    );
  }

  static Future<void> exportSecurityReport({
    required String location,
    required List<Map<String, dynamic>> userDocs,
  }) async {
    final bytes = await _buildSecurityReportPdf(
      location: location,
      userDocs: userDocs,
    );

    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
    );
  }

  static Future<void> shareSecurityReport({
    required String location,
    required List<Map<String, dynamic>> userDocs,
  }) async {
    final bytes = await _buildSecurityReportPdf(
      location: location,
      userDocs: userDocs,
    );

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'security_report.pdf',
    );
  }
}