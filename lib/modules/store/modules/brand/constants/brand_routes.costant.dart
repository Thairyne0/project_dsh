import '../../../../../utils/go_router_modular/routes/cl_route.dart';
class BrandRoutes {
  static final CLRoute brandModule = CLRoute(name: "Gestione Brands", path: "/brands");
  static final CLRoute brand = CLRoute(name: "Brand", path: "/");
  static final CLRoute viewBrand = CLRoute(name: "Dettaglio Brand", path: "/brand-details");
  static final CLRoute editBrand = CLRoute(name: "Modifica Brand", path: "/brand-edit");
  static final CLRoute newBrand = CLRoute(name: "Aggiungi Brand", path: "/brand-new");
}
