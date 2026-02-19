import 'package:project_dsh/modules/store/modules/store_category/pages/add_store_to_store_category.page.dart';
import 'package:project_dsh/modules/store/modules/store_category/pages/edit_store_category.page.dart';
import 'package:project_dsh/modules/store/modules/store_category/pages/new_store_category.page.dart';
import 'package:project_dsh/modules/store/modules/store_category/pages/store_category.page.dart';
import 'package:project_dsh/modules/store/modules/store_category/pages/view_store_category.page.dart';

import '../../../../utils/go_router_modular/module.dart';
import '../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/store_category_routes.constant.dart';
import 'package:project_dsh/utils/go_router_modular/breadcrumb.system.dart';

class StoreCategoryModule extends Module with BreadcrumbAware {
  @override
  Map<String, String> get breadcrumbLabels => {
    '/store/categories': 'Categorie Negozi',
    '/store/categories/new': 'Nuova Categoria',
  };

  @override
  CLRoute get moduleRoute => StoreCategoryRoutes.storeCategoriesModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(
          route: StoreCategoryRoutes.storeCategories,
          childBuilder: (context, state) => const StoreCategoryPage(),
          isModuleRoute: true,
          routes: [
            // Route figlie di Categorie Store (annidate)
            ChildRoute.build(
                route: StoreCategoryRoutes.viewStoreCategory,
                childBuilder: (context, state) => ViewStoreCategoryPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: StoreCategoryRoutes.editStoreCategory,
                childBuilder: (context, state) => EditStoreCategoryPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
            ChildRoute.build(
                route: StoreCategoryRoutes.newStoreCategory,
                childBuilder: (context, state) => const NewStoreCategoryPage(),
                isVisible: false),
            ChildRoute.build(
                route: StoreCategoryRoutes.addStoreToStoreCategory,
                childBuilder: (context, state) => AddStoreToStoreCategoryPage(id: state.pathParameters["id"]!),
                params: ["id"],
                isVisible: false),
          ],
        ),
      ];
}
