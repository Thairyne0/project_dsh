import '../../../../../utils/go_router_modular/routes/cl_route.dart';

class LocationRoutes {
  static final CLRoute locationModule = CLRoute(name: "Gestione Locations", path: "/locations");
  static final CLRoute location = CLRoute(name: "Location", path: "/");
  static final CLRoute viewLocation = CLRoute(name: "Dettaglio Location", path: "/details-location");
  static final CLRoute editLocation = CLRoute(name: "Modifica Location", path: "/edit-location");
  static final CLRoute newLocation = CLRoute(name: "Aggiungi Location", path: "/new-location");
}
