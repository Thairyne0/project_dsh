import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../ui/widgets/table_action_item.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../constants/announcement_routes.costant.dart';
import '../models/announcement.model.dart';
import '../viewmodels/announcement.viewmodel.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => AnnouncementPageState();
}

class AnnouncementPageState extends State<AnnouncementPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<AnnouncementViewModel>.reactive(
        viewModelBuilder: () => AnnouncementViewModel(context, VMType.list, null),
        onViewModelReady: (vm) async => await vm.initialize(),
        builder: (context, vm, child) {
          if (appState.shouldRefresh) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await vm.initialize();
              appState.reset();
            });
          }
          return vm.isBusy
              ? const LoadingWidget()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                        child: PagedDataTable<String, String, Announcement>(
                          rowsSelectable: false,
                          idGetter: (announcement) => announcement.id,
                          controller: vm.announcementTableController,
                          fetchPage: vm.getAllAnnouncement,
                          refreshListener: appState.refreshList,
                          initialPage: "1",
                          initialPageSize: 25,
                          onItemTap: (item) {
                              context.customGoNamed(AnnouncementRoutes.viewAnnouncement.name, params: {"id": item.id});
                          },
                          actionsBuilder: (item) => [
                              TableAction<Announcement>(
                              content: TableActionItem(name: "Modifica", iconData: Icons.edit),
                              onTap: (item) {
                                  context.customGoNamed(AnnouncementRoutes.editAnnouncement.name, params: {"id": item.id});
                              },
                            )
                          ],
                          columns: [
                            TableColumn(
                                id: "media",
                                title: const Text("Media"),
                                sortable: false,
                                cellBuilder: (item) => CLMediaViewer(
                                      medias: item.mediaUrls
                                          .map((url) => CLMedia(
                                                fileUrl: url,
                                              ))
                                          .toList(),
                                      clMediaViewerMode: CLMediaViewerMode.tableMode,
                                      resourceName: item.modelIdentifier,
                                    ),
                                sizeFactor: .1,
                                isMain: false),
                            TableColumn(
                                id: "title",
                                title: const Text("Titolo"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.title,
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .3,
                                isMain: false),
                          ],
                          mainFilter: TextTableFilter(
                            id: "title",
                            title: "Titolo",
                            isMainFilter: true,
                            chipFormatter: (text) => text,
                          ),
                          extraFilters: [],
                          mainMenus: [
                              CLButton.primary(
                              text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                              onTap: () {
                                context.customGoNamed(AnnouncementRoutes.newAnnouncement.name);
                              },
                              context: context,
                              icon: Icons.add,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
        });
  }
}
