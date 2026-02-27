import 'package:project_dsh/ui/widgets/customexpansiontile.widget.dart';
import 'package:project_dsh/ui/widgets/logo.widget.dart';
import 'package:project_dsh/utils/extension.util.dart';
import 'package:project_dsh/utils/providers/service_state.util.provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'constants/sizes.constant.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';
import '../../utils/go_router_modular/routes/module_route.dart';
import '../../utils/go_router_modular/routes/shell_modular_route.dart';
import 'package:project_dsh/utils/providers/navigation.util.provider.dart';
import '../../utils/constants/strings.constant.dart';
import '../../modules/service_selector/constants/service_selector_routes.constants.dart';
import '../cl_theme.dart';

const double _kMenuHPad = 10.0;

class MenuLayout extends StatefulWidget {
  final List<ModularRoute> routes;
  final String? logoImagePath;
  final String? logoImagePathMini;

  const MenuLayout({super.key, required this.routes, this.logoImagePath, this.logoImagePathMini});

  @override
  createState() => _MenuLayoutState();
}

class _MenuLayoutState extends State<MenuLayout> {
  @override
  Widget build(BuildContext context) {
    final navigationState = context.watch<NavigationState>();
    final theme = CLTheme.of(context);

    return RepaintBoundary(
      child: Container(
      width: 260,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border(right: BorderSide(color: theme.borderColor, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo / Branding ──────────────────────────────────────────
          Container(
            height: Sizes.headerOffset / 2,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.padding),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.borderColor, width: 1)),
            ),
            child: widget.logoImagePath != null
                ? Center(
                    child: LogoWidget(
                      logoImagePath: widget.logoImagePath,
                      height: 32,
                      dark: theme == CLTheme.dark,
                    ),
                  )
                : Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: theme.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.dashboard_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          Strings.appName,
                          style: theme.bodyText.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            letterSpacing: -0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
          ),

          // ── Voci di menu ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var route in widget.routes)
                    if (route is ChildRoute && route.isVisible)
                      _buildChildRoute(navigationState, route, 0)
                    else if (route is ModuleRoute && route.isVisible)
                      if (route.module.routes.where((r) => (r is ChildRoute && r.isVisible)).isNotEmpty)
                        if (route.module.routes
                                .where((r) => ((r is ChildRoute && r.isVisible || r is ModuleRoute && r.isVisible)))
                                .length ==
                            1)
                          _buildChildRoute(
                            navigationState,
                            (route.module.routes.where((r) => (r is ChildRoute && r.isVisible)).first as ChildRoute)
                              ..icon = route.icon
                              ..hugeIcon = route.hugeIcon
                              ..path = route.module.moduleRoute.path,
                            0,
                          )
                        else
                          _buildGroupRoute(navigationState, route)
                      else
                        _buildGroupRoute(navigationState, route)
                    else if (route is ShellModularRoute)
                      for (var subRoute in route.routes)
                        if (subRoute is ChildRoute && subRoute.isVisible)
                          _buildChildRoute(navigationState, subRoute, 0)
                        else if (subRoute is ModuleRoute && subRoute.isVisible)
                          if (subRoute.module.routes.where((r) => (r is ChildRoute && r.isVisible)).isNotEmpty)
                            if (subRoute.module.routes
                                    .where((r) => ((r is ChildRoute && r.isVisible || r is ModuleRoute && r.isVisible)))
                                    .length ==
                                1)
                              _buildChildRoute(
                                navigationState,
                                (subRoute.module.routes.where((r) => (r is ChildRoute && r.isVisible)).first as ChildRoute)
                                  ..icon = subRoute.icon
                                  ..hugeIcon = subRoute.hugeIcon
                                  ..path = subRoute.module.moduleRoute.path,
                                0,
                              )
                            else
                              _buildGroupRoute(navigationState, subRoute)
                          else
                            _buildGroupRoute(navigationState, subRoute),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── Footer ────────────────────────────────────────────────────
          Divider(height: 0, thickness: 1, color: theme.borderColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _kMenuHPad, vertical: 8),
            child: _MenuItemTile(
              selected: false,
              theme: theme,
              label: 'Cambia Servizio',
              icon: Icon(Icons.swap_horiz_rounded, size: 18, color: theme.secondaryText),
              onTap: () {
                if (!ResponsiveBreakpoints.of(context).isDesktop) {
                  Scaffold.of(context).closeDrawer();
                }
                ServiceState().clear();
                context.customGoNamed(ServiceSelectorRoutes.selector.name);
              },
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildChildRoute(NavigationState navigationState, ChildRoute route, double padding) {
    final selected = _isSelected(navigationState, route.path);
    final theme = CLTheme.of(context);
    return _MenuItemTile(
      selected: selected,
      theme: theme,
      label: route.name,
      icon: route.hasIcon ? route.buildIcon(size: 18, color: selected ? theme.primary : theme.secondaryText) : null,
      onTap: () {
        if (!ResponsiveBreakpoints.of(context).isDesktop) Scaffold.of(context).closeDrawer();
        context.customGoNamed(route.name);
      },
    );
  }

  Widget _buildGroupRoute(NavigationState navigationState, ModuleRoute subRoute, {String basePath = ''}) {
    final currentPath = "$basePath${subRoute.path}".replaceAll('//', '/');
    final isSelected = _isSelected(navigationState, currentPath, isParentRoute: true);
    final isExpandedNotifier = ValueNotifier<bool>(isSelected);
    final theme = CLTheme.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: isExpandedNotifier,
      builder: (context, isExpanded, _) {
        final iconColor = isSelected ? theme.primary : theme.secondaryText;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: _kMenuHPad, vertical: 1),
          child: CLExpansionTile(
            title: subRoute.name,
            isSelected: isSelected,
            onExpansionChanged: (exp) => isExpandedNotifier.value = exp,
            leading: subRoute.buildIcon(size: 18, color: iconColor) ?? Icon(Icons.folder_rounded, size: 18, color: iconColor),
            children: [
              for (var childRoute in subRoute.module.routes)
                if (childRoute is ChildRoute && childRoute.isVisible)
                  _buildSubItem(
                    navigationState,
                    label: childRoute.name,
                    fullPath: "$currentPath${childRoute.path}".replaceAll('//', '/'),
                    onTap: () => context.customGoNamed(childRoute.routeName ?? childRoute.name),
                  )
                else if (childRoute is ModuleRoute && childRoute.isVisible)
                  if (childRoute.module.routes.where((r) => r is ChildRoute && r.isVisible).length == 1)
                    _buildSubItem(
                      navigationState,
                      label: ((childRoute.module.routes.where((r) => r is ChildRoute && r.isVisible).first as ChildRoute)
                            ..path = childRoute.module.moduleRoute.path)
                          .name,
                      fullPath: "$currentPath${childRoute.path}".replaceAll('//', '/'),
                      onTap: () => context.go("$currentPath${childRoute.path}".replaceAll('//', '/')),
                    )
                  else
                    _buildGroupRoute(navigationState, childRoute, basePath: currentPath),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubItem(
    NavigationState navigationState, {
    required String label,
    required String fullPath,
    required VoidCallback onTap,
  }) {
    final active = _getRouteColor(navigationState, fullPath) == CLTheme.of(context).primary;
    final theme = CLTheme.of(context);
    return _SubItemTile(label: label, selected: active, theme: theme, onTap: onTap);
  }

  Color _getRouteColor(NavigationState navigationState, String fullPath, {bool isVerticalDivider = false}) {
    Uri? currentUri = Router.of(context).routeInformationProvider?.value.uri;
    String norm = fullPath.endsWith('/') ? fullPath.substring(0, fullPath.length - 1) : fullPath;
    return currentUri.toString() == norm
        ? CLTheme.of(context).primary
        : isVerticalDivider
            ? CLTheme.of(context).borderColor
            : CLTheme.of(context).primaryText;
  }

  bool _isSelected(NavigationState navigationState, String fullPath, {bool isParentRoute = false}) {
    Uri? currentUri = Router.of(context).routeInformationProvider?.value.uri;
    String norm = fullPath.endsWith('/') ? fullPath.substring(0, fullPath.length - 1) : fullPath;
    String current = currentUri.toString();
    if (isParentRoute) {
      return current == norm ||
          (current.startsWith(norm) && current.length > norm.length && current[norm.length] == '/');
    }
    return current == norm;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Voce principale con hover animato
// ─────────────────────────────────────────────────────────────────────────────
class _MenuItemTile extends StatefulWidget {
  final bool selected;
  final CLTheme theme;
  final VoidCallback onTap;
  final Widget? icon;
  final String label;

  const _MenuItemTile({
    required this.selected,
    required this.theme,
    required this.onTap,
    required this.label,
    this.icon,
  });

  @override
  State<_MenuItemTile> createState() => _MenuItemTileState();
}

class _MenuItemTileState extends State<_MenuItemTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final active = widget.selected;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kMenuHPad, vertical: 1),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: active
                  ? t.primary.withValues(alpha: 0.08)
                  : _hovered
                      ? t.alternate.withValues(alpha: 0.7)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                children: [
                  SizedBox(width: 20, height: 20, child: widget.icon ?? const SizedBox.shrink()),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: t.bodyText.copyWith(
                        fontSize: 13.5,
                        color: active ? t.primary : t.primaryText,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (active)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: t.primary, shape: BoxShape.circle),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Voce figlia con hover animato
// ─────────────────────────────────────────────────────────────────────────────
class _SubItemTile extends StatefulWidget {
  final bool selected;
  final CLTheme theme;
  final VoidCallback onTap;
  final String label;

  const _SubItemTile({
    required this.selected,
    required this.theme,
    required this.onTap,
    required this.label,
  });

  @override
  State<_SubItemTile> createState() => _SubItemTileState();
}

class _SubItemTileState extends State<_SubItemTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final active = widget.selected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: active
                ? t.primary.withValues(alpha: 0.08)
                : _hovered
                    ? t.alternate.withValues(alpha: 0.7)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: active ? 3 : 2,
                  height: 14,
                  decoration: BoxDecoration(
                    color: active ? t.primary : t.borderColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.label,
                    style: t.bodyText.copyWith(
                      fontSize: 13,
                      color: active ? t.primary : t.primaryText,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
