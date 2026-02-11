// lib/extensions/download_extension_web.dart

import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../ui/widgets/alertmanager/alert_manager.dart';

extension DownloadExtension on BuildContext {
  Future<void> downloadFile(String url) async {
    Uri uri = Uri.parse(url);
    String fileName;

    final request = html.HttpRequest();

    request
      ..open('GET', url)
      ..responseType = 'blob';

    BehaviorSubject<double> downloadPercentage = BehaviorSubject<double>.seeded(0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AlertManager.showDownloadPercentage("Download", "Download in corso", downloadPercentage);
    });

    request.onProgress.listen((event) {
      if (event.lengthComputable && event.loaded != null && event.total != null) {
        double progress = (event.loaded! / event.total!) * 100;
        downloadPercentage.add(progress);
      } else {
        print('Impossibile calcolare il progresso del download.');
      }
    });

    request.onLoadEnd.listen((event) {
      if (request.status == 200) {
        // Ottieni il nome del file dall'header 'Content-Disposition' o dall'URL
        String? contentDisposition = request.getResponseHeader('Content-Disposition');

        if (contentDisposition != null && contentDisposition.contains('filename=')) {
          RegExp regExp = RegExp(
            r'filename[^;=\n]*=((['
            '"]).*?2|[^;\n]*)',
          );
          Match? match = regExp.firstMatch(contentDisposition);
          if (match != null) {
            fileName = match.group(1)!;
            fileName = fileName.replaceAll(RegExp('^["\']|["\']\$'), '');
          } else {
            fileName = 'downloaded_file';
          }
        } else {
          fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'downloaded_file';

          // Rimuovi query parameters dal nome del file
          if (fileName.contains('?')) {
            fileName = fileName.split('?').first;
          }

          fileName = Uri.decodeComponent(fileName);
        }

        // Il download è completato
        final blob = request.response;
        final anchor =
            html.document.createElement('a') as html.AnchorElement
              ..href = html.Url.createObjectUrlFromBlob(blob)
              ..style.display = 'none'
              ..download = fileName;
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(anchor.href!);
        AlertManager.showSuccess("Perfetto", "Download completato: $fileName");
      } else {
        AlertManager.showDanger("Errore", "Errore durante il download del file: ${request.statusText}");
      }
    });

    request.onError.listen((event) {
      AlertManager.showDanger("Errore", "Errore durante la richiesta HTTP.");
    });

    request.send();
  }
}
