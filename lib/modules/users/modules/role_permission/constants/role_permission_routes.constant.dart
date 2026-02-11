import '../../../../../utils/go_router_modular/routes/cl_route.dart';
class RoleRoutes {
  static final CLRoute roleModule = CLRoute(name: "Gestione Ruoli/Permessi", path: "/roles");
  static final CLRoute role = CLRoute(name: "Ruoli/Permessi", path: "/");
  static final CLRoute viewRole = CLRoute(name: "Dettaglio Ruolo", path: "/role-details");
  static final CLRoute editRole = CLRoute(name: "Modifica Ruolo", path: "/role-edit");
  static final CLRoute newRole = CLRoute(name: "Aggiungi Ruolo", path: "/role-new");
  static final CLRoute addPermissionToRole = CLRoute(name: "Aggiungi Permesso al ruolo", path: "/permission-add");
}
