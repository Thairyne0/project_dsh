import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_tabs/cl_tab_item.model.dart';
import '../../../../../ui/widgets/cl_tabs/cl_tab_view.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../ui/widgets/table_action_item.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../../../../users/constants/permission_slug.dart';
import '../../../models/store_category_pivot.model.dart';
import '../constants/store_category_routes.constant.dart';
import '../viewmodels/store_category.viewmodel.dart';

class ViewStoreCategoryPage extends StatefulWidget {
  const ViewStoreCategoryPage({super.key, required this.id});

  final String id;

  @override
  State<ViewStoreCategoryPage> createState() => _ViewStoreCategoryPageState();
}

class _ViewStoreCategoryPageState extends State<ViewStoreCategoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = context.read<AuthState>();
    return ViewModelBuilder<StoreCategoryViewModel>.reactive(
        viewModelBuilder: () => StoreCategoryViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          if (authState.hasPermission(PermissionSlugs.updateCategoriaStore))
            PageAction(
                  title: "Modifica",
                  isMain: true,
                  iconData: Icons.edit,
                  onTap: () async {
                    context.customGoNamed(StoreCategoryRoutes.editStoreCategory.name, params: {"id": widget.id});
                  }),
          if (authState.hasPermission(PermissionSlugs.rimozioneCategoriaStore))
            PageAction(
                  title: "Elimina",
                  isMain: true,
                  isSecondary: true,
                  needConfirmation: true,
                  iconData: Icons.delete,
                  onTap: () async {
                    await vm.deleteStoreCategory(widget.id);
                    appState.refreshList.add(true);
                    context.pop();
                  }),
            ]),
        builder: (context, vm, child) {
          return vm.isBusy
              ? const LoadingWidget()
              : CustomScrollView(
              slivers: [
          SliverPadding(
          padding: const EdgeInsets.only(top: Sizes.headerOffset),
          sliver: SliverToBoxAdapter(
          child: Form(
                    child: Column(
                      children: [
                        CLContainer(
                          contentMargin: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveGrid(
                                gridSpacing: Sizes.padding,
                                mainAxisAlignment: MainAxisAlignment.start,
                                showHorizontalDivider: true,
                                children: [
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Nome", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.storeCategory.name}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minTileHeight: 0,
                                        title: Text("Logo", style: CLTheme.of(context).bodyLabel),
                                        subtitle: CLMediaViewer(
                                          clMediaViewerMode: CLMediaViewerMode.previewMode,
                                          medias: [
                                            CLMedia(
                                              fileUrl: vm.storeCategory.imageUrl,
                                            )
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Sizes.padding),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                          child: CLTabView(clTabItems: [
                            CLTabItem(
                                tabName: "Store",
                                tabContent: Center(
                                    child: PagedDataTable<String, String, StoreCategoryPivot>(
                                      rowsSelectable: false,
                                      idGetter: (storeCategoryPivot) => storeCategoryPivot.id,
                                      controller: vm.storeCategoryPivotTableController,
                                      fetchPage: vm.getAllStoreCategoryPivot,
                                      initialPage: "1",
                                      initialPageSize: 25,
                                      onItemTap: (item) {
                                        if (authState.hasPermission(PermissionSlugs.dettaglioCategoriaStore))
                                          context.customGoNamed(StoreCategoryRoutes.viewStoreCategory.name, params: {"id": item.storeCategory.id}, replacedRouteName: item.modelIdentifier);
                                      },
                                      actionsBuilder: (item) => [
                                        if (authState.hasPermission(PermissionSlugs.allegaCategoriaStore))
                                          TableAction<StoreCategoryPivot>(
                                          content: TableActionItem(name: 'Rimuovi', iconData: Icons.delete_outline_rounded),
                                          onTap: (item) async {
                                            await vm.detachStoreFromStoreCategory(item.id);
                                          },
                                        ),
                                      ],
                                      columns: [
                                        TableColumn(
                                            id: "store:name",
                                            title: const Text("Nome"),
                                            sortable: true,
                                            cellBuilder: (item) => Text(
                                              item.store.name.toString(),
                                              style: CLTheme.of(context).bodyText,
                                            ),
                                            sizeFactor: .2,
                                            isMain: false),
                                      ],
                                      mainFilter: TextTableFilter(
                                        id: "store:name",
                                        title: "Nome",
                                        isMainFilter: true,
                                        chipFormatter: (text) => text,
                                      ),
                                      extraFilters: [],
                                      mainMenus: [
                                        if (authState.hasPermission(PermissionSlugs.allegaCategoriaStore))
                                          CLButton.primary(
                                            text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                            onTap: () {
                                              context.customGoNamed(StoreCategoryRoutes.addStoreToStoreCategory.name, params: {"id": widget.id},);
                                            },
                                            context: context,
                                            icon: Icons.add),
                                      ],
                                    ))),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ))]);
        });
  }
}
