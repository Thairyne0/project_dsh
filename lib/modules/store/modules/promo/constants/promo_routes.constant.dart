import '../../../../../utils/go_router_modular/routes/cl_route.dart';
class PromoRoutes {
  static final CLRoute promoModule = CLRoute(name: "Promo", path: "/promos");

  static final CLRoute promo = CLRoute(name: "Promozioni", path: "/promos");
  static final CLRoute viewPromo = CLRoute(name: "Dettaglio Promo", path: "/details-promo");
  static final CLRoute editPromo = CLRoute(name: "Modifica Promo", path: "/edit-promo");
  static final CLRoute newPromo = CLRoute(name: "Aggiungi Promo", path: "/new-promo");
}
