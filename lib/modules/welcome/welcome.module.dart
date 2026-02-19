import 'package:project_dsh/modules/welcome/pages/welcome.page.dart';

import '../../utils/go_router_modular/module.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/cl_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/welcome_routes.constants.dart';
import 'package:project_dsh/utils/go_router_modular/breadcrumb.system.dart';

class WelcomeModule extends Module with BreadcrumbAware {
  @override
  Map<String, String> get breadcrumbLabels => {
     '/welcome': 'Benvenuto'
  };

  @override
  CLRoute get moduleRoute => WelcomeRoutes.moduleRoute;
  @override
  List<ModularRoute> get routes => [
    ChildRoute.build(
      route:WelcomeRoutes.welcome,
      childBuilder: (context, state) => const WelcomePage(),
      isModuleRoute: true
    ),
  ];
}
