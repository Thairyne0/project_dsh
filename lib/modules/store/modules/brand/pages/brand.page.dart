import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/modules/users/constants/permission_slug.dart';
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
import '../constants/brand_routes.costant.dart';
import '../models/brand.model.dart';
import '../viewmodels/brand.viewmodel.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<BrandViewModel>.reactive(
        viewModelBuilder: () => BrandViewModel(context, VMType.list, null),
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
                          child: PagedDataTable<String, String, Brand>(
                            rowsSelectable: false,
                            idGetter: (brand) => brand.id,
                            controller: vm.brandTableController,
                            fetchPage: vm.getAllBrand,
                            refreshListener: appState.refreshList,
                            initialPage: "1",
                            initialPageSize: 25,
                            onItemTap: (item) {
                              if (authState.hasPermission(PermissionSlugs.dettaglioBrand)) {
                                context.customGoNamed(BrandRoutes.viewBrand.name, params: {"id": item.id});
                              }
                            },
                            actionsBuilder: (item) => [
                              if (authState.hasPermission(PermissionSlugs.updateBrand))
                                TableAction<Brand>(
                                content: TableActionItem(name: "Modifica", iconData: Icons.edit),
                                onTap: (item) {
                                  context.customGoNamed(BrandRoutes.editBrand.name, params: {"id": item.id});
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
                                  resourceName: item.name,
                                ),
                                sizeFactor: .08,
                                isMain: false,
                              ),
                              TableColumn(
                                  id: "name",
                                  title: const Text("Nome"),
                                  sortable: true,
                                  cellBuilder: (item) => Text(
                                        item.name,
                                        style: CLTheme.of(context).bodyText,
                                      ),
                                  sizeFactor: .3,
                                  isMain: false),
                              TableColumn(
                                  id: "description",
                                  title: const Text("Descrizione"),
                                  sortable: true,
                                  cellBuilder: (item) => Text(
                                        item.description,
                                        style: CLTheme.of(context).bodyText,
                                      ),
                                  sizeFactor: .3,
                                  isMain: false),
                            ],
                            mainFilter: TextTableFilter(
                              id: "name",
                              title: "Nome",
                              isMainFilter: true,
                              chipFormatter: (text) => text,
                            ),
                            extraFilters: [],
                            mainMenus: [
                                if (authState.hasPermission(PermissionSlugs.creazioneBrand))
                                CLButton.primary(
                                  text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                  onTap: () {
                                    context.customGoNamed(BrandRoutes.newBrand.name);
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
