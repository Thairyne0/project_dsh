import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:project_dsh/utils/models/pageaction.model.dart';
import '../models/breadcrumb_item.model.dart';

class NavigationState extends ChangeNotifier {
  final List<BreadcrumbItem> breadcrumbs = [];

  String pageName = "";
  String? initialRoute;
  String? currentModulePath; // Traccia il modulo corrente per rilevare i cambi di contesto

  void setPageActions(List<PageAction> pageActionsArray) {
    breadcrumbs.last.pageActions = pageActionsArray;
    notifyListeners();
  }

  /// Pulisce tutti i breadcrumbs
  void _clearAll() {
    breadcrumbs.clear();
  }

  /// Reset pubblico che pulisce tutto
  void resetToRoot() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearAll();
      currentModulePath = null;
      notifyListeners();
    });
  }

  void addBreadcrumb(BreadcrumbItem item, {String? parentModuleName, String? parentModulePath, bool isNestedInMenu = false}) {
    // Usa addPostFrameCallback per evitare "setState during build"
    SchedulerBinding.instance.addPostFrameCallback((_) {
      pageName = item.name;

      print('[NavigationState.addBreadcrumb] === START === item="${item.name}", path="${item.path}"');
      print('[NavigationState.addBreadcrumb] Current breadcrumbs BEFORE: ${breadcrumbs.map((b) => "${b.name}[${b.path}]").join(" > ")}');

      // Estrai il modulo root dal path corrente (primo segmento)
      String? newModuleRoot;
      if (item.path.isNotEmpty) {
        final pathSegments = item.path.split('/').where((s) => s.isNotEmpty).toList();
        if (pathSegments.isNotEmpty) {
          newModuleRoot = '/${pathSegments[0]}';
        }
      }

      // NUOVA LOGICA: resetta completamente quando cambia il modulo root
      if (breadcrumbs.isNotEmpty && newModuleRoot != null && currentModulePath != null) {
        if (newModuleRoot != currentModulePath) {
          print('[NavigationState.addBreadcrumb] Cambio modulo root rilevato: $currentModulePath → $newModuleRoot. RESET COMPLETO.');
          _clearAll();
          currentModulePath = newModuleRoot;
        }
      } else if (newModuleRoot != null && currentModulePath == null) {
        currentModulePath = newModuleRoot;
      }

      // Cerca se questo breadcrumb esiste già (stesso path E stesso nome)
      final idx = breadcrumbs.indexWhere((b) => b.path == item.path && b.name == item.name);

      if (idx != -1) {
        // Breadcrumb già presente
        print('[NavigationState.addBreadcrumb] Item già presente a idx=$idx');

        // Se è già l'ultimo breadcrumb, non fare nulla (è la pagina corrente)
        if (idx == breadcrumbs.length - 1) {
          print('[NavigationState.addBreadcrumb] È già l\'ultimo breadcrumb, non faccio nulla');
          notifyListeners();
          return;
        }

        // Altrimenti, tronca tutto dopo di esso (navigazione all'indietro)
        print('[NavigationState.addBreadcrumb] Tronco da ${idx + 1} a ${breadcrumbs.length}');
        if (idx + 1 < breadcrumbs.length) {
          breadcrumbs.removeRange(idx + 1, breadcrumbs.length);
        }
        print('[NavigationState.addBreadcrumb] Breadcrumbs AFTER truncate: ${breadcrumbs.map((b) => "${b.name}[${b.path}]").join(" > ")}');

        // Se è un modulo, NON fare return perché vogliamo che l'observer continui ad aggiungere le pagine successive
        // Se è una pagina, fai return perché siamo tornati indietro a quella pagina
        if (!item.isModule) {
          notifyListeners();
          return;
        }
        // Per i moduli, continua e notifica alla fine
      }

      // Aggiungi il nuovo breadcrumb
      final clickableItem = BreadcrumbItem(
        name: item.name,
        path: item.path,
        isModule: item.isModule,
        isClickable: !item.isModule,
      );

      breadcrumbs.add(clickableItem);
      print('[NavigationState.addBreadcrumb] Breadcrumb AGGIUNTO. AFTER: ${breadcrumbs.map((b) => "${b.name}[${b.path}]").join(" > ")}');
      notifyListeners();
    });
  }

  void removeLastBreadcrumb() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // rimuovi solo se rimane almeno il root
      if (breadcrumbs.length > 1) {
        breadcrumbs.removeLast();
        pageName = breadcrumbs.last.name;
        notifyListeners();
      }
    });
  }

  /// Rimuove il modulo corrente (e le sue pagine figlie)
  void popModule() {
    if (breadcrumbs.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lastModIdx = breadcrumbs.lastIndexWhere((b) => b.isModule);

      if (lastModIdx >= 0) {
        // rimuove dal modulo stesso in poi
        breadcrumbs.removeRange(lastModIdx, breadcrumbs.length);
        if (breadcrumbs.isNotEmpty) {
          pageName = breadcrumbs.last.name;
        }
      }
      notifyListeners();
    });
  }

  /// Svuota tutti i breadcrumb tranne il root
  void clearBreadcrumbs() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      breadcrumbs.clear();
      currentModulePath = null; // Reset anche del modulo corrente
      notifyListeners();
    });
  }

  /// Tronca tutto ciò che segue targetPath, ma non tocca mai il root
  void removeUntil(String targetPath) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cerca l'ultimo breadcrumb con questo path (potrebbe esserci modulo + pagina con stesso path)
      final idx = breadcrumbs.lastIndexWhere((b) => b.path == targetPath);
      if (idx != -1 && idx < breadcrumbs.length - 1) {
        // se idx è 0, rimuove comunque solo da 1 in poi, preservando root
        breadcrumbs.removeRange(idx + 1, breadcrumbs.length);
        pageName = breadcrumbs.last.name;

        notifyListeners();
      }
    });
  }
}
