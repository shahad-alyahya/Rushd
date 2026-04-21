import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportService {
  static String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static Future<Uint8List> _buildFullAdminReport({
    required String location,
    required DateTime selectedDate,
    required int visitors,
    required int security,
    required int zones,
    required List<String> zoneNames,
    required List<String> securityNames,
    required List<Map<String, dynamic>> readings,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          // 🔹 Header
          pw.Text(
            'Rushd Admin Report',
            style: pw.TextStyle(
              fontSize: 26,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 20),

          pw.Text("Location: $location"),
          pw.Text("Date: ${_formatDate(selectedDate)}"),

          pw.Divider(),

          // 🔹 Summary
          pw.Text("Summary", style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 10),

          pw.Text("Visitors: $visitors"),
          pw.Text("Security Staff: $security"),
          pw.Text("Zones: $zones"),

          pw.SizedBox(height: 20),

          // 🔹 Zones
          pw.Text("Zones", style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 10),

          ...zoneNames.map(
            (z) => pw.Text("- $z"),
          ),

          pw.SizedBox(height: 20),

          // 🔹 Security
          pw.Text("Security Staff", style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 10),

          ...securityNames.map(
            (s) => pw.Text("- $s"),
          ),

          pw.SizedBox(height: 20),

          // 🔹 Sensor Readings
          pw.Text("Sensor Readings", style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 10),

          ...readings.map((r) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Time: ${r['time']}",
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text("Entry: ${r['entry']}"),
                pw.Text("Exit: ${r['exit']}"),
                pw.Text("Inside: ${r['inside']}"),
                pw.Divider(),
              ],
            );
          }),
        ],
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  // 🔹 هذا اللي تستدعينه من Admin Page
  static Future<void> exportFullReport({
    required String location,
    required DateTime selectedDate,
    required int visitors,
    required int security,
    required int zones,
    required List<String> zoneNames,
    required List<String> securityNames,
    required List<Map<String, dynamic>> readings,
  }) async {
    final bytes = await _buildFullAdminReport(
      location: location,
      selectedDate: selectedDate,
      visitors: visitors,
      security: security,
      zones: zones,
      zoneNames: zoneNames,
      securityNames: securityNames,
      readings: readings,
    );

    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }
  static Future<Uint8List> _buildZonesReportPdf({
    required String location,
    required List<String> zoneNames,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
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
              pw.Text('Total Zones: ${zoneNames.length}'),
              pw.SizedBox(height: 20),
              ...zoneNames.map(
                (zone) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Text('- $zone'),
                ),
              ),
            ],
          );
        },
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  static Future<Uint8List> _buildSecurityReportPdf({
    required String location,
    required List<String> securityNames,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
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
              pw.Text('Total Security Staff: ${securityNames.length}'),
              pw.SizedBox(height: 20),
              ...securityNames.map(
                (name) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Text('- $name'),
                ),
              ),
            ],
          );
        },
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  static Future<void> exportZonesReport({
    required String location,
    required List<String> zoneNames,
  }) async {
    final bytes = await _buildZonesReportPdf(
      location: location,
      zoneNames: zoneNames,
    );

    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
    );
  }

  static Future<void> shareZonesReport({
    required String location,
    required List<String> zoneNames,
  }) async {
    final bytes = await _buildZonesReportPdf(
      location: location,
      zoneNames: zoneNames,
    );

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'zones_report.pdf',
    );
  }

  static Future<void> exportSecurityReport({
    required String location,
    required List<String> securityNames,
  }) async {
    final bytes = await _buildSecurityReportPdf(
      location: location,
      securityNames: securityNames,
    );

    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
    );
  }

  static Future<void> shareSecurityReport({
    required String location,
    required List<String> securityNames,
  }) async {
    final bytes = await _buildSecurityReportPdf(
      location: location,
      securityNames: securityNames,
    );

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'security_report.pdf',
    );
  }
  static Future<void> shareFullReport({
    required String location,
    required DateTime selectedDate,
    required int visitors,
    required int security,
    required int zones,
    required List<String> zoneNames,
    required List<String> securityNames,
    required List<Map<String, dynamic>> readings,
  }) async {
    final bytes = await _buildFullAdminReport(
      location: location,
      selectedDate: selectedDate,
      visitors: visitors,
      security: security,
      zones: zones,
      zoneNames: zoneNames,
      securityNames: securityNames,
      readings: readings,
    );

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'rushd_report.pdf',
    );
  }
}