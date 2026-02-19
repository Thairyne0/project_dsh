import 'package:project_dsh/modules/announcement/pages/announcement.page.dart';
import 'package:project_dsh/modules/announcement/pages/edit_announcement.page.dart';
import 'package:project_dsh/modules/announcement/pages/new_announcement.page.dart';
import 'package:project_dsh/modules/announcement/pages/view_announcement.page.dart';
import '../../../../utils/go_router_modular/module.dart';
import '../../../../utils/go_router_modular/routes/child_route.dart';
import '../../../../utils/go_router_modular/routes/cl_route.dart';
import '../../../../utils/go_router_modular/routes/i_modular_route.dart';
import 'constants/announcement_routes.costant.dart';
import 'package:project_dsh/utils/go_router_modular/breadcrumb.system.dart';


class AnnouncementModule extends Module with BreadcrumbAware {
  @override
  Map<String, String> get breadcrumbLabels => {
    '/announcements': 'Annunci',
    '/announcements/new': 'Nuovo Annuncio',
  };

  @override
  CLRoute get moduleRoute => AnnouncementRoutes.announcementModule;

  @override
  List<ModularRoute> get routes => [
        ChildRoute.build(route: AnnouncementRoutes.announcement, childBuilder: (context, state) => const AnnouncementPage(), isModuleRoute: true,),
        ChildRoute.build(route: AnnouncementRoutes.viewAnnouncement, childBuilder: (context, state) => ViewAnnouncementPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
        ChildRoute.build(route: AnnouncementRoutes.editAnnouncement, childBuilder: (context, state) => EditAnnouncementPage(id: state.pathParameters["id"]!), params: ["id"], isVisible: false),
        ChildRoute.build(route: AnnouncementRoutes.newAnnouncement, childBuilder: (context, state) => NewAnnouncementPage(), isVisible: false),
      ];
}
