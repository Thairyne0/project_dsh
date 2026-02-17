import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_dsh/utils/models/breadcrumb_item.model.dart';
import 'package:project_dsh/utils/providers/navigation.util.provider.dart';
import 'package:project_dsh/utils/providers/tabs.util.provider.dart';

class GoRouterBreadcrumbObserver extends NavigatorObserver {

  /// Apre automaticamente un tab per la route corrente
  void _openTabForRoute(BuildContext ctx, {required String name, required String path, required bool isModule}) {
    print('[TabObserver] _openTabForRoute chiamato con name: $name, path: $path, isModule: $isModule');

    // Non aprire tab per route senza path valido
    if (path.isEmpty) {
      print('[TabObserver] Path vuoto, skip creazione tab');
      return;
    }

    // Usa addPostFrameCallback per evitare setState durante il build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final tabsState = Provider.of<TabsState>(ctx, listen: false);

        // Determina l'icona in base al tipo di pagina
        IconData? icon = _getIconForRoute(path, name);

        // Determina se il tab può essere chiuso (Dashboard no, altri sì)
        bool canClose = path != '/dashboard';

        // Apri o attiva il tab
        tabsState.openTab(
          path: path,
          title: name,
          icon: icon,
          canClose: canClose,
        );

        print('[TabObserver] Tab aperto/attivato: $name ($path)');
      } catch (e) {
        print('[TabObserver] Errore nell\'apertura del tab: $e');
      }
    });
  }

  /// Restituisce l'icona appropriata per una route
  IconData? _getIconForRoute(String path, String name) {
    if (path.startsWith('/dashboard')) return Icons.dashboard;
    if (path.startsWith('/news')) return Icons.newspaper;
    if (path.startsWith('/events')) return Icons.event;
    if (path.startsWith('/stores')) return Icons.store;
    if (path.startsWith('/profile')) return Icons.person;
    if (path.startsWith('/event-categories')) return Icons.category;
    if (path.startsWith('/users')) return Icons.people;
    return Icons.description; // Icona default
  }

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
      final isMenuRoute = args?['isMenuRoute'] as bool? ?? false; // Ha figli, è una voce di menu
      final isNestedInMenu = args?['isNestedInMenu'] as bool? ?? false; // È una route figlia di una voce di menu
      final parentModuleName = args?['parentModuleName'] as String?;
      final parentModulePath = args?['parentModulePath'] as String?;
      final parentMenuName = args?['parentMenuName'] as String?; // Nome della voce di menu parent
      final parentMenuPath = args?['parentMenuPath'] as String?; // Path della voce di menu parent

      String path = args?['routePath'] as String? ?? '';

      // Log per debug
      print('[BreadcrumbObserver] name=$name, isModule=$isModule, isMenuRoute=$isMenuRoute, isNestedInMenu=$isNestedInMenu, parentModule=$parentModuleName, parentMenu=$parentMenuName, parentMenuPath=$parentMenuPath');

      // Ignora le route intermedie (moduli senza pagina) che hanno path vuoto e nome che inizia con /
      if (path.isEmpty && name.startsWith('/')) {
        print('[BreadcrumbObserver] Ignorata route intermedia: $name');
        return;
      }

      // === GESTIONE TAB STILE IDE ===
      // Apri automaticamente un tab per questa pagina
      _openTabForRoute(ctx, name: name, path: path, isModule: isModule);

      // Se questa è una voce di menu (isMenuRoute=true), aggiungi solo il breadcrumb con il parent module info
      if (isMenuRoute) {
        print('[BreadcrumbObserver] Entrato nel blocco isMenuRoute');
        // Voce di menu con figli - aggiungi come breadcrumb normale con parent module info
        final item = BreadcrumbItem(
          name: name,
          path: path,
          isModule: false,
          isClickable: false, // È la pagina corrente (voce di menu)
        );
        nav.addBreadcrumb(item, parentModuleName: parentModuleName, parentModulePath: parentModulePath, isNestedInMenu: isNestedInMenu);
      } else if (parentMenuName != null) {
        print('[BreadcrumbObserver] Entrato nel blocco parentMenuName != null');
        // Pagina dettaglio con parent menu - costruisci gerarchia completa
        print('[BreadcrumbObserver] Gestisco parentMenuName: $parentMenuName, current breadcrumbs: ${nav.breadcrumbs.map((b) => "${b.name}(${b.isModule ? "M" : "P"})").join(" > ")}');

        // PRIMA cerca se il menu esiste già (prima di rimuovere qualsiasi cosa!)
        final menuIdx = nav.breadcrumbs.indexWhere((b) => b.name == parentMenuName && !b.isModule);
        print('[BreadcrumbObserver] Cerco menu $parentMenuName PRIMA di rimuovere, trovato a indice: $menuIdx, parentMenuPath=$parentMenuPath');

        // Prima assicurati che il modulo ci sia (se non c'è già)
        if (parentModuleName != null) {
          final moduleIdx = nav.breadcrumbs.indexWhere((b) => b.name == parentModuleName && b.isModule);
          print('[BreadcrumbObserver] Cerco modulo $parentModuleName, trovato a indice: $moduleIdx');

          if (moduleIdx == -1) {
            // Aggiungi il modulo usando addBreadcrumb
            print('[BreadcrumbObserver] Aggiungo modulo $parentModuleName');
            nav.addBreadcrumb(
              BreadcrumbItem(
                name: parentModuleName,
                path: parentModulePath ?? '',
                isModule: true,
                isClickable: false,
              ),
              parentModuleName: null,
              parentModulePath: null,
            );
          } else {
            // Il modulo esiste già
            // Se il menu esiste già, rimuovi solo dopo il menu
            // Altrimenti, rimuovi tutto dopo il modulo
            if (menuIdx != -1 && menuIdx > moduleIdx) {
              print('[BreadcrumbObserver] Menu esiste a indice $menuIdx, rimuovo tutto dopo di esso');
              if (menuIdx < nav.breadcrumbs.length - 1) {
                nav.breadcrumbs.removeRange(menuIdx + 1, nav.breadcrumbs.length);
              }
            } else {
              print('[BreadcrumbObserver] Menu non esiste o è prima del modulo, rimuovo tutto dopo modulo indice $moduleIdx');
              if (moduleIdx < nav.breadcrumbs.length - 1) {
                nav.breadcrumbs.removeRange(moduleIdx + 1, nav.breadcrumbs.length);
              }
            }
          }
        }

        // Avvolgi le modifiche in un postFrameCallback per evitare setState durante il build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Ri-cerca il menu dopo le modifiche
          final currentMenuIdx = nav.breadcrumbs.indexWhere((b) => b.name == parentMenuName && !b.isModule);

          if (currentMenuIdx == -1) {
            // Aggiungi direttamente alla lista senza passare per addBreadcrumb
            print('[BreadcrumbObserver] Aggiungo menu $parentMenuName direttamente con path: $parentMenuPath');
            nav.breadcrumbs.add(BreadcrumbItem(
              name: parentMenuName,
              path: parentMenuPath ?? '', // Usa parentMenuPath se disponibile
              isModule: false,
              isClickable: parentMenuPath != null && parentMenuPath.isNotEmpty,
            ));
          } else {
            print('[BreadcrumbObserver] Menu $parentMenuName già presente a indice $currentMenuIdx, non aggiungo');
          }

          // Infine aggiungi la pagina corrente direttamente
          print('[BreadcrumbObserver] Aggiungo pagina corrente $name');
          nav.breadcrumbs.add(BreadcrumbItem(
            name: name,
            path: path,
            isModule: false,
            isClickable: false, // È la pagina corrente
          ));

          print('[BreadcrumbObserver] Breadcrumbs finali: ${nav.breadcrumbs.map((b) => "${b.name}(${b.isModule ? "M" : "P"})").join(" > ")}');

          nav.pageName = name;
          nav.notifyListeners();
        });
      } else {
        print('[BreadcrumbObserver] Entrato nel blocco else (pagina normale)');
        // Pagina normale senza parent menu - usa il sistema standard
        final item = BreadcrumbItem(
          name: name,
          path: path,
          isModule: isModule,
          isClickable: false,
        );
        nav.addBreadcrumb(item, parentModuleName: parentModuleName, parentModulePath: parentModulePath, isNestedInMenu: isNestedInMenu);
      }
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
