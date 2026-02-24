import 'package:project_dsh/utils/go_router_modular/routes/cl_route.dart';
import 'package:project_dsh/utils/go_router_modular/routes/module_route.dart';
import '../../utils/go_router_modular/module.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/machine_routes.constants.dart';
import 'modules/manage_machines/manage_machines.module.dart';
import 'pages/machines.page.dart';
import 'pages/view_machine.page.dart';

class MachinesModule extends Module {
  @override
  CLRoute get moduleRoute => MachineRoutes.machinesModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(
          route: MachineRoutes.machines,
          childBuilder: (context, state) => const MachinesPage(),
          isModuleRoute: true,
          routes: [
            ChildRoute.build(
              route: MachineRoutes.viewMachine,
              childBuilder: (context, state) => ViewMachinePage(id: state.pathParameters['id']!),
              params: ['id'],
              isVisible: false,
            ),
          ],
        ),
        // Sottomodulo gestione macchinari
        ModuleRoute(module: ManageMachinesModule(), isVisible: true),
      ];
}
