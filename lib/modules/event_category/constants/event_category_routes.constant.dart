import '../../../../../utils/go_router_modular/routes/cl_route.dart';

class EventCategoryRoutes {
  static final CLRoute eventCategoriesModule = CLRoute(name: "Categorie Eventi", path: "/event-categories");
  static final CLRoute eventCategories = CLRoute(name: "Categorie Evento", path: "/");
  static final CLRoute viewEventCategory = CLRoute(name: "Dettaglio Categoria Evento", path: "/event-categorie-details");
  static final CLRoute editEventCategory = CLRoute(name: "Modifica Categoria Evento", path: "/edit-event-categorie");
  static final CLRoute newEventCategory = CLRoute(name: "Aggiungi Categoria Evento", path: "/edit-event-categorie");
}
