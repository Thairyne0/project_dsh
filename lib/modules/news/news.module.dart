import 'package:project_dsh/modules/news/pages/edit_news.page.dart';
import 'package:project_dsh/modules/news/pages/new_news.page.dart';
import 'package:project_dsh/modules/news/pages/news.page.dart';
import 'package:project_dsh/modules/news/pages/view_news.page.dart';
import '../../../../utils/go_router_modular/module.dart';
import '../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/news_routes.costant.dart';


class NewsModule extends Module {
  @override
  CLRoute get moduleRoute => NewsRoutes.newsModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(route: NewsRoutes.news, childBuilder: (context, state) => const NewsPage(), isModuleRoute: true),
        ChildRoute.build(
            route: NewsRoutes.viewNews, childBuilder: (context, state) => ViewNewsPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
        ChildRoute.build(
            route: NewsRoutes.editNews, childBuilder: (context, state) => EditNewsPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
        ChildRoute.build(route: NewsRoutes.newNews, childBuilder: (context, state) => NewNewsPage(), isVisible: false),
      ];
}
