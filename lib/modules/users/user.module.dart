import 'package:flutter/material.dart';
import 'package:project_dsh/modules/users/modules/role_permission/role_permission.module.dart';
import 'package:project_dsh/modules/users/pages/add_permission_to_user.page.dart';
import 'package:project_dsh/modules/users/pages/edit_user.page.dart';
import 'package:project_dsh/modules/users/pages/new_user.page.dart';
import 'package:project_dsh/modules/users/pages/users.page.dart';
import 'package:project_dsh/modules/users/pages/view_user.page.dart';
import 'package:project_dsh/utils/go_router_modular/routes/module_route.dart';
import '../../utils/go_router_modular/go_router_modular_configure.dart';
import '../../utils/go_router_modular/module.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/cl_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';
import '../../utils/providers/authstate.util.provider.dart';
import 'constants/permission_slug.dart';
import 'constants/users_routes.constants.dart';
import 'package:project_dsh/utils/go_router_modular/breadcrumb.system.dart';

class UsersModule extends Module with BreadcrumbAware {
  @override
  Map<String, String> get breadcrumbLabels => {
    '/users': 'Utenti',
    '/users/new': 'Nuovo Utente',
    '/users/permissions': 'Gestione Permessi',
  };

  @override
  CLRoute get moduleRoute => UserRoutes.moduleRoute;

  @override
  List<ModularRoute> get routes => [
    ChildRoute.build(
        route: UserRoutes.users,
        childBuilder: (context, state) => const UsersPage(),
        isModuleRoute: true
    ),
    ChildRoute.build(route: UserRoutes.viewUser, childBuilder: (context, state) => ViewUserPage(id: state.pathParameters["id"]!), params: ["id"],isVisible: false),
    ChildRoute.build(route: UserRoutes.editUser, childBuilder: (context, state) => EditUserPage(id: state.pathParameters["id"]!), params: ["id"],isVisible: false),
    ChildRoute.build(route: UserRoutes.newUser, childBuilder: (context, state) => NewUserPage(), isVisible: false),
    ChildRoute.build(route: UserRoutes.addPermissionToUser, childBuilder: (context, state) => AddPermissionToUserPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
    ModuleRoute(module: RolePermissionModule(), icon: Icons.abc_outlined,isVisible: GoRouterModular.get<AuthState>().hasPermission(PermissionSlugs.visualizzaRuoli)),
  ];
}
