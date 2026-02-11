import '../../../../../utils/go_router_modular/routes/cl_route.dart';
class NewsRoutes {
  static final CLRoute newsModule = CLRoute(name: "Gestione News", path: "/news");
  static final CLRoute news = CLRoute(name: "News", path: "/");
  static final CLRoute viewNews = CLRoute(name: "Dettaglio News", path: "/news-details");
  static final CLRoute editNews = CLRoute(name: "Modifica News", path: "/news-edit");
  static final CLRoute newNews = CLRoute(name: "Aggiungi News", path: "/news-new");
}
