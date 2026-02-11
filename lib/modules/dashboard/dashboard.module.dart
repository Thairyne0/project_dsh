import 'package:project_dsh/modules/dashboard/constants/dashboard_routes.constants.dart';
import 'package:project_dsh/modules/dashboard/pages/dashboard.page.dart';
import 'package:project_dsh/utils/go_router_modular/routes/cl_route.dart';
import '../../utils/go_router_modular/module.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';

class DashboardModule extends Module {
  @override
  CLRoute get moduleRoute => DashboardRoutes.moduleRoute;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(route: DashboardRoutes.dashboard, childBuilder: (context, state) => const DashboardPage(), isModuleRoute: true),
      ];
}
