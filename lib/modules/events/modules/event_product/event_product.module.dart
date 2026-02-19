import 'package:project_dsh/modules/events/modules/event_product/pages/edit_event_product.page.dart';
import 'package:project_dsh/modules/events/modules/event_product/pages/new_event_product.page.dart';
import 'package:project_dsh/modules/events/modules/event_product/pages/view_event_product.page.dart';

import '../../../../utils/go_router_modular/module.dart';
import '../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'costants/event_product_routes.costant.dart';

class EventProductModule extends Module{

  @override
  CLRoute get moduleRoute => EventProductRoutes.eventProductsModule;

  @override
  List<ModularRoute> get routes => [
    ChildRoute.build(route: EventProductRoutes.viewEventProduct, childBuilder: (context, state) => ViewEventProductPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: true),
    ChildRoute.build(route: EventProductRoutes.editEventProduct, childBuilder: (context, state) => EditEventProductPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: true),
    ChildRoute.build(route: EventProductRoutes.newEventProduct, childBuilder: (context, state) => NewEventProductPage(eventId: state.pathParameters["eventId"]!), params: ["eventId"], isVisible: true),
  ];

}