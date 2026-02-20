import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:project_dsh/ui/cl_theme.dart';
import 'package:project_dsh/utils/go_router_modular/breadcrumb.system.dart';
import 'constants/sizes.constant.dart';

class BreadcrumbsLayout extends StatelessWidget {
  const BreadcrumbsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Metodo URL-based: funziona su web, desktop e mobile
    final String fullPath = GoRouterState.of(context).uri.path;
    final List<String> segments = fullPath.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) return const SizedBox.shrink();

    // Filtra gli ID (UUID, numeri, stringhe lunghe) e costruisci i breadcrumbs
    List<_BreadcrumbEntry> entries = [];
    String currentPath = '';

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      currentPath += '/$segment';

      // Salta segmenti che sono ID (UUID, numeri, hash lunghi)
      if (_isIdSegment(segment)) continue;

      // Se questo path ha un modulo genitore registrato (es. "Gestione News"),
      // aggiungilo come primo breadcrumb non cliccabile
      final moduleLabel = BreadcrumbRegistry().lookupModule(currentPath);
      if (moduleLabel != null) {
        // Evita duplicati: aggiungi solo se non è già presente
        final alreadyAdded = entries.any((e) => e.label == moduleLabel && e.path == currentPath);
        if (!alreadyAdded) {
          entries.add(_BreadcrumbEntry(label: moduleLabel, path: currentPath, isModule: true));
        }
      }

      // Cerca il nome italiano della pagina nel BreadcrumbRegistry, fallback a formattazione pulita
      String label = BreadcrumbRegistry().lookup(currentPath) ?? _humanize(segment);

      // Se il nome della pagina è uguale al nome del modulo, non duplicare
      if (moduleLabel != null && label == moduleLabel) continue;

      entries.add(_BreadcrumbEntry(label: label, path: currentPath));
    }

    if (entries.isEmpty) return const SizedBox.shrink();

    List<BreadCrumbItem> items = [];

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final bool isLast = i == entries.length - 1;

      Widget content;
      if (isLast) {
        // Ultimo elemento: colore primario, non cliccabile
        content = Text(
          entry.label,
          style: CLTheme.of(context).bodyText.merge(TextStyle(color: CLTheme.of(context).primary)),
        );
      } else {
        // Elementi precedenti: grigio
        content = Text(
          entry.label,
          style: CLTheme.of(context).bodyLabel.copyWith(color: CLTheme.of(context).secondaryText),
        );
      }

      // I moduli non sono cliccabili, le pagine intermedie sì
      items.add(BreadCrumbItem(
        content: content,
        onTap: isLast || entry.isModule ? null : () => context.go(entry.path),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BreadCrumb(
          items: items,
          divider: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              size: Sizes.small,
              color: CLTheme.of(context).secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  /// Determina se un segmento URL è un ID (UUID, numero, hash lungo)
  bool _isIdSegment(String segment) {
    // Numeri puri
    if (int.tryParse(segment) != null) return true;
    // Stringhe molto lunghe (probabilmente UUID o hash)
    if (segment.length > 20) return true;
    // Pattern UUID (con o senza trattini)
    if (RegExp(r'^[0-9a-fA-F]{8}-?[0-9a-fA-F]{4}-?[0-9a-fA-F]{4}-?[0-9a-fA-F]{4}-?[0-9a-fA-F]{12}$').hasMatch(segment)) return true;
    return false;
  }

  /// Converte un segmento URL in un nome leggibile (fallback se non trovato nel registry)
  /// Es: "details-promo" -> "Details Promo"
  String _humanize(String segment) {
    return segment
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }
}

class _BreadcrumbEntry {
  final String label;
  final String path;
  final bool isModule;
  _BreadcrumbEntry({required this.label, required this.path, this.isModule = false});
}
