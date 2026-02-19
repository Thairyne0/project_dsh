import '../../../../utils/go_router_modular/module.dart';
import '../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/promo_routes.constant.dart';
import 'pages/edit_promo.page.dart';
import 'pages/new_promo.page.dart';
import 'pages/promo.page.dart';
import 'pages/view_promo.page.dart';
import 'package:project_dsh/utils/go_router_modular/breadcrumb.system.dart';


class PromoModule extends Module with BreadcrumbAware {
  @override
  Map<String, String> get breadcrumbLabels => {
    '/store/promos': 'Promozioni',
    '/store/promos/new': 'Nuova Promo',
  };

  @override
  CLRoute get moduleRoute => PromoRoutes.promoModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(
          route: PromoRoutes.promo,
          childBuilder: (context, state) => const PromoPage(),
          isModuleRoute: true,
          routes: [
            // Route figlie di Promozioni (annidate)
            ChildRoute.build(
                route: PromoRoutes.viewPromo,
                childBuilder: (context, state) => ViewPromoPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: PromoRoutes.editPromo,
                childBuilder: (context, state) => EditPromoPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: PromoRoutes.newPromo,
                childBuilder: (context, state) => NewPromoPage(storeId: state.pathParameters["storeId"]),
                params: ["storeId"],
                isVisible: false),
          ],
        ),
      ];
}


