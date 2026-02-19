import 'package:project_dsh/modules/store/modules/store_report/constants/store_report_routes.constant.dart';
import 'package:project_dsh/modules/store/modules/store_report/pages/store_report.page.dart';
import 'package:project_dsh/modules/store/modules/store_report/pages/view_store_report.page.dart';
import '../../../../utils/go_router_modular/module.dart';
import '../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../utils/go_router_modular/routes/i_modular_route.dart';

class StoreReportModule extends Module {
  @override
  CLRoute get moduleRoute => StoreReportRoutes.storeReportsModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(
          route: StoreReportRoutes.storeReports,
          childBuilder: (context, state) => const StoreReportPage(),
          isModuleRoute: true,
          routes: [
            // Route figlie di Report Store (annidate)
            ChildRoute.build(
                route: StoreReportRoutes.viewStoreReport,
                childBuilder: (context, state) => ViewStoreReportPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
          ],
        ),
      ];
}
