import '../../../../../utils/go_router_modular/routes/cl_route.dart';
class AnnouncementRoutes {
  static final CLRoute announcementModule = CLRoute(name: "Gestione Comunicazioni Interne", path: "/announcements");
  static final CLRoute announcement = CLRoute(name: "Comunicazioni Interne", path: "/");
  static final CLRoute viewAnnouncement = CLRoute(name: "Dettaglio Comunicazioni Interne", path: "/announcement-details");
  static final CLRoute editAnnouncement = CLRoute(name: "Modifica Comunicazioni Interne", path: "/announcement-edit");
  static final CLRoute newAnnouncement = CLRoute(name: "Aggiungi Comunicazioni Interne", path: "/announcement-new");
}
