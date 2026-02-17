import 'package:project_dsh/modules/events/pages/edit_event.page.dart';
import 'package:project_dsh/modules/events/pages/event.page.dart';
import 'package:project_dsh/modules/events/pages/new_event.page.dart';
import '../../utils/go_router_modular/module.dart';
import '../../utils/go_router_modular/routes/child_route.dart';
import '../../utils/go_router_modular/routes/cl_route.dart';
import '../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/event_routes.constant.dart';
import 'modules/event_product/costants/event_product_routes.costant.dart';
import 'modules/event_product/pages/edit_event_product.page.dart';
import 'modules/event_product/pages/new_event_product.page.dart';
import 'modules/event_product/pages/view_event_product.page.dart';
import 'pages/view_event.page.dart';

class EventModule extends Module {
  @override
  CLRoute get moduleRoute => EventRoutes.moduleRoute;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(route: EventRoutes.event, childBuilder: (context, state) => const EventPage(), isModuleRoute: true),
        ChildRoute.build(route: EventRoutes.viewEvent, childBuilder: (context, state) => ViewEventPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
        ChildRoute.build(route: EventRoutes.editEvent, childBuilder: (context, state) => EditEventPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
        ChildRoute.build(route: EventRoutes.newEvent, childBuilder: (context, state) => NewEventPage(), isVisible: false),
        ChildRoute.build(route: EventProductRoutes.viewEventProduct, childBuilder: (context, state) => ViewEventProductPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
        ChildRoute.build(route: EventProductRoutes.editEventProduct, childBuilder: (context, state) => EditEventProductPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
        ChildRoute.build(route: EventProductRoutes.newEventProduct, childBuilder: (context, state) => NewEventProductPage(eventId: state.pathParameters["eventId"]!), params: ["eventId"], isVisible: false),
      ];
}
