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
    // 1. Ottieni il path corrente (reattivo)
    final String fullPath = GoRouterState.of(context).uri.path;
    final List<String> segments = fullPath.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) return const SizedBox.shrink();

    // 2. Costruisci la lista di items
    List<BreadCrumbItem> items = [];
    String currentPath = '';

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      currentPath += '/$segment';
      final bool isLast = i == segments.length - 1;

      // 3. Risolvi la label usando il Registry o fallback
      String label = BreadcrumbRegistry().lookup(currentPath) ?? _fallbackLabel(segment, segments, i);

      // Costruisci il widget per l'item
      Widget content;
      if (isLast) {
        content = Text(
          label,
          style: CLTheme.of(context).bodyText.merge(TextStyle(color: CLTheme.of(context).primary)),
        );
      } else {
        content = Text(
          label,
          style: CLTheme.of(context).bodyLabel.copyWith(color: CLTheme.of(context).secondaryText),
        );
      }

      items.add(BreadCrumbItem(
        content: content,
        onTap: isLast ? null : () => context.go(currentPath),
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

  String _fallbackLabel(String segment, List<String> segments, int index) {
    if (segment.length > 20 || int.tryParse(segment) != null) {
      return '#$segment'; // ID
    }
    // Capitalize
    return segment.isNotEmpty ? '${segment[0].toUpperCase()}${segment.substring(1)}' : segment;
  }
}
