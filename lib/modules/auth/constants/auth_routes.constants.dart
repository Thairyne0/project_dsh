import '../../../utils/go_router_modular/routes/cl_route.dart';

class AuthRoutes {
  static final CLRoute moduleRoute = CLRoute(name: "Autenticazione", path: "/auth");
  static final CLRoute login = CLRoute(name: "Login", path: "/login");
  static final CLRoute recoverPassword = CLRoute(name: "Recupero Password", path: "/recover-password");
  static final CLRoute setNewPassword = CLRoute(name: "Nuova password", path: "/reset-password");
  static final CLRoute emailSent = CLRoute(name: "Email inviata", path: "/email-sent");
  static final CLRoute confirmNewPassword = CLRoute(name: "Password aggiornata", path: "/confirm-new-password");
}
