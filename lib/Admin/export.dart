import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportService {
  static String _formatDateByFilter(DateTime date, String filter) {
    switch (filter) {
      case 'Daily':
        return '${date.day}/${date.month}/${date.year}';
      case 'Monthly':
        return '${date.month}/${date.year}';
      case 'Year':
        return '${date.year}';
      default:
        return '${date.day}/${date.month}/${date.year}';
    }
  }

  static Future<Uint8List> _buildAdminReportPdf({
    required String location,
    required DateTime selectedDate,
    required String filter,
    required int visitors,
    required int security,
    required int zones,
  }) async {
    final pdf = pw.Document();
    final formattedDate = _formatDateByFilter(selectedDate, filter);

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Admin Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Location: $location'),
              pw.SizedBox(height: 10),
              pw.Text('Filter: $filter'),
              pw.SizedBox(height: 10),
              pw.Text('Date: $formattedDate'),
              pw.SizedBox(height: 20),
              pw.Text('Visitors: $visitors'),
              pw.SizedBox(height: 10),
              pw.Text('Security: $security'),
              pw.SizedBox(height: 10),
              pw.Text('Zones: $zones'),
            ],
          );
        },
      ),
    );

    return Uint8List.fromList(await pdf.save());
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
            ],);
        },
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  static Future<void> exportAdminReport({
    required String location,
    required DateTime selectedDate,
    required String filter,
    required int visitors,
    required int security,
    required int zones,
  }) async {
    final bytes = await _buildAdminReportPdf(
      location: location,
      selectedDate: selectedDate,
      filter: filter,
      visitors: visitors,
      security: security,
      zones: zones,
    );

    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
    );
  }

  static Future<void> shareAdminReport({
    required String location,
    required DateTime selectedDate,
    required String filter,
    required int visitors,
    required int security,
    required int zones,
  }) async {
    final bytes = await _buildAdminReportPdf(
      location: location,
      selectedDate: selectedDate,
      filter: filter,
      visitors: visitors,
      security: security,
      zones: zones,
    );

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'admin_report.pdf',
    );
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
}