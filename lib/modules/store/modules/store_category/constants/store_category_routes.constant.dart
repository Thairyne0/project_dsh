import '../../../../../utils/go_router_modular/routes/cl_route.dart';

class StoreCategoryRoutes {
  static final CLRoute storeCategoriesModule = CLRoute(name: "Categorie Store", path: "/store-categories");
  static final CLRoute storeCategories = CLRoute(name: "Categorie Store", path: "/");
  static final CLRoute viewStoreCategory = CLRoute(name: "Dettaglio Categoria Store", path: "/store-categorie-details");
  static final CLRoute editStoreCategory = CLRoute(name: "Modifica Categoria Store", path: "/edit-store-categorie");
  static final CLRoute newStoreCategory = CLRoute(name: "Aggiungi Categoria Store", path: "/edit-store-categorie");
  static final CLRoute addStoreToStoreCategory= CLRoute(name: "Aggiungi Store alla Categoria", path: "/store-add");
}
