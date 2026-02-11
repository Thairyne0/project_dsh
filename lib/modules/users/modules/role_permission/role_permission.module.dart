import 'package:project_dsh/modules/users/modules/role_permission/constants/role_permission_routes.constant.dart';
import 'package:project_dsh/modules/users/modules/role_permission/pages/add_permission_to_role.page.dart';
import '../../../../utils/go_router_modular/module.dart';
import '../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'pages/edit_role.page.dart';
import 'pages/new_role.page.dart';
import 'pages/role.page.dart';
import 'pages/view_role.page.dart';


class RolePermissionModule extends Module {
  @override
  CLRoute get moduleRoute => RoleRoutes.roleModule;

  @override
  List<ModularRoute> get routes => [
    ChildRoute.build(route: RoleRoutes.role, childBuilder: (context, state) => const RolePage(), isModuleRoute: true),
    ChildRoute.build(
        route: RoleRoutes.viewRole, childBuilder: (context, state) => ViewRolePage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
    ChildRoute.build(route: RoleRoutes.editRole, childBuilder: (context, state) => EditRolePage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
    ChildRoute.build(route: RoleRoutes.newRole, childBuilder: (context, state) => NewRolePage(), isVisible: false),
    ChildRoute.build(route: RoleRoutes.addPermissionToRole, childBuilder: (context, state) => AddPermissionToRolePage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
  ];
}
