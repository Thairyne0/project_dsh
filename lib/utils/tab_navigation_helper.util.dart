import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/tabs.util.provider.dart';

/// Extension per navigare e aprire automaticamente i tab
extension TabNavigationExtension on BuildContext {
  /// Naviga a un path e apre un nuovo tab (o attiva uno esistente)
  void goWithTab({
    required String path,
    required String title,
    IconData? icon,
    bool canClose = true,
  }) {
    final tabsState = Provider.of<TabsState>(this, listen: false);

    // Apri o attiva il tab
    tabsState.openTab(
      path: path,
      title: title,
      icon: icon,
      canClose: canClose,
    );

    // Naviga al path
    go(path);
  }

  /// Naviga a un path e apre un nuovo tab, forzando un nuovo tab anche se esiste
  void goWithNewTab({
    required String path,
    required String title,
    IconData? icon,
    bool canClose = true,
  }) {
    final tabsState = Provider.of<TabsState>(this, listen: false);

    // Apri sempre un nuovo tab
    final tab = tabsState.openTab(
      path: path,
      title: title,
      icon: icon,
      canClose: canClose,
      activateIfExists: false,
    );

    // Se il tab esisteva già, chiudilo e ricrealo per avere un nuovo ID
    // Questo forza la creazione di un nuovo tab

    // Naviga al path
    go(path);
  }

  /// Chiude il tab corrente e naviga al precedente
  void closeCurrentTab() {
    final tabsState = Provider.of<TabsState>(this, listen: false);
    final activeTab = tabsState.activeTab;

    if (activeTab != null && activeTab.canClose) {
      tabsState.closeTab(activeTab.id);

      // Naviga al nuovo tab attivo
      final newActiveTab = tabsState.activeTab;
      if (newActiveTab != null) {
        go(newActiveTab.path);
      }
    }
  }

  /// Ottiene il TabsState
  TabsState get tabsState => Provider.of<TabsState>(this, listen: false);
}

/// Classe helper statica per la navigazione con tab
class TabNavigation {
  TabNavigation._();

  /// Naviga a Dashboard e apre/attiva il tab
  static void toDashboard(BuildContext context) {
    context.goWithTab(
      path: '/dashboard',
      title: 'Dashboard',
      icon: Icons.dashboard,
      canClose: false, // Dashboard non può essere chiusa
    );
  }

  /// Naviga alla lista News e apre/attiva il tab
  static void toNews(BuildContext context) {
    context.goWithTab(
      path: '/news',
      title: 'News',
      icon: Icons.newspaper,
    );
  }

  /// Naviga al dettaglio di una news
  static void toNewsDetail(BuildContext context, String newsId, {String? title}) {
    context.goWithTab(
      path: '/news/news-details/$newsId',
      title: title ?? 'News #$newsId',
      icon: Icons.article,
    );
  }

  /// Naviga alla creazione di una nuova news
  static void toCreateNews(BuildContext context) {
    context.goWithTab(
      path: '/news/news-new',
      title: 'Nuova News',
      icon: Icons.add_circle_outline,
    );
  }

  /// Naviga alla lista Eventi
  static void toEvents(BuildContext context) {
    context.goWithTab(
      path: '/events',
      title: 'Eventi',
      icon: Icons.event,
    );
  }

  /// Naviga al dettaglio di un evento
  static void toEventDetail(BuildContext context, String eventId, {String? title}) {
    context.goWithTab(
      path: '/events/event-details/$eventId',
      title: title ?? 'Evento #$eventId',
      icon: Icons.event_note,
    );
  }

  /// Naviga alla creazione di un nuovo evento
  static void toCreateEvent(BuildContext context) {
    context.goWithTab(
      path: '/events/new-event',
      title: 'Nuovo Evento',
      icon: Icons.add_circle_outline,
    );
  }

  /// Naviga alla lista Store
  static void toStores(BuildContext context) {
    context.goWithTab(
      path: '/stores',
      title: 'Store',
      icon: Icons.store,
    );
  }

  /// Naviga al dettaglio di uno store
  static void toStoreDetail(BuildContext context, String storeId, {String? title}) {
    context.goWithTab(
      path: '/stores/details-store/$storeId',
      title: title ?? 'Store #$storeId',
      icon: Icons.storefront,
    );
  }

  /// Naviga al profilo utente
  static void toProfile(BuildContext context) {
    context.goWithTab(
      path: '/profile',
      title: 'Profilo',
      icon: Icons.person,
    );
  }

  /// Naviga alle categorie eventi
  static void toEventCategories(BuildContext context) {
    context.goWithTab(
      path: '/event-categories',
      title: 'Categorie Eventi',
      icon: Icons.category,
    );
  }
}

