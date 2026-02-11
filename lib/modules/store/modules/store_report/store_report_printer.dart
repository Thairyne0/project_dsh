import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'models/store_report.model.dart';

class StoreReportPrinter {
  static Future<void> printReport(StoreReport report) async {
    final pdf = pw.Document();

    // Carica il logo
    final ByteData bytes = await rootBundle.load('assets/images/logo_light.png');
    final Uint8List logoBytes = bytes.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Intestazione con logo
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("RAGIONE SOCIALE: ${report.store.name}", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text("INSEGNA: ${report.store.name}", style: pw.TextStyle(fontSize: 14)),
                        pw.SizedBox(height: 10),
                        pw.Text("UNITÀ LOCALE: ${report.store.name}", style: pw.TextStyle(fontSize: 14)),
                        pw.Text("FATTURATO MESE DI: ${report.reportDateFormat}", style: pw.TextStyle(fontSize: 14)),
                      ],
                    ),
                    pw.Image(pw.MemoryImage(logoBytes), width: 80),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Tabella principale
                _buildTable(report),
                pw.SizedBox(height: 20),

                pw.Text("Numero ingressi: ${report.ingressi}", style: pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 30),
                pw.Text("Data: ${report.createdAtDate}", style: pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text("Firma e Timbro del Responsabile/Titolare", style: pw.TextStyle(fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );

    // Stampa diretta
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static pw.Widget _buildTable(StoreReport report) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _cell("IVA 22%"), _cell("IVA 10%"), _cell("IVA 5%"), _cell("IVA 4%"), _cell("IVA 0%"),
          ],
        ),
        pw.TableRow(
          children: [
            _cell(report.iva22.toString()),
            _cell(report.iva10.toString()),
            _cell(report.iva5.toString()),
            _cell(report.iva4.toString()),
            _cell(report.iva0.toString()),
          ],
        ),
        _buildTotalRow("Imponibile", report.imponibile22, report.imponibile10, report.imponibile5, report.imponibile4, report.imponibile0),
        _buildTotalRow("IVA", report.iva22, report.iva10, report.iva5, report.iva4, report.iva0),
        _buildTotalRow("Totale", report.totale22, report.totale10, report.totale5, report.totale4, report.totale0),
        _buildTotalRow("Numero Scontrini", report.numeroScontrini22, report.numeroScontrini10, report.numeroScontrini5, report.numeroScontrini4, report.numeroScontrini0),
      ],
    );
  }

  static pw.TableRow _buildTotalRow(String label, num v22, num v10, num v5, num v4, num v0) {
    return pw.TableRow(
      children: [
        _cell(label, isBold: true),
        _cell(v22.toString()),
        _cell(v10.toString()),
        _cell(v5.toString()),
        _cell(v4.toString()),
        _cell(v0.toString()),
      ],
    );
  }

  static pw.Widget _cell(String text, {bool isBold = false}) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 12, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
      ),
    );
  }
}
