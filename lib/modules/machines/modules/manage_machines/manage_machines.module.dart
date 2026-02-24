import '../../../../../utils/go_router_modular/module.dart';
import '../../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/manage_machine_routes.constants.dart';
import 'pages/edit_machine.page.dart';
import 'pages/manage_machines.page.dart';
import 'pages/new_machine.page.dart';

class ManageMachinesModule extends Module {
  @override
  CLRoute get moduleRoute => ManageMachineRoutes.manageMachinesModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(
          route: ManageMachineRoutes.manageMachines,
          childBuilder: (context, state) => const ManageMachinesPage(),
          isModuleRoute: true,
          routes: [
            ChildRoute.build(
              route: ManageMachineRoutes.newMachine,
              childBuilder: (context, state) => const NewMachinePage(),
              isVisible: false,
            ),
            ChildRoute.build(
              route: ManageMachineRoutes.editMachine,
              childBuilder: (context, state) => EditMachinePage(id: state.pathParameters['id']!),
              params: ['id'],
              isVisible: false,
            ),
          ],
        ),
      ];
}
