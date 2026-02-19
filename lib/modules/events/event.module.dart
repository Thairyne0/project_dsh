import 'package:flutter/material.dart';
import 'package:project_dsh/modules/events/pages/edit_event.page.dart';
import 'package:project_dsh/modules/events/pages/event.page.dart';
import 'package:project_dsh/modules/events/pages/new_event.page.dart';
import 'package:project_dsh/utils/go_router_modular/routes/module_route.dart';
import '../../utils/go_router_modular/module.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/cl_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/event_routes.constant.dart';
import 'modules/event_product/event_product.module.dart';
import 'pages/view_event.page.dart';
import 'package:project_dsh/utils/go_router_modular/breadcrumb.system.dart';

class EventModule extends Module with BreadcrumbAware {
  @override
  Map<String, String> get breadcrumbLabels => {
    '/events': 'Eventi',
    '/events/new': 'Nuovo Evento',
  };

  @override
  CLRoute get moduleRoute => EventRoutes.moduleRoute;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(
          route: EventRoutes.event,
          childBuilder: (context, state) => const EventPage(),
          isModuleRoute: true,
          routes: [
            // Route figlie di Eventi (annidate)
            ChildRoute.build(
                route: EventRoutes.viewEvent,
                childBuilder: (context, state) => ViewEventPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: EventRoutes.editEvent,
                childBuilder: (context, state) => EditEventPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: EventRoutes.newEvent,
                childBuilder: (context, state) => NewEventPage(),
                isVisible: false),
          ],
        ),
        ModuleRoute(
          module: EventProductModule(),
          icon: Icons.abc_outlined,
          isVisible: false
        ),
      ];
}
