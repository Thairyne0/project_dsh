import '../../../utils/go_router_modular/routes/cl_route.dart';

class ProfileRoutes {
  static final CLRoute profileModule = CLRoute(name: "Profilo", path: "/profile");
  static final CLRoute userProfile = CLRoute(name: "Profilo Utente", path: "/");
  static final CLRoute editUserProfile = CLRoute(name: "Modifica Profilo Utente", path: "/edit-user-profile");
}
