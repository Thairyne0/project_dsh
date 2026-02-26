import 'constants/service_selector_routes.constants.dart';
import 'pages/service_selector.page.dart';
import '../../utils/go_router_modular/routes/cl_route.dart';
import '../../utils/go_router_modular/module.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';
import '../../utils/go_router_modular/breadcrumb.system.dart';

class ServiceSelectorModule extends Module with BreadcrumbAware {
  @override
  Map<String, String> get breadcrumbLabels => {
    '/service-selector': 'Seleziona Servizio',
  };

  @override
  CLRoute get moduleRoute => ServiceSelectorRoutes.moduleRoute;

  @override
  List<ModularRoute> get routes => [
    ChildRoute.build(
      route: ServiceSelectorRoutes.selector,
      childBuilder: (context, state) => const ServiceSelectorPage(),
      isModuleRoute: true,
    ),
  ];
}


