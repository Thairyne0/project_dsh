import '../../../utils/go_router_modular/routes/cl_route.dart';

class StoreRoutes {
  static final CLRoute storesModule = CLRoute(name: "Gestione Store", path: "/stores");
  static final CLRoute stores = CLRoute(name: "Store", path: "/"); // ← Path relativo
  static final CLRoute viewStore = CLRoute(name: "Dettaglio Store", path: "/details-store");
  static final CLRoute editStore = CLRoute(name: "Modifica Store", path: "/edit-store");
  static final CLRoute newStore = CLRoute(name: "Aggiungi Store", path: "/new-store");
  static final CLRoute storeEmployee = CLRoute(name: "Aggiungi Dipendente", path: "/add-storeEmployee");
  static final CLRoute addStoreCategoryToStore = CLRoute(name: "Aggiungi Categoria allo Store", path: "/storeCategory-add");
}
