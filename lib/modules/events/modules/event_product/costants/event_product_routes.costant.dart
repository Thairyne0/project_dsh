import '../../../../../utils/go_router_modular/routes/cl_route.dart';

class EventProductRoutes {
  static final CLRoute eventProductsModule = CLRoute(name: "Prodotti Eventi", path: "/event-products");
  static final CLRoute eventProducts = CLRoute(name: "Prodotti Evento", path: "/");
  static final CLRoute viewEventProduct = CLRoute(name: "Dettaglio Prodotto Evento", path: "/event-product-details");
  static final CLRoute editEventProduct = CLRoute(name: "Modifica Prodotto Evento", path: "/edit-event-product");
  static final CLRoute newEventProduct = CLRoute(name: "Aggiungi Prodotto Evento", path: "/add-event-product");
}
