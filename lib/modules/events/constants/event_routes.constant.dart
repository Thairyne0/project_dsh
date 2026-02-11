import '../../../utils/go_router_modular/routes/cl_route.dart';
class EventRoutes {
  static final CLRoute moduleRoute = CLRoute(name: "Gestione Eventi", path: "/events");
  static final CLRoute event = CLRoute(name: "Eventi", path: "/");
  static final CLRoute viewEvent = CLRoute(name: "Dettaglio Evento", path: "/event-details");
  static final CLRoute editEvent = CLRoute(name: "Modifica Evento", path: "/event-edit");
  static final CLRoute newEvent = CLRoute(name: "Aggiungi Evento", path: "/new-event");
}
