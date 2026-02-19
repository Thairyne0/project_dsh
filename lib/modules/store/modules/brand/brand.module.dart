import '../../../../utils/go_router_modular/module.dart';
import '../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/brand_routes.costant.dart';
import 'pages/brand.page.dart';
import 'pages/edit_brand.page.dart';
import 'pages/new_brand.page.dart';
import 'pages/view_brand.page.dart';

class BrandModule extends Module {
  @override
  CLRoute get moduleRoute => BrandRoutes.brandModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(
          route: BrandRoutes.brand,
          childBuilder: (context, state) => const BrandPage(),
          isModuleRoute: true,
          routes: [
            // Route figlie di Brand (annidate)
            ChildRoute.build(
                route: BrandRoutes.viewBrand,
                childBuilder: (context, state) => ViewBrandPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: BrandRoutes.editBrand,
                childBuilder: (context, state) => EditBrandPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: BrandRoutes.newBrand,
                childBuilder: (context, state) => NewBrandPage(),
                isVisible: false),
          ],
        ),
      ];
}
