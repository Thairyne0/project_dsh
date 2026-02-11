import 'package:provider/provider.dart';
import 'package:project_dsh/modules/store/constants/store_routes.constant.dart';
import 'package:project_dsh/ui/widgets/buttons/cl_button.widget.dart';
import 'package:project_dsh/ui/widgets/loading.widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../ui/cl_theme.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../ui/widgets/buttons/cl_action_text.widget.dart';
import '../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../ui/widgets/table_action_item.widget.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/providers/appstate.util.provider.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../../users/constants/permission_slug.dart';
import '../models/store.model.dart';
import '../modules/brand/constants/brand_routes.costant.dart';
import '../viewmodels/store.viewmodel.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<StoreViewModel>.reactive(
        viewModelBuilder: () => StoreViewModel(context, VMType.list, null),
        onViewModelReady: (vm) async => await vm.initialize(),
        builder: (context, vm, child) {
          if (appState.shouldRefresh) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await vm.initialize();
              appState.reset();
            });
          }
          return vm.isBusy
              ? LoadingWidget()
              : CustomScrollView(
              slivers: [
          SliverPadding(
          padding: const EdgeInsets.only(top: Sizes.headerOffset),
          sliver: SliverToBoxAdapter(
          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:Sizes.padding, right: Sizes.padding, bottom: Sizes.padding),
                        child: PagedDataTable<String, String, Store>(
                          rowsSelectable: false,
                          idGetter: (store) => store.id,
                          controller: vm.storeTableController,
                          refreshListener: appState.refreshList,
                          fetchPage: vm.getAllStore,
                          initialPage: "1",
                          initialPageSize: 25,
                          onItemTap: (item) {
                            if (authState.hasPermission(PermissionSlugs.dettaglioStore))
                              context.customGoNamed(StoreRoutes.viewStore.name, params: {"id": item.id});
                          },
                          actionsBuilder: (item) => [
                            if (authState.hasPermission(PermissionSlugs.updateStore))
                              TableAction<Store>(
                              content: TableActionItem(name: "Modifica", iconData: Icons.edit),
                              onTap: (item) {
                                context.customGoNamed(StoreRoutes.editStore.name, params: {"id": item.id});
                              },
                            )
                          ],
                          columns: [
                            /*TableColumn(
                              id: "media",
                              title: const Text("Media"),
                              sortable: false,
                              cellBuilder: (item) => CLMediaViewer(
                                medias: [CLMedia(fileUrl: item.imageUrl)],
                                clMediaViewerMode: CLMediaViewerMode.tableMode,
                                resourceName: item.name,
                              ),
                              sizeFactor: .07,
                              isMain: false,
                            ),*/

                            TableColumn(
                              id: "brand:name",
                              title: const Text("Brand"),
                              sortable: true,
                              cellBuilder: (item) => CLActionText.primary(
                                  text: item.brand.name,
                                  onTap: () {
                                    if (authState.hasPermission(PermissionSlugs.dettaglioBrand))
                                      context.customGoNamed(BrandRoutes.viewBrand.name, params: {"id": item.brand.id});
                                  },
                                  context: context),
                              sizeFactor: .2,
                            ),
                            TableColumn(
                                id: "name",
                                title: const Text("Ragione sociale"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                  item.name,
                                  style: CLTheme.of(context).bodyText,
                                ),
                                sizeFactor: .2,
                                isMain: false),
                            TableColumn(
                                id: "piva",
                                title: const Text("Partita IVA"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                  item.piva,
                                  style: CLTheme.of(context).bodyText,
                                ),
                                sizeFactor: .15,
                                isMain: false),
                            TableColumn(
                              id: "email",
                              title: const Text("Email"),
                              sortable: true,
                              cellBuilder: (item) => Text(item.email,style: CLTheme.of(context).bodyText,),
                              sizeFactor: .2,
                            ),
                            TableColumn(
                              id: "phone",
                              title: const Text("Telefono"),
                              sortable: true,
                              cellBuilder: (item) => Text(item.phone,style: CLTheme.of(context).bodyText,),
                              sizeFactor: .1,
                            ),

                          ],
                          mainFilter: TextTableFilter(
                            id: "name",
                            title: "Ragione sociale",
                            isMainFilter: true,
                            chipFormatter: (text) => text,
                          ),
                          extraFilters: [
                            TextTableFilter(
                              id: "piva",
                              title: "Partita IVA",
                              chipFormatter: (text) => text,
                            ),
                            TextTableFilter(
                              id: "brand:name",
                              title: "Brand",
                              chipFormatter: (text) => text,
                            ),
                          ],
                          mainMenus: [
                            if (authState.hasPermission(PermissionSlugs.creazioneStore))
                              CLButton.primary(
                                text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                onTap: () {
                                  context.customGoNamed(StoreRoutes.newStore.name);
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
