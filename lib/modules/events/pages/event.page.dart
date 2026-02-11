import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/widgets/table_action_item.widget.dart';
import 'package:project_dsh/utils/extension.util.dart';
import 'package:project_dsh/utils/providers/appstate.util.provider.dart';
import '../../../../ui/cl_theme.dart';
import '../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../ui/widgets/loading.widget.dart';
import '../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../utils/base.viewmodel.dart';
import '../../../ui/widgets/buttons/cl_action_text.widget.dart';
import '../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../ui/widgets/cl_pill.widget.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../constants/event_routes.constant.dart';
import '../models/event.model.dart';
import '../viewmodels/event.viewmodel.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<EventViewModel>.reactive(
        viewModelBuilder: () => EventViewModel(context, VMType.list, null),
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
              : CustomScrollView(
              slivers: [
          SliverPadding(
          padding: const EdgeInsets.only(top: Sizes.headerOffset),
          sliver: SliverToBoxAdapter(
          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                        child: PagedDataTable<String, String, Event>(
                          rowsSelectable: false,
                          idGetter: (event) => event.id,
                          controller: vm.eventTableController,
                          fetchPage: vm.getAllEvent,
                          initialPage: "1",
                          refreshListener: appState.refreshList,
                          initialPageSize: 25,
                          onItemTap: (item) {
                              context.customGoNamed(EventRoutes.viewEvent.name, params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                          },
                          actionsBuilder: (item) => [
                              TableAction<Event>(
                                content: TableActionItem(name: "Modifica", iconData: Icons.edit),
                                onTap: (item) {
                                  context.customGoNamed(EventRoutes.editEvent.name, params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                                },
                              ),
                            /*if (authState.hasPermission(PermissionSlugs.rimozioneEvento))
                                  TableAction<Event>(
                                    content: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      hoverColor: Colors.transparent,
                                      leading: Icon(Icons.delete, size: Sizes.medium, color: CLTheme.of(context).primaryText),
                                      title: Text("Elimina", style: CLTheme.of(context).bodyText),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: Sizes.small, color: CLTheme.of(context).primaryText),
                                    ),
                                    onTap: (item) {
                                      vm.deleteEvent(item.id);
                                      appState.refreshList.add(true);
                                    },
                                  ),*/
                              TableAction<Event>(
                                content: TableActionItem(name: "Approvato", iconData: Icons.check_circle_outline, iconColor: CLTheme.of(context).success),
                                onTap: (item) {
                                  vm.updateEventStatus(item.id, 1);
                                },
                              ),
                              TableAction<Event>(
                                content: TableActionItem(name: "Non Approvato", iconData: Icons.cancel_outlined, iconColor: CLTheme.of(context).danger),
                                onTap: (item) {
                                  vm.updateEventStatus(item.id, 2);
                                },
                              ),
                              TableAction<Event>(
                                content: TableActionItem(name: "In Attesa", iconData: Icons.watch_later_outlined, iconColor: CLTheme.of(context).warning),
                                onTap: (item) {
                                  vm.updateEventStatus(item.id, 0);
                                },
                              ),
                          ],
                          columns: [
                            TableColumn(
                              id: "media",
                              title: const Text("Media"),
                              sortable: false,
                              cellBuilder: (item) => CLMediaViewer(
                                medias: [CLMedia(fileUrl: item.imageUrl)],
                                clMediaViewerMode: CLMediaViewerMode.tableMode,
                                resourceName: item.title,
                              ),
                              sizeFactor: .07,
                              isMain: false,
                            ),
                            TableColumn(
                                id: "title",
                                title: const Text("Titolo"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.title.toString(),
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .14,
                                isMain: false),
                            TableColumn(
                                id: "startingAt",
                                title: const Text("Inizio"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.startingAtDate.toString(),
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .15,
                                isMain: false),
                            TableColumn(
                                id: "endingAt",
                                title: const Text("Fine"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.endingAtDate.toString(),
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .15,
                                isMain: false),
                            TableColumn(
                                id: "store:name",
                                title: const Text("Store"),
                                sortable: true,
                                cellBuilder: (item) => CLActionText.primary(
                                    text: "",
                                    onTap: () {
                                    },
                                    context: context),
                                sizeFactor: .15,
                                isMain: false),
                            TableColumn(
                              id: "status",
                              title: const Text("Status"),
                              sortable: true,
                              cellBuilder: (item) {
                                Color statusColor;
                                String statusText;
                                IconData statusIcon;
                                switch (item.status.value) {
                                  case 0:
                                    statusColor = CLTheme.of(context).warning;
                                    statusText = "In attesa";
                                    statusIcon = Icons.watch_later;
                                    break;
                                  case 1:
                                    statusColor = CLTheme.of(context).success;
                                    statusText = "Approvato";
                                    statusIcon = Icons.check_circle;
                                    break;
                                  case 2:
                                    statusColor = CLTheme.of(context).danger;
                                    statusText = "Non approvato";
                                    statusIcon = Icons.cancel;
                                    break;
                                  default:
                                    statusColor = Colors.grey;
                                    statusText = "Sconosciuto";
                                    statusIcon = Icons.help;
                                }
                                return CLPill(
                                  pillColor: statusColor,
                                  pillText: statusText,
                                  icon: statusIcon,
                                );
                              },
                              sizeFactor: .15,
                              isMain: false,
                            ),
                            TableColumn(
                                id: "isBuyable",
                                title: Tooltip(
                                  message: "Acquistabile?",
                                  child: Align(
                                      alignment: Alignment.centerLeft, child: Icon(Icons.monetization_on_rounded, color: CLTheme.of(context).secondaryText)),
                                ),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.isBuyable ? "Si" : "No",
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: 0.05,
                                isMain: false),
                            TableColumn(
                                id: "additionalPurchase",
                                title: Tooltip(
                                    message: "È collegato all'acquisto in negozio?",
                                    child: Align(alignment: Alignment.centerLeft, child: Icon(Icons.shopping_cart, color: CLTheme.of(context).secondaryText))),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.additionalPurchase ? "Si" : "No",
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: 0.05,
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
                                    context.customGoNamed(EventRoutes.newEvent.name);
                                  },
                                  context: context,
                                  icon: Icons.add),
                          ],
                        ),
                      )
                    ],
                  ),
                ))]);
        });
  }
}
