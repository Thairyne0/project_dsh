import 'package:project_dsh/modules/event_category/pages/edit_event_category.page.dart';
import 'package:project_dsh/modules/event_category/pages/event_category.page.dart';
import 'package:project_dsh/modules/event_category/pages/new_event_category.page.dart';
import 'package:project_dsh/modules/event_category/pages/view_event_category.page.dart';
import '../../../../utils/go_router_modular/module.dart';
import '../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/event_category_routes.constant.dart';
import 'package:project_dsh/utils/go_router_modular/breadcrumb.system.dart';

class EventCategoryModule extends Module with BreadcrumbAware {
  @override
  Map<String, String> get breadcrumbLabels => {
    '/event-categories': 'Categorie Eventi',
    '/event-categories/new': 'Nuova Categoria',
  };

  @override
  CLRoute get moduleRoute => EventCategoryRoutes.eventCategoriesModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(
          route: EventCategoryRoutes.eventCategories,
          childBuilder: (context, state) => const EventCategoryPage(),
          isModuleRoute: true,
          routes: [
            // Route figlie di Categorie Evento (annidate)
            ChildRoute.build(
                route: EventCategoryRoutes.viewEventCategory,
                childBuilder: (context, state) => ViewEventCategoryPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: EventCategoryRoutes.editEventCategory,
                childBuilder: (context, state) => EditEventCategoryPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: EventCategoryRoutes.newEventCategory,
                childBuilder: (context, state) => const NewEventCategoryPage(),
                isVisible: false),
          ],
        ),
      ];
}
