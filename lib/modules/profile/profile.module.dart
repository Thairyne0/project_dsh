import 'package:project_dsh/modules/profile/pages/edit_profile.page.dart';
import 'package:project_dsh/modules/profile/pages/profile.page.dart';
import 'package:project_dsh/utils/go_router_modular/routes/cl_route.dart';
import 'package:project_dsh/utils/go_router_modular/breadcrumb.system.dart';

import '../../utils/go_router_modular/module.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/users_routes.constants.dart';

class ProfileModule extends Module with BreadcrumbAware {
  @override
  Map<String, String> get breadcrumbLabels => {
    '/profile': 'Profilo',
    '/profile/edit': 'Modifica Profilo', 
  };

  @override
  CLRoute get moduleRoute => ProfileRoutes.profileModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(route: ProfileRoutes.userProfile, childBuilder: (context, state) => const ProfilePage(), isModuleRoute: true),
    ChildRoute.build(route: ProfileRoutes.editUserProfile, childBuilder: (context, state) => EditProfilePage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),

  ];
}
