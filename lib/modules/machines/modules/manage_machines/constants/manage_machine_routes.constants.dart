import '../../../../../utils/go_router_modular/routes/cl_route.dart';

class ManageMachineRoutes {
  static final CLRoute manageMachinesModule = CLRoute(name: "Gestione Macchinari", path: "/manage");
  static final CLRoute manageMachines = CLRoute(name: "Gestione Macchinari", path: "/");
  static final CLRoute newMachine = CLRoute(name: "Nuovo Macchinario", path: "/new-machine");
  static final CLRoute editMachine = CLRoute(name: "Modifica Macchinario", path: "/edit-machine");
}

