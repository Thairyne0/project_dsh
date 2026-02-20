import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:project_dsh/ui/cl_theme.dart';
import 'package:project_dsh/utils/providers/navigation.util.provider.dart';
import 'constants/sizes.constant.dart';

class BreadcrumbsLayout extends StatelessWidget {
  const BreadcrumbsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Usa il NavigationState provider che contiene i breadcrumbs con nomi italiani
    final navigationState = Provider.of<NavigationState>(context);
    final breadcrumbs = navigationState.breadcrumbs;

    if (breadcrumbs.isEmpty) return const SizedBox.shrink();

    List<BreadCrumbItem> items = [];

    for (int i = 0; i < breadcrumbs.length; i++) {
      final bc = breadcrumbs[i];
      final bool isLast = i == breadcrumbs.length - 1;

      Widget content;
      if (isLast) {
        // Ultimo elemento: colore primario, non cliccabile
        content = Text(
          bc.name,
          style: CLTheme.of(context).bodyText.merge(TextStyle(color: CLTheme.of(context).primary)),
        );
      } else if (bc.isModule) {
        // Modulo intermedio: grigio, non cliccabile
        content = Text(
          bc.name,
          style: CLTheme.of(context).bodyLabel.copyWith(color: CLTheme.of(context).secondaryText),
        );
      } else {
        // Pagina intermedia: grigio, cliccabile
        content = Text(
          bc.name,
          style: CLTheme.of(context).bodyLabel.copyWith(color: CLTheme.of(context).secondaryText),
        );
      }

      items.add(BreadCrumbItem(
        content: content,
        onTap: isLast || bc.isModule ? null : () => context.go(bc.path),
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
}
