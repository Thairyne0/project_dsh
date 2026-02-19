import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_dsh/modules/events/modules/event_product/event_product.module.dart';
import 'package:project_dsh/utils/go_router_modular/go_router_modular_configure.dart';
import 'package:project_dsh/utils/go_router_modular/routes/child_route.dart';
import 'package:project_dsh/utils/go_router_modular/routes/i_modular_route.dart';
import 'package:project_dsh/utils/go_router_modular/routes/module_route.dart';
import 'modules/announcement/announcement.module.dart';
import 'modules/auth/auth.module.dart';
import 'modules/dashboard/dashboard.module.dart';
import '../../utils/providers/authstate.util.provider.dart';
import 'modules/event_category/event_category.module.dart';
import 'modules/events/event.module.dart';
import 'modules/news/news.module.dart';
import 'modules/profile/profile.module.dart';
import 'modules/store/store.module.dart';
import 'modules/users/constants/permission_slug.dart';
import 'modules/welcome/welcome.module.dart';

class AppConstants {
  //static const baseUrl = "https://stagingvbbackend.inext.ai/api/";
  static const host = "http://dev.generazioneai.it:3002";
  //static const host = "http://172.16.16.176:3002";
  static const baseUrl = "$host/api/";
  static const authApiVersion = "v1/";
  static String timeFormat = "hh:mm";

  static List<ModularRoute> appRoutesConfiguration = [
    ModuleRoute(module: WelcomeModule()),
    ModuleRoute(module: AuthModule()),
  ];

  static List<ModularRoute> get mainShellRoutesConfiguration {
    final authState = GoRouterModular.get<AuthState>();
    return [
      ModuleRoute(module: DashboardModule(), icon: Icons.dashboard),
      ModuleRoute(module: NewsModule(), icon: FontAwesomeIcons.newspaper, isVisible: authState.hasPermission(PermissionSlugs.visualizzaNews)),
      ModuleRoute(module: ProfileModule(), icon: FontAwesomeIcons.person, isVisible: false),
      ModuleRoute(module: EventModule(), icon: FontAwesomeIcons.calendar, isVisible: authState.hasPermission(PermissionSlugs.visualizzaEventi)),
      ModuleRoute(module: EventCategoryModule(), icon: FontAwesomeIcons.calendarCheck, isVisible: true),
      ModuleRoute(module: StoreModule(), icon: FontAwesomeIcons.store, isVisible: true),
    ];
  }
}
