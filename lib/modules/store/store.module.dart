import 'package:flutter/material.dart';
import 'package:project_dsh/modules/store/modules/store_report/store_report.module.dart';
import 'package:project_dsh/modules/store/pages/add_location_to_store.page.dart';
import 'package:project_dsh/modules/store/pages/add_store_category_to_store.page.dart';
import 'package:project_dsh/modules/store/pages/add_store_employee.page.dart';
import 'package:project_dsh/modules/store/pages/store.page.dart';
import 'package:project_dsh/utils/go_router_modular/routes/module_route.dart';
import '../../utils/go_router_modular/go_router_modular_configure.dart';
import '../../utils/go_router_modular/module.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/cl_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';
import '../../utils/providers/authstate.util.provider.dart';
import '../users/constants/permission_slug.dart';
import 'constants/store_routes.constant.dart';
import 'modules/brand/brand.module.dart';
import 'modules/location/constants/location_routes.constant.dart';
import 'modules/location/pages/edit_location.page.dart';
import 'modules/location/pages/view_location.page.dart';
import 'modules/promo/promo.module.dart';
import 'modules/store_category/store_category.module.dart';
import 'modules/store_report/constants/store_report_routes.constant.dart';
import 'modules/store_report/pages/edit_store_report.page.dart';
import 'modules/store_report/pages/new_store_report.page.dart';
import 'pages/edit_store.page.dart';
import 'pages/new_store.page.dart';
import 'pages/view_store.page.dart';

class StoreModule extends Module {
  @override
  CLRoute get moduleRoute => StoreRoutes.storesModule;

  @override
  List<ModularRoute> get routes => [
        // Pagina principale del modulo Store
        ChildRoute.build(
          route: StoreRoutes.stores,
          childBuilder: (context, state) => const StorePage(),
          isModuleRoute: true,
          isVisible: true,
          routes: [
            // Route figlie dirette di Store (dettagli, edit, new) - annidate
            ChildRoute.build(
                route: StoreRoutes.viewStore,
                childBuilder: (context, state) => ViewStorePage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: StoreRoutes.editStore,
                childBuilder: (context, state) => EditStorePage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: StoreRoutes.storeEmployee,
                childBuilder: (context, state) => AddStoreEmployeePage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: StoreRoutes.newStore,
                childBuilder: (context, state) => NewStorePage(),
                isVisible: false),
            ChildRoute.build(
                route: StoreRoutes.addStoreCategoryToStore,
                childBuilder: (context, state) => AddStoreCategoryToStorePage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
          ],
        ),

        // Location - route figlie di Store (mantenute al primo livello perché non sono sotto la lista Store)
        ChildRoute.build(
            route: LocationRoutes.newLocation,
            childBuilder: (context, state) => AddLocationToStorePage(storeId: state.pathParameters["storeId"]!),
            params: ["storeId"],
            isVisible: false),
        ChildRoute.build(
            route: LocationRoutes.viewLocation,
            childBuilder: (context, state) => ViewLocationPage(id: state.pathParameters["id"]!),
            params: ["id"],
            isVisible: false),
        ChildRoute.build(
            route: LocationRoutes.editLocation,
            childBuilder: (context, state) => EditLocationPage(locationId: state.pathParameters["locationId"]!),
            params: ["locationId"],
            isVisible: false),

        // StoreReport - route figlie di Store (le edit/new, la lista è nel ModuleRoute sotto)
        ChildRoute.build(
            route: StoreReportRoutes.editStoreReport,
            childBuilder: (context, state) => EditStoreReportPage(id: state.pathParameters["id"]!),
            params: ["id"],
            isVisible: false),
        ChildRoute.build(
            route: StoreReportRoutes.newStoreReport,
            childBuilder: (context, state) => NewStoreReportPage(storeId: state.pathParameters["storeId"]!),
            params: ["storeId"],
            isVisible: false),

        // Sottomoduli (rami paralleli a Store)
        ModuleRoute(
            module: PromoModule(),
            icon: Icons.abc_outlined,
            isVisible: true),
        ModuleRoute(
            module: StoreCategoryModule(),
            icon: Icons.abc_outlined,
            isVisible: GoRouterModular.get<AuthState>().hasPermission(PermissionSlugs.visualizzaCategorieStore)),
        ModuleRoute(
            module: BrandModule(),
            icon: Icons.abc_outlined,
            isVisible: GoRouterModular.get<AuthState>().hasPermission(PermissionSlugs.visualizzaBrand)),
        ModuleRoute(
            module: StoreReportModule(),
            icon: Icons.abc_outlined,
            isVisible: GoRouterModular.get<AuthState>().hasPermission(PermissionSlugs.visualizzaStoreReport)),
      ];
}
