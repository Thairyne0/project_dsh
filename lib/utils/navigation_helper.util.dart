import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Helper per la navigazione modulare con supporto per deep linking
/// Fornisce metodi di utilità per navigare tra i moduli in modo type-safe
class ModularNavigation {

  /// Naviga alla home del modulo Dashboard
  static void toDashboard(BuildContext context) {
    context.go('/dashboard');
  }

  /// Naviga alla lista delle news
  static void toNews(BuildContext context) {
    context.go('/news');
  }

  /// Naviga al dettaglio di una news specifica
  static void toNewsDetail(BuildContext context, String newsId) {
    context.go('/news/$newsId');
  }

  /// Naviga alla creazione di una nuova news
  static void toCreateNews(BuildContext context) {
    context.go('/news/create');
  }

  /// Naviga all'editing di una news
  static void toEditNews(BuildContext context, String newsId) {
    context.go('/news/$newsId/edit');
  }

  /// Naviga alla lista degli eventi
  static void toEvents(BuildContext context) {
    context.go('/events');
  }

  /// Naviga al dettaglio di un evento specifico
  static void toEventDetail(BuildContext context, String eventId) {
    context.go('/events/$eventId');
  }

  /// Naviga alla creazione di un nuovo evento
  static void toCreateEvent(BuildContext context) {
    context.go('/events/create');
  }

  /// Naviga all'editing di un evento
  static void toEditEvent(BuildContext context, String eventId) {
    context.go('/events/$eventId/edit');
  }

  /// Naviga al catalogo dello store
  static void toStore(BuildContext context) {
    context.go('/store');
  }

  /// Naviga al dettaglio di un prodotto
  static void toStoreProductDetail(BuildContext context, String productId) {
    context.go('/store/products/$productId');
  }

  /// Naviga alle categorie eventi
  static void toEventCategories(BuildContext context) {
    context.go('/event-categories');
  }

  /// Naviga al profilo utente
  static void toProfile(BuildContext context) {
    context.go('/profile');
  }

  /// Naviga alle impostazioni del profilo
  static void toProfileSettings(BuildContext context) {
    context.go('/profile/settings');
  }

  /// Naviga indietro nella history
  static void back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  /// Controlla se è possibile tornare indietro
  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }

  /// Ottiene il path corrente
  static String getCurrentPath(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  /// Controlla se siamo su un determinato modulo
  static bool isOnModule(BuildContext context, String modulePath) {
    return getCurrentPath(context).startsWith(modulePath);
  }

  /// Naviga con parametri query
  static void goWithQueryParams(
    BuildContext context,
    String path, {
    Map<String, String>? queryParams,
  }) {
    if (queryParams != null && queryParams.isNotEmpty) {
      final uri = Uri(path: path, queryParameters: queryParams);
      context.go(uri.toString());
    } else {
      context.go(path);
    }
  }

  /// Naviga con extra data
  static void goWithExtra(
    BuildContext context,
    String path, {
    Object? extra,
  }) {
    context.go(path, extra: extra);
  }

  /// Push di una route (mantiene la history)
  static void push(BuildContext context, String path) {
    context.push(path);
  }

  /// Replace della route corrente
  static void replace(BuildContext context, String path) {
    context.replace(path);
  }
}

