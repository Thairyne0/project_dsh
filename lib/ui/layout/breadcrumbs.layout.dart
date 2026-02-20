import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:project_dsh/ui/cl_theme.dart';
import 'package:project_dsh/utils/go_router_modular/breadcrumb.system.dart';
import 'constants/sizes.constant.dart';

class BreadcrumbsLayout extends StatelessWidget {
  const BreadcrumbsLayout({super.key});

  // RegExp compilata una sola volta (evita ricompilazione ad ogni build)
  static final RegExp _uuidRegExp = RegExp(
    r'^[0-9a-fA-F]{8}-?[0-9a-fA-F]{4}-?[0-9a-fA-F]{4}-?[0-9a-fA-F]{4}-?[0-9a-fA-F]{12}$',
  );
  static final RegExp _containsDigitRegExp = RegExp(r'[0-9]');

  @override
  Widget build(BuildContext context) {
    // Metodo URL-based: funziona su web, desktop e mobile
    final String fullPath = GoRouterState.of(context).uri.path;
    final List<String> segments = fullPath.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) return const SizedBox.shrink();

    // Costruisci le entries dai segmenti URL
    List<_BreadcrumbEntry> entries = _buildEntries(segments);

    if (entries.isEmpty) return const SizedBox.shrink();

    // Troncamento: se ci sono troppi breadcrumbs (>4), mostra primo, "...", e ultimi 2
    if (entries.length > 4) {
      final first = entries.first;
      final lastTwo = entries.sublist(entries.length - 2);
      entries = [first, _BreadcrumbEntry(label: '...', path: '', isModule: true), ...lastTwo];
    }

    // Costruisci i widget BreadCrumbItem
    final List<BreadCrumbItem> items = _buildItems(context, entries);

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

  /// Costruisce la lista di entries dai segmenti URL
  List<_BreadcrumbEntry> _buildEntries(List<String> segments) {
    final List<_BreadcrumbEntry> entries = [];
    String currentPath = '';

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      currentPath += '/$segment';

      // Salta segmenti che sono ID (UUID, numeri, hash lunghi)
      if (_isIdSegment(segment, currentPath)) continue;

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

    return entries;
  }

  /// Costruisce i widget BreadCrumbItem dalla lista di entries
  List<BreadCrumbItem> _buildItems(BuildContext context, List<_BreadcrumbEntry> entries) {
    final List<BreadCrumbItem> items = [];

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final bool isLast = i == entries.length - 1;

      Widget content;
      if (isLast) {
        // Ultimo elemento: colore primario, semi-bold, non cliccabile
        content = Text(
          entry.label,
          style: CLTheme.of(context).bodyText.merge(TextStyle(
            color: CLTheme.of(context).primary,
            fontWeight: FontWeight.w600,
          )),
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

    return items;
  }

  /// Determina se un segmento URL è un ID (UUID, numero, hash lungo)
  /// Usa il [currentPath] per verificare se il segmento è registrato nel BreadcrumbRegistry
  bool _isIdSegment(String segment, String currentPath) {
    // Numeri puri
    if (int.tryParse(segment) != null) return true;
    // Stringhe molto lunghe (probabilmente UUID o hash)
    if (segment.length > 20) return true;
    // Pattern UUID (con o senza trattini)
    if (_uuidRegExp.hasMatch(segment)) return true;
    // Segmento NON registrato nel registry E contiene numeri → probabilmente un ID
    // (es. "ab12cd", "item3", "ref-45a")
    if (BreadcrumbRegistry().lookup(currentPath) == null &&
        BreadcrumbRegistry().lookupModule(currentPath) == null &&
        _containsDigitRegExp.hasMatch(segment)) return true;
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
