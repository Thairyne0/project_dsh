import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'i_modular_route.dart';

/// Route per creare una shell con tab navigation e stato preservato
/// Ogni branch (tab) mantiene il proprio stato quando si naviga tra i tab
class StatefulShellModularRoute extends ModularRoute {
  final FutureOr<String?> Function(BuildContext context, GoRouterState state)? redirect;
  final Widget Function(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) builder;
  final List<ModularRoute> routes;
  final GlobalKey<NavigatorState>? parentNavigatorKey;
  final String? restorationScopeId;

  StatefulShellModularRoute({
    this.redirect,
    this.parentNavigatorKey,
    this.restorationScopeId,
    required this.builder,
    required this.routes,
  });
}

