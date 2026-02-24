import '../../../../utils/go_router_modular/routes/cl_route.dart';

class MachineRoutes {
  static final CLRoute machinesModule = CLRoute(name: "Macchinari", path: "/machines");
  static final CLRoute machines = CLRoute(name: "Macchinari", path: "/");
  static final CLRoute viewMachine = CLRoute(name: "Dettaglio Macchinario", path: "/machine-details");
}

