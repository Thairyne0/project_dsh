// lib/extensions/download_extension_io.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path; // Import corretto
import 'package:rxdart/rxdart.dart';
import '../ui/widgets/alertmanager/alert_manager.dart';

extension DownloadExtension on BuildContext {
  Future<void> downloadFile(dynamic fileOrUrl) async {
    // Seleziona la cartella
    BehaviorSubject<double> downloadPercentage = BehaviorSubject<double>.seeded(0);
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (fileOrUrl is String) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AlertManager.showDownloadPercentage("Download", "Download in corso", downloadPercentage);
      });
      if (selectedDirectory != null) {
        // Crea il client e avvia la richiesta
        final client = http.Client();
        final request = http.Request('GET', Uri.parse(fileOrUrl));
        final response = await client.send(request);

        // Verifica che la risposta sia valida
        if (response.statusCode == 200) {
          // Ottieni il nome del file
          Uri uri = Uri.parse(fileOrUrl);
          String fileName = uri.path.split("/").last;
          final file = File('$selectedDirectory/$fileName');

          // Crea lo stream per scrivere i dati sul file
          final fileStream = file.openWrite();

          // Variabili per monitorare il progresso
          int totalBytes = response.contentLength ?? 0;
          int downloadedBytes = 0;
          response.stream.listen(
            (data) {
              downloadedBytes += data.length;
              fileStream.add(data);
              final progress = (downloadedBytes / totalBytes) * 100;
              downloadPercentage.add(progress);
            },
            onDone: () async {
              await fileStream.close();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertManager.showSuccess("Successo", "Download completato: ${file.path}");
              });
            },
            onError: (error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertManager.showDanger("Errore", "Errore nel download: $error");
              });
              fileStream.close();
            },
            cancelOnError: true,
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertManager.showDanger("Errore", "Errore nella richiesta: Status ${response.statusCode}");
          });
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertManager.showWarning("Download Annullato", "Nessuna cartella selezionata", alertPosition: AlertPosition.leftBottomCorner);
        });
      }
    } else {
      if (selectedDirectory != null) {
        // Creiamo il percorso completo di destinazione
        String newFilePath = path.join(selectedDirectory, fileOrUrl.name);
        try {
          // Creiamo un file e copiamo i bytes
          File newFile = File(newFilePath);
          await newFile.writeAsBytes(fileOrUrl.bytes!);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertManager.showSuccess("Successo", "Download completato: $newFilePath");
          });
        } catch (e) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertManager.showDanger("Errore", "Errore nella richiesta: Status $e");
          });
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertManager.showWarning("Salvataggio Annullato", "Nessuna cartella selezionata", alertPosition: AlertPosition.leftBottomCorner);
        });
      }
    }
  }
}
