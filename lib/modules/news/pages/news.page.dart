import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/cl_pill.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../ui/widgets/table_action_item.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
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
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: Sizes.headerOffset),
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.padding * 1.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Section
                              Padding(
                                padding: const EdgeInsets.only(bottom: Sizes.padding * 1.5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'News',
                                          style: CLTheme.of(context).title.copyWith(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Gestione degli articoli e comunicazioni',
                                          style: CLTheme.of(context).bodyText.copyWith(
                                            color: CLTheme.of(context).bodyText.color?.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
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
                              ),
                              // Tabella
                              CLContainer(
                                contentPadding: EdgeInsets.zero,
                                child: PagedDataTable<String, String, News>(
                                  rowsSelectable: false,
                                  idGetter: (news) => news.id,
                                  controller: vm.newsTableController,
                                  fetchPage: vm.getAllNews,
                                  refreshListener: appState.refreshList,
                                  initialPage: "1",
                                  initialPageSize: 25,
                                  showBorder: false,
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
                                        medias: [CLMedia(fileUrl: item.imageUrl)],
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
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      sizeFactor: .32,
                                      isMain: false,
                                    ),
                                    TableColumn(
                                      id: "startingAt",
                                      title: const Text("Inizio"),
                                      sortable: true,
                                      cellBuilder: (item) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.startingAtDate.toString().split(" ")[0],
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                          if (item.startingAtDate.toString().split(" ").length > 1)
                                            Text(
                                              item.startingAtDate.toString().split(" ")[1],
                                              style: CLTheme.of(context).smallLabel,
                                            ),
                                        ],
                                      ),
                                      sizeFactor: .15,
                                      isMain: false,
                                    ),
                                    TableColumn(
                                      id: "endingAt",
                                      title: const Text("Fine"),
                                      sortable: true,
                                      cellBuilder: (item) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.endingAtDate.toString().split(" ")[0],
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                          if (item.endingAtDate.toString().split(" ").length > 1)
                                            Text(
                                              item.endingAtDate.toString().split(" ")[1],
                                              style: CLTheme.of(context).smallLabel,
                                            ),
                                        ],
                                      ),
                                      sizeFactor: .15,
                                      isMain: false,
                                    ),
                                    TableColumn(
                                      id: "isHighlighted",
                                      title: const Text("In evidenza"),
                                      sortable: true,
                                      cellBuilder: (item) => CLPill(
                                        pillText: item.isHighlighted ? "Sì" : "No",
                                        pillColor: item.isHighlighted
                                            ? CLTheme.of(context).success
                                            : CLTheme.of(context).secondaryText,
                                      ),
                                      sizeFactor: .12,
                                      isMain: false,
                                    ),
                                  ],
                                  mainFilter: TextTableFilter(
                                    id: "title",
                                    title: "Titolo",
                                    isMainFilter: true,
                                    chipFormatter: (text) => text,
                                  ),
                                  extraFilters: [],
                                  mainMenus: const [],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        });
  }
}
