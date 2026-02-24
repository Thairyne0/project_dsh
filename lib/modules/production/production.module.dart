import '../../../utils/go_router_modular/module.dart';
import '../../../utils/go_router_modular/routes/child_route.dart';
import '../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/production_routes.constants.dart';
import 'pages/production.page.dart';

class ProductionModule extends Module {
  @override
  CLRoute get moduleRoute => ProductionRoutes.productionModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(
          route: ProductionRoutes.production,
          childBuilder: (context, state) => const ProductionPage(),
          isModuleRoute: true,
        ),
      ];
}

