import '../../../utils/go_router_modular/routes/cl_route.dart';
class UserRoutes {
  static final CLRoute moduleRoute = CLRoute(name: "Gestione Utenti", path: "/users");
  static final CLRoute users = CLRoute(name: "Utenti", path: "/");
  static final CLRoute viewUser = CLRoute(name: "Dettaglio Utente", path: "/user-details");
  static final CLRoute editUser = CLRoute(name: "Modifica Utente", path: "/user-edit");
  static final CLRoute newUser = CLRoute(name: "Aggiungi Utente", path: "/new-user");
  static final CLRoute addPermissionToUser = CLRoute(name: "Aggiungi Permesso all\'utente", path: "/permission-add");
}
