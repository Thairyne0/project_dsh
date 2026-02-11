import 'package:project_dsh/modules/auth/constants/auth_routes.constants.dart';
import 'package:project_dsh/modules/auth/pages/email_sent.page.dart';
import 'package:project_dsh/modules/auth/pages/login.page.dart';
import 'package:project_dsh/modules/auth/pages/recover_password.page.dart';
import 'package:project_dsh/modules/auth/pages/set_new_password.page.dart';
import 'package:project_dsh/utils/go_router_modular/routes/cl_route.dart';
import 'pages/confirm-new-password.page.dart';
import '../../utils/go_router_modular/module.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';

class AuthModule extends Module {
  @override
  CLRoute get moduleRoute => AuthRoutes.moduleRoute;

  @override
  List<ModularRoute> get routes => [
    ChildRoute.build(
      route: AuthRoutes.login,
      childBuilder: (context, state) => const LoginPage(),
    ),


    ChildRoute.build(route: AuthRoutes.recoverPassword, childBuilder: (context, state) => const RecoverPasswordPage()),
    ChildRoute.build(
        route: AuthRoutes.setNewPassword, childBuilder: (context, state) => SetNewPasswordPage(code: state.pathParameters['code']!), params: ['code']),
    ChildRoute.build(route: AuthRoutes.emailSent, childBuilder: (context, state) => const EmailSent()),
    ChildRoute.build(route: AuthRoutes.confirmNewPassword, childBuilder: (context, state) => const ConfirmNewPassword()),




  ];
}
