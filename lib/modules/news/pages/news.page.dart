import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../ui/widgets/table_action_item.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../constants/news_routes.costant.dart';
import '../models/news.model.dart';
import '../viewmodels/news.viewmodel.dart';


class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<NewsViewModel>.reactive(
        viewModelBuilder: () => NewsViewModel(context, VMType.list, null),
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
              :  CustomScrollView(
              slivers: [
          SliverPadding(
          padding: const EdgeInsets.only(top: Sizes.headerOffset),
          sliver: SliverToBoxAdapter(
          child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                          child: PagedDataTable<String, String, News>(
                            rowsSelectable: false,
                            idGetter: (news) => news.id,
                            controller: vm.newsTableController,
                            fetchPage: vm.getAllNews,
                            refreshListener: appState.refreshList,
                            initialPage: "1",
                            initialPageSize: 25,
                            onItemTap: (item) {
                                context.customGoNamed(NewsRoutes.viewNews.name, params: {"id": item.id});
                            },
                            actionsBuilder: (item) => [
                                TableAction<News>(
                                content: TableActionItem(name: "Modifica", iconData: Icons.edit),
                                onTap: (item) {
                                  context.customGoNamed(NewsRoutes.editNews.name, params: {"id": item.id});
                                },
                              )
                            ],
                            columns: [
                              TableColumn(
                                id: "media",
                                title: const Text("Media"),
                                sortable: false,
                                cellBuilder: (item) => CLMediaViewer(
                                  medias: [
                                    CLMedia(fileUrl: item.imageUrl)
                                  ],
                                  clMediaViewerMode: CLMediaViewerMode.tableMode,
                                  resourceName: item.title,
                                ),
                                sizeFactor: .08,
                                isMain: false,
                              ),
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
                                  id: "isHighlighted",
                                  title: const Text("In evidenza"),
                                  sortable: true,
                                  cellBuilder: (item) => Text(
                                    item.isHighlighted? "Si" : "No",
                                    style: CLTheme.of(context).bodyText,
                                  ),
                                  sizeFactor: .1,
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
                                    context.customGoNamed(NewsRoutes.newNews.name);
                                  },
                                  context: context,
                                  icon: Icons.add,
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))]);
        });
  }
}
