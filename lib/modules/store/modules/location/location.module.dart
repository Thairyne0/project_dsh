import '../../../../utils/go_router_modular/module.dart';
import '../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/location_routes.constant.dart';
import 'pages/edit_location.page.dart';
import 'pages/location.page.dart';
import 'pages/new_location.page.dart';
import 'pages/view_location.page.dart';

class LocationModule extends Module {
  @override
  CLRoute get moduleRoute => LocationRoutes.locationModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(
          route: LocationRoutes.location,
          childBuilder: (context, state) => const LocationPage(),
        ),
        ChildRoute.build(route: LocationRoutes.viewLocation, childBuilder: (context, state) => ViewLocationPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
        ChildRoute.build(route: LocationRoutes.editLocation, childBuilder: (context, state) => EditLocationPage(locationId: state.pathParameters["locationId"]!,), params: ["locationId"], isVisible: false),
        ChildRoute.build(route: LocationRoutes.newLocation, childBuilder: (context, state) => NewLocationPage(), isVisible: false),
      ];
}
