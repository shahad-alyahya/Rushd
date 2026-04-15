import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportService {
  static Future<void> exportAdminReport({
    required String location,
    required String date,
    required int visitors,
    required int security,
    required int zones,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.SizedBox(
            width: double.infinity,
            child: pw.Column(
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
                pw.Text('Date: $date'),
                pw.SizedBox(height: 20),
                pw.Text('Visitors: $visitors'),
                pw.SizedBox(height: 10),
                pw.Text('Security: $security'),
                pw.SizedBox(height: 10),
                pw.Text('Zones: $zones'),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}