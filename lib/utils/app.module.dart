import 'package:project_dsh/utils/go_router_modular/routes/cl_route.dart';
import 'package:project_dsh/utils/providers/appstate.util.provider.dart';
import 'package:project_dsh/utils/providers/authstate.util.provider.dart';
import 'package:provider/provider.dart';
import '../app.constants.dart';
import '../modules/auth/auth.module.dart';
import '../ui/layout/app.layout.dart';
import '../ui/layout/menu.layout.dart';
import '../ui/pages/error_page.page.dart';
import 'constants/routes.constants.dart';
import 'go_router_modular/bind.dart';
import 'go_router_modular/module.dart';
import 'go_router_modular/routes/child_route.dart';
import 'go_router_modular/routes/i_modular_route.dart';
import 'go_router_modular/routes/shell_modular_route.dart';
import 'observers/navigation.util.observer.dart';

class AppModule extends Module {
  @override
  CLRoute get moduleRoute => CLRoute(name: "App", path: "/app");

  AppModule();

  @override
  List<Bind<Object>> get binds => [
    Bind.factory<MenuLayout>((i) => MenuLayout(routes: routes)),
    Bind.singleton<AuthState>((i) => AuthState()),
    Bind.singleton<AppState>((i) => AppState()),
  ];

  @override
  List<ModularRoute> get routes => [
    ...AppConstants.appRoutesConfiguration,
    ChildRoute.build(route: AppRoutes.error, childBuilder: (context, state) => const ErrorPage(), isVisible: false),
    ChildRoute.build(
      route: AppRoutes.forbidden,
      childBuilder: (context, state) => const ErrorPage(),
      isVisible: false
    ),
    if (AppConstants.mainShellRoutesConfiguration.isNotEmpty)
      ShellModularRoute(
        builder: (context, state, child) => AppLayout(shellChild: child),
        observers: [GoRouterBreadcrumbObserver()],
        redirect: (context, state) {
          AuthState authState = Provider.of<AuthState>(context, listen: false);
          if (!authState.isAuthenticated) {
            return AuthModule().moduleRoute.path;
          }
          return null;
        },
        routes: AppConstants.mainShellRoutesConfiguration,
      ),
  ];
}
