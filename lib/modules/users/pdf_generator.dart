import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

import 'models/user.model.dart';

class PdfGenerator {
  Future<void> generatePdf(List<User> users) async {
    final pdf = pw.Document();

    // Carica il logo da assets
    final ByteData bytes = await rootBundle.load('assets/images/logo_light.png');
    final Uint8List logoBytes = bytes.buffer.asUint8List();

    // Aggiungi l'intestazione con il logo e i contatti
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Logo azienda
              pw.Image(
                pw.MemoryImage(logoBytes),
                width: 100,
                height: 100,
              ),
              pw.SizedBox(height: 10),
              // Nome azienda e contatti
              pw.Text(
                'Nome Azienda Srl',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'Indirizzo: Via Esempio 123, 00100 Città',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Telefono: +39 012 3456789',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Email: info@azienda.it',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              // Titolo della tabella
              pw.Text('Lista degli Utenti', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              // Tabella con gli utenti
              pw.Table(
                border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('Nome', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Cognome', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Email', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  // Aggiungi i dati degli utenti
                  for (var user in users)
                    pw.TableRow(
                      children: [
                        pw.Text(user.userData.firstName),
                        pw.Text(user.userData.lastName),
                        pw.Text(user.email),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Salva e stampa il PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      return pdf.save();
    });
  }
}
