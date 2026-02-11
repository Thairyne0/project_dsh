import '../../../../../utils/go_router_modular/routes/cl_route.dart';

class StoreReportRoutes {
  static final CLRoute storeReportsModule = CLRoute(name: "Report Store", path: "/store-reports");
  static final CLRoute storeReports = CLRoute(name: "Report Store", path: "/");
  static final CLRoute viewStoreReport = CLRoute(name: "Dettaglio Report Store", path: "/store-report-detail");
  static final CLRoute editStoreReport = CLRoute(name: "Modifica Report Store", path: "/edit-store-report");
  static final CLRoute newStoreReport = CLRoute(name: "Aggiungi Report Store", path: "/new-store-report");
}
