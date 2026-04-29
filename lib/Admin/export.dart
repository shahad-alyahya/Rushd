import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportService {
  static String _buildPeriodDisplay(String periodLabel, DateTime selectedDate) {
    if (periodLabel == 'Daily') {
      return 'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
    } else if (periodLabel == 'Monthly') {
      return 'Month: ${selectedDate.month}/${selectedDate.year}';
    } else {
      return 'Year: ${selectedDate.year}';
    }
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static String _safeText(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static String _formatReadableDate(dynamic value) {
    if (value == null) return '';

    if (value is DateTime) {
      return '${value.day.toString().padLeft(2, '0')}/'
          '${value.month.toString().padLeft(2, '0')}/'
          '${value.year} '
          '${value.hour.toString().padLeft(2, '0')}:'
          '${value.minute.toString().padLeft(2, '0')}:'
          '${value.second.toString().padLeft(2, '0')}';
    }

    final text = value.toString().trim();
    return text;
  }

  static String _formatPolygonPoints(dynamic value) {
    if (value == null) return '';

    if (value is List) {
      return value.map((point) {
        if (point is Map) {
          final lat = point['lat'] ?? '';
          final lng = point['lng'] ?? '';
          return '($lat, $lng)';
        }
        return point.toString();
      }).join(' | ');
    }

    return value.toString();
  }

  static bool _showCharts(String periodLabel) {
    return periodLabel == 'Monthly' || periodLabel == 'Yearly';
  }

  static Map<String, int> _buildCongestionStats(
    List<Map<String, dynamic>> zoneDocs,
  ) {
    int low = 0;
    int medium = 0;
    int high = 0;

    for (final zone in zoneDocs) {
      final level = (zone['congestionLevel'] ?? '')
          .toString()
          .trim()
          .toLowerCase();

      if (level == 'high') {
        high++;
      } else if (level == 'medium') {
        medium++;
      } else {
        low++;
      }
    }

    return {
      'Low': low,
      'Medium': medium,
      'High': high,
    };
  }

  static List<Map<String, dynamic>> _buildZoneTrafficStats(
    List<Map<String, dynamic>> readingDocs,
  ) {
    final Map<String, int> zoneTotals = {};

    for (final reading in readingDocs) {
      final zoneId = _safeText(reading['zoneId']).trim();
      if (zoneId.isEmpty) continue;

      final entryCount = _toInt(reading['entryCount']);
      zoneTotals[zoneId] = (zoneTotals[zoneId] ?? 0) + entryCount;
    }

    final items = zoneTotals.entries
        .map((e) => {'label': e.key, 'value': e.value})
        .toList();

    items.sort((a, b) => _toInt(b['value']).compareTo(_toInt(a['value'])));

    return items.take(6).toList();
  }

  static pw.Widget _buildBarChart({
    required String title,
    required List<Map<String, dynamic>> items,
    required List<PdfColor> colors,
  }) {
    if (items.isEmpty) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(14),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text('No chart data available.'),
          ],
        ),
      );
    }

    int maxValue = 0;
    for (final item in items) {
      final v = _toInt(item['value']);
      if (v > maxValue) maxValue = v;
    }
    if (maxValue == 0) maxValue = 1;

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(10),
        color: PdfColors.white,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 14),
          pw.SizedBox(
            height: 180,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final value = _toInt(item['value']);
                final label = _safeText(item['label']);
                final barHeight = (value / maxValue) * 110;

                return pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text(
                          value.toString(),
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Container(
                          width: 28,
                          height: barHeight,
                          decoration: pw.BoxDecoration(
                            color: colors[index % colors.length],
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          label,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildChartsSection({
    required String periodLabel,
    required List<Map<String, dynamic>> zoneDocs,
    required List<Map<String, dynamic>> readingDocs,
  }) {
    if (!_showCharts(periodLabel)) {
      return pw.SizedBox();
    }

    final congestionStats = _buildCongestionStats(zoneDocs);
    final congestionItems = [
      {'label': 'Low', 'value': congestionStats['Low'] ?? 0},
      {'label': 'Medium', 'value': congestionStats['Medium'] ?? 0},
      {'label': 'High', 'value': congestionStats['High'] ?? 0},
    ];

    final trafficItems = _buildZoneTrafficStats(readingDocs);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Analytics',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        _buildBarChart(
          title: 'Zone Congestion Distribution',
          items: congestionItems,
          colors: [
            PdfColors.green400,
            PdfColors.orange400,
            PdfColors.red400,
          ],
        ),
        pw.SizedBox(height: 16),
        _buildBarChart(
          title: 'Visitor Flow by Zone',
          items: trafficItems,
          colors: [
            PdfColors.purple300,
            PdfColors.blue300,
            PdfColors.teal300,
            PdfColors.indigo300,
            PdfColors.cyan300,
            PdfColors.deepPurple300,
          ],
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildSummaryCard({
    required String label,
    required String value,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey200,
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          children: [
            pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<pw.MemoryImage> _loadLogo() async {
    final logoData = await rootBundle.load('assets/images/LogoRushd.png');
    return pw.MemoryImage(logoData.buffer.asUint8List());
  }

  static pw.Widget _buildHeader({
    required pw.MemoryImage logoImage,
    required String subtitle,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Rushd System',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              subtitle,
              style: const pw.TextStyle(fontSize: 13),
            ),
          ],
        ),
        pw.Image(logoImage, width: 130, height: 130),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Center(
      child: pw.Text(
        'Rushd Team',
        style: pw.TextStyle(
          fontSize: 10,
          color: PdfColors.grey,
        ),
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
    final logoImage = await _loadLogo();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          _buildHeader(
            logoImage: logoImage,
            subtitle: 'Crowd Management Report',
          ),
          pw.SizedBox(height: 10),
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
          pw.Row(
            children: [
              _buildSummaryCard(label: 'Visitors', value: visitors.toString()),
              pw.SizedBox(width: 10),
              _buildSummaryCard(label: 'Security', value: security.toString()),
              pw.SizedBox(width: 10),
              _buildSummaryCard(label: 'Zones', value: zones.toString()),
            ],
          ),
          pw.SizedBox(height: 20),
          _buildChartsSection(
            periodLabel: periodLabel,
            zoneDocs: zoneDocs,
            readingDocs: readingDocs,
          ),
          pw.Text(
            "Zones",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          if (zoneDocs.isEmpty)
            pw.Text("No zones found for this location.")
          else
            pw.Table.fromTextArray(
              headers: ['Zone', 'Status', 'Count'],
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.purple300,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              data: zoneDocs.map((z) => [
                _safeText(z['zoneName']),
                _safeText(z['congestionLevel']),
                _safeText(z['currentCount']),
              ]).toList(),
            ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Users",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          if (userDocs.isEmpty)
            pw.Text("No users found for this location.")
          else
            pw.Table.fromTextArray(
              headers: ['Name', 'Email', 'Role'],
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.purple300,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              data: userDocs.map((u) => [
                _safeText(u['fullName']),
                _safeText(u['email']),
                _safeText(u['role']),
              ]).toList(),
            ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Sensor Readings",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          if (readingDocs.isEmpty)
            pw.Text("No sensor readings found for the selected period.")
          else
            pw.Table.fromTextArray(
              headers: ['Zone', 'Entry', 'Exit', 'Time'],
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.purple300,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              data: readingDocs.map((r) => [
                _safeText(r['zoneId']),
                _safeText(r['entryCount']),
                _safeText(r['exitCount']),
                _safeText(r['readingDate']),
              ]).toList(),
            ),
        ],
        footer: (context) => _buildFooter(),
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
    final logoImage = await _loadLogo();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          _buildHeader(
            logoImage: logoImage,
            subtitle: 'Zones Report',
          ),
          pw.SizedBox(height: 10),
          pw.Text('Location: $location'),
          pw.Text('Total Zones: ${zoneDocs.length}'),
          pw.Divider(),
          pw.Text(
            "Zones List",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          if (zoneDocs.isEmpty)
            pw.Text("No zones available")
          else
            pw.Table.fromTextArray(
              headers: [
                'Zone Name',
                'Capacity',
                'Status',
                'Last Updated',
              ],
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.purple300,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              data: zoneDocs.map((z) => [
                _safeText(z['zoneName']),
                _safeText(z['capacity']),
                _safeText(z['congestionLevel']),
                _formatReadableDate(z['lastUpdated']),
              ]).toList(),
            ),
        ],
        footer: (context) => _buildFooter(),
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  static Future<Uint8List> _buildSecurityReportPdf({
    required String location,
    required List<Map<String, dynamic>> userDocs,
  }) async {
    final pdf = pw.Document();
    final logoImage = await _loadLogo();

    final securityDocs = userDocs.where((u) {
      final role = (u['role'] ?? '').toString().toLowerCase().trim();
      return role == 'security' ||
          role == 'security staff' ||
          role == 'security_staff' ||
          role == 'securitystaff';
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          _buildHeader(
            logoImage: logoImage,
            subtitle: 'Security Staff Report',
          ),
          pw.SizedBox(height: 10),
          pw.Text('Location: $location'),
          pw.Text('Total Security: ${securityDocs.length}'),
          pw.Divider(),
          pw.Text(
            "Security Staff",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          if (securityDocs.isEmpty)
            pw.Text("No security staff found")
          else
            pw.Table.fromTextArray(
              headers: [
                'Name',
                'Email',
                'Created At',
              ],
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.purple300,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              data: securityDocs.map((u) => [
                _safeText(u['fullName']),
                _safeText(u['email']),
                _formatReadableDate(u['createdAt']),
              ]).toList(),
            ),
        ],
        footer: (context) => _buildFooter(),
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