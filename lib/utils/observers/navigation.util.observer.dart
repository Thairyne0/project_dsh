import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_dsh/utils/models/breadcrumb_item.model.dart';
import 'package:project_dsh/utils/providers/navigation.util.provider.dart';

class GoRouterBreadcrumbObserver extends NavigatorObserver {
  void _addBreadcrumb(Route<dynamic> route) {
    if (route is PageRoute) {
      final ctx = navigator?.context;
      if (ctx == null) return;
      final nav = Provider.of<NavigationState>(ctx, listen: false);

      final args = route.settings.arguments as Map<String, dynamic>?;

      // routeName (fallback a settings.name)
      final name = args?['routeName'] as String? ?? route.settings.name;
      if (name == null) return;

      // Flags e informazioni sulla gerarchia
      final isModule = args?['isModule'] as bool? ?? false;
      final isMenuRoute = args?['isMenuRoute'] as bool? ?? false;
      final isSubmodule = args?['isSubmodule'] as bool? ?? false; // Flag per distinguere sottomoduli da pagine figlie
      final parentModuleName = args?['parentModuleName'] as String?;
      final parentModulePath = args?['parentModulePath'] as String?;
      final parentMenuName = args?['parentMenuName'] as String?;
      final parentMenuPath = args?['parentMenuPath'] as String?;

      String path = args?['routePath'] as String? ?? '';

      print('[BreadcrumbObserver] === NEW ROUTE ===');
      print('[BreadcrumbObserver] name=$name, path=$path, isModule=$isModule, isMenuRoute=$isMenuRoute, isSubmodule=$isSubmodule');
      print('[BreadcrumbObserver] parentModule=$parentModuleName($parentModulePath), parentMenu=$parentMenuName($parentMenuPath)');

      // Ignora le route intermedie (moduli senza pagina)
      if (path.isEmpty && name.startsWith('/')) {
        print('[BreadcrumbObserver] Ignorata route intermedia: $name');
        return;
      }

      // Estrai il modulo root dal path
      String? moduleRoot;
      if (path.isNotEmpty) {
        final pathSegments = path.split('/').where((s) => s.isNotEmpty).toList();
        if (pathSegments.isNotEmpty) {
          moduleRoot = '/${pathSegments[0]}';
        }
      }

      // Ottieni il modulo corrente dai breadcrumbs esistenti
      final currentModule = nav.currentModulePath;

      // Se il modulo root cambia, resetta completamente
      if (currentModule != null && moduleRoot != null && currentModule != moduleRoot) {
        print('[BreadcrumbObserver] Cambio modulo root: $currentModule → $moduleRoot, RESET breadcrumbs');
        nav.resetToRoot();
      }

      // RICOSTRUISCI il percorso gerarchico corretto
      // Logica:
      // - Per i sottomoduli (rami paralleli): resetta e mostra solo il sottomodulo
      // - Per le pagine del modulo principale: mostra "Nome Modulo > Pagina"

      if (isSubmodule) {
        // Sottomodulo (ramo parallelo) → RESET e mostra Gestione Store > Sottomodulo
        print('[BreadcrumbObserver] Sottomodulo rilevato, RESET breadcrumbs (ramo parallelo)');
        nav.resetToRoot();

        // 1. Aggiungi sempre il parent module come primo breadcrumb (es: "Gestione Store")
        if (parentModuleName != null && parentModulePath != null) {
          print('[BreadcrumbObserver] Aggiungo parent module per sottomodulo: $parentModuleName');
          nav.addBreadcrumb(
            BreadcrumbItem(
              name: parentModuleName,
              path: parentModulePath,
              isModule: true,
              isClickable: false,
            ),
          );
        }

        // 2. Aggiungi la pagina corrente del sottomodulo
        print('[BreadcrumbObserver] Aggiungo pagina corrente sottomodulo: $name');
        final item = BreadcrumbItem(
          name: name,
          path: path,
          isModule: false,
          isClickable: false,
        );
        nav.addBreadcrumb(item);
      } else {
        // Pagina del modulo principale → mostra gerarchia

        // 1. Se c'è un parent module, aggiungilo SEMPRE come PRIMO breadcrumb
        // (anche se esiste già, perché addBreadcrumb gestisce i duplicati con troncatura)
        if (parentModuleName != null && parentModulePath != null) {
          print('[BreadcrumbObserver] Aggiungo parent module come primo breadcrumb: $parentModuleName');
          nav.addBreadcrumb(
            BreadcrumbItem(
              name: parentModuleName,
              path: parentModulePath,
              isModule: true,
              isClickable: false,
            ),
          );
        }

        // 2. Se c'è un parent menu (pagina padre con figli), aggiungilo
        if (parentMenuName != null && parentMenuPath != null) {
          print('[BreadcrumbObserver] Aggiungo parent menu: $parentMenuName');
          nav.addBreadcrumb(
            BreadcrumbItem(
              name: parentMenuName,
              path: parentMenuPath,
              isModule: false,
              isClickable: true,
            ),
          );
        }

        // 3. Aggiungi la pagina corrente
        print('[BreadcrumbObserver] Aggiungo pagina corrente: $name');
        final item = BreadcrumbItem(
          name: name,
          path: path,
          isModule: false,
          isClickable: false,
        );
        nav.addBreadcrumb(item);
      }

      // Log finale dopo che i breadcrumbs sono stati aggiornati
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('[BreadcrumbObserver] Breadcrumbs finali (AGGIORNATI): ${nav.breadcrumbs.map((b) => "${b.name}[${b.path}]").join(" > ")}');
      });
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _addBreadcrumb(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute != null) _addBreadcrumb(newRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    final ctx = navigator?.context;
    if (ctx == null) return;
    final nav = Provider.of<NavigationState>(ctx, listen: false);

    // recupera l'argomento isModule della route su cui siamo atterrati
    final prevArgs = previousRoute?.settings.arguments as Map<String, dynamic>?;
    String path = prevArgs?['routePath'] as String? ?? '';
    nav.removeUntil(path);
  }
}
