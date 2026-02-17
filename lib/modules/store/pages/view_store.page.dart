import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/modules/store/models/store_category_pivot.model.dart';
import 'package:project_dsh/modules/users/constants/users_routes.constants.dart';
import 'package:project_dsh/modules/users/models/store_employee.dart';
import 'package:project_dsh/ui/widgets/buttons/cl_action_text.widget.dart';
import 'package:project_dsh/ui/widgets/cl_tabs/cl_tab_view.widget.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../ui/cl_theme.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../ui/widgets/cl_container.widget.dart';
import '../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../ui/widgets/cl_tabs/cl_tab_item.model.dart';
import '../../../ui/widgets/loading.widget.dart';
import '../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../ui/widgets/table_action_item.widget.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/models/pageaction.model.dart';
import '../../../utils/providers/appstate.util.provider.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../../users/constants/permission_slug.dart';
import '../modules/brand/constants/brand_routes.costant.dart';
import '../modules/location/constants/location_routes.constant.dart';
import '../modules/location/models/location.model.dart';
import '../modules/promo/constants/promo_routes.constant.dart';
import '../modules/promo/models/promo.model.dart';
import '../constants/store_routes.constant.dart';
import '../modules/store_category/constants/store_category_routes.constant.dart';
import '../modules/store_report/constants/store_report_routes.constant.dart';
import '../modules/store_report/models/store_report.model.dart';
import '../viewmodels/store.viewmodel.dart';

class ViewStorePage extends StatefulWidget {
  const ViewStorePage({super.key, required this.id});

  final String id;

  @override
  State<ViewStorePage> createState() => _ViewStorePageState();
}

class _ViewStorePageState extends State<ViewStorePage> {
  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = context.read<AuthState>();
    return ViewModelBuilder<StoreViewModel>.reactive(
        viewModelBuilder: () => StoreViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          if (authState.hasPermission(PermissionSlugs.updateStore))
            PageAction(
                  title: "Modifica",
                  isMain: true,
                  iconData: Icons.edit,
                  onTap: () async {
                    context.customGoNamed(StoreRoutes.editStore.name, params: {"id": widget.id}, replacedRouteName: vm.store.modelIdentifier);
                  }),
          if (authState.hasPermission(PermissionSlugs.rimozioneStore))
            PageAction(
                  title: "Elimina",
                  isMain: true,
                  isSecondary: true,
                  needConfirmation: true,
                  iconData: Icons.delete,
                  onTap: () async {
                    await vm.deleteStore(widget.id);
                    appState.refreshList.add(true);
                    context.pop();
                  }),
            ]),
        builder: (context, vm, child) {
          return vm.isBusy
              ? LoadingWidget()
              : CustomScrollView(
              slivers: [
          SliverPadding(
          padding: const EdgeInsets.only(top: Sizes.headerOffset),
          sliver: SliverToBoxAdapter(
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
                                      title: Text("Brand", style: CLTheme.of(context).bodyLabel),
                                      subtitle: CLActionText.primary(
                                        text: vm.store.brand.name,
                                        onTap: () {
                                          if (authState.hasPermission(PermissionSlugs.dettaglioBrand)) {
                                            context.customGoNamed(BrandRoutes.viewBrand.name, params: {"id": vm.store.brand.id});
                                          }
                                        },
                                        context: context,
                                      )),
                                ),
                                ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Ragione sociale", style: CLTheme.of(context).bodyLabel),
                                    subtitle: Text(vm.store.name, style: CLTheme.of(context).bodyText),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Email", style: CLTheme.of(context).bodyLabel),
                                    subtitle: Text(vm.store.email, style: CLTheme.of(context).bodyText),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("PEC", style: CLTheme.of(context).bodyLabel),
                                    subtitle: Text(vm.store.pec, style: CLTheme.of(context).bodyText),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 33,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Telefono", style: CLTheme.of(context).bodyLabel),
                                    subtitle: Text(vm.store.phone, style: CLTheme.of(context).bodyText),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 33,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Partita IVA", style: CLTheme.of(context).bodyLabel),
                                    subtitle: Text(vm.store.piva, style: CLTheme.of(context).bodyText),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 33,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Indirizzo Legale", style: CLTheme.of(context).bodyLabel),
                                    subtitle: Text(vm.store.legalAddress, style: CLTheme.of(context).bodyText),
                                  ),
                                ),

                                /*ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Logo", style: CLTheme.of(context).bodyLabel),
                                      CLMediaViewer(
                                        clMediaViewerMode: CLMediaViewerMode.previewMode,
                                        medias: [
                                          CLMedia(
                                            fileUrl: vm.store.imageUrl,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),*/

                                //lunedì
                                ResponsiveGridItem(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      tilePadding: EdgeInsets.symmetric(horizontal: 0),
                                      title: Text(
                                        "Orari Settimanali",
                                        style: CLTheme.of(context).subTitle.merge(TextStyle(color: CLTheme.of(context).primary)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      children: [
                                        if (ResponsiveBreakpoints.of(context).isDesktop) ...[
                                          ResponsiveGrid(
                                            children: [
                                              ResponsiveGridItem(
                                                  lg: 20,
                                                  xs: 100,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "",
                                                          style: CLTheme.of(context).subTitle,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              ResponsiveGridItem(
                                                  lg: 20,
                                                  xs: 100,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Apetura Mattina",
                                                          style: CLTheme.of(context).subTitle,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              ResponsiveGridItem(
                                                  lg: 20,
                                                  xs: 100,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Chiusura Mattina",
                                                          style: CLTheme.of(context).subTitle,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              ResponsiveGridItem(
                                                  lg: 20,
                                                  xs: 100,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Apertura Pomeriggio",
                                                          style: CLTheme.of(context).subTitle,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              ResponsiveGridItem(
                                                  lg: 20,
                                                  xs: 100,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Chiusura Pomeriggio",
                                                          style: CLTheme.of(context).subTitle,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ],
                                        ResponsiveGrid(
                                          children: vm.store.weeklySchedule.isNotEmpty
                                              ? vm.store.weeklySchedule
                                                  .map((daySchedule) => [
                                                        ResponsiveGridItem(
                                                          lg: 20,
                                                          xs: 100,
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  _getDayName(daySchedule.id),
                                                                  style: CLTheme.of(context).subTitle,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        ResponsiveGridItem(
                                                          lg: 20,
                                                          xs: 100,
                                                          child: ListTile(
                                                            contentPadding: EdgeInsets.zero,
                                                            minTileHeight: 0,
                                                            title: Text("", style: CLTheme.of(context).bodyLabel),
                                                            subtitle: Text(
                                                              daySchedule.morningOpening?.format(context) ?? 'N/A',
                                                              style: CLTheme.of(context).bodyText,
                                                            ),
                                                          ),
                                                        ),
                                                        ResponsiveGridItem(
                                                          lg: 20,
                                                          xs: 100,
                                                          child: ListTile(
                                                            contentPadding: EdgeInsets.zero,
                                                            minTileHeight: 0,
                                                            title: Text("", style: CLTheme.of(context).bodyLabel),
                                                            subtitle: Text(
                                                              daySchedule.morningClosing?.format(context) ?? 'N/A',
                                                              style: CLTheme.of(context).bodyText,
                                                            ),
                                                          ),
                                                        ),
                                                        ResponsiveGridItem(
                                                          lg: 20,
                                                          xs: 100,
                                                          child: ListTile(
                                                            contentPadding: EdgeInsets.zero,
                                                            minTileHeight: 0,
                                                            title: Text("", style: CLTheme.of(context).bodyLabel),
                                                            subtitle: Text(
                                                              daySchedule.eveningOpening?.format(context) ?? 'N/A',
                                                              style: CLTheme.of(context).bodyText,
                                                            ),
                                                          ),
                                                        ),
                                                        ResponsiveGridItem(
                                                          lg: 20,
                                                          xs: 100,
                                                          child: ListTile(
                                                            contentPadding: EdgeInsets.zero,
                                                            minTileHeight: 0,
                                                            title: Text("", style: CLTheme.of(context).bodyLabel),
                                                            subtitle: Text(
                                                              daySchedule.eveningClosing?.format(context) ?? 'N/A',
                                                              style: CLTheme.of(context).bodyText,
                                                            ),
                                                          ),
                                                        ),
                                                      ])
                                                  .expand((i) => i)
                                                  .toList()
                                              : [
                                                  ResponsiveGridItem(
                                                    xs: 100,
                                                    child: Center(
                                                      child: Text(
                                                        "Nessun orario disponibile",
                                                        style: CLTheme.of(context).bodyText,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Sizes.padding),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                        child: CLTabView(clTabItems: [
                          if (authState.hasPermission(PermissionSlugs.updatePromo))
                            CLTabItem(
                              tabName: "Promo",
                              tabContent: Center(
                                  child: PagedDataTable<String, String, Promo>(
                                rowsSelectable: false,
                                idGetter: (promo) => promo.id,
                                controller: vm.promoTableController,
                                fetchPage: vm.getAllPromoByStore,
                                initialPage: "1",
                                initialPageSize: 25,
                                onItemTap: (item) {
                                  if (authState.hasPermission(PermissionSlugs.dettaglioPromo)) {
                                    context.customGoNamed(PromoRoutes.viewPromo.name, params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                                  }
                                },
                                actionsBuilder: (item) => [
                                  if (authState.hasPermission(PermissionSlugs.updatePromo))
                                    TableAction<Promo>(
                                    content: TableActionItem(name: "Modifica", iconData: Icons.edit),
                                    onTap: (item) {
                                      context.customGoNamed(PromoRoutes.editPromo.name, params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                                    },
                                  ),
                                  if (authState.hasPermission(PermissionSlugs.updateStatusPromo)) ...[
                                    TableAction<Promo>(
                                      content: TableActionItem(name: "Approvato", iconData: Icons.check_circle_outline, iconColor: CLTheme.of(context).success),
                                      onTap: (item) {
                                        vm.updatePromoStatus(item.id, 1);
                                      },
                                    ),
                                    TableAction<Promo>(
                                      content: TableActionItem(name: "Non Approvato", iconData: Icons.cancel_outlined, iconColor: CLTheme.of(context).danger),
                                      onTap: (item) {
                                        vm.updatePromoStatus(item.id, 2);
                                      },
                                    ),
                                    TableAction<Promo>(
                                      content: TableActionItem(name: "In Attesa", iconData: Icons.watch_later_outlined, iconColor: CLTheme.of(context).warning),
                                      onTap: (item) {
                                        vm.updatePromoStatus(item.id, 0);
                                      },
                                    ),
                                  ]




                                ],
                                columns: [
                                  TableColumn(
                                      id: "title",
                                      title: const Text("Titolo"),
                                      sortable: true,
                                      cellBuilder: (item) => Text(
                                            item.title.toString(),
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                      sizeFactor: .2,
                                      isMain: false),
                                  TableColumn(
                                      id: "code",
                                      title: const Text("Codice"),
                                      sortable: true,
                                      cellBuilder: (item) => Text(
                                            item.code.toString(),
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                      sizeFactor: .2,
                                      isMain: false),
                                  TableColumn(
                                      id: "endingAtDate",
                                      title: const Text("Scadenza"),
                                      sortable: true,
                                      cellBuilder: (item) => Text(
                                        item.endingAtDate,
                                        style: CLTheme.of(context).bodyText,
                                      ),
                                      sizeFactor: .2,
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
                                  if (authState.hasPermission(PermissionSlugs.creazionePromo))
                                    CLButton.primary(
                                      text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                      onTap: () {
                                        context.customGoNamed(PromoRoutes.newPromo.name, params: {"storeId": widget.id});
                                      },
                                      context: context,
                                      icon: Icons.add),
                                ],
                              ))),
                          if (authState.hasPermission(PermissionSlugs.visualizzaCategorieStore))
                            CLTabItem(
                              tabName: "Categorie",
                              tabContent: Center(
                                  child: PagedDataTable<String, String, StoreCategoryPivot>(
                                rowsSelectable: false,
                                idGetter: (storeCategoryPivot) => storeCategoryPivot.id,
                                controller: vm.storeCategoryPivotTableController,
                                fetchPage: vm.getAllStoreCategoryPivot,
                                initialPage: "1",
                                initialPageSize: 25,
                                onItemTap: (item) {
                                  context.customGoNamed(StoreCategoryRoutes.viewStoreCategory.name,
                                      params: {"id": item.storeCategory.id}, replacedRouteName: item.modelIdentifier);
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
                                      id: "storeCategory:name",
                                      title: const Text("Nome"),
                                      sortable: true,
                                      cellBuilder: (item) => Text(
                                            item.storeCategory.name.toString(),
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                      sizeFactor: .4,
                                      isMain: false),
                                ],
                                mainFilter: TextTableFilter(
                                  id: "storeCategory:name",
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
                                        context.customGoNamed(
                                          StoreRoutes.addStoreCategoryToStore.name,
                                          params: {"id": widget.id},
                                        );
                                      },
                                      context: context,
                                      icon: Icons.add),
                                ],
                              ))),
                          if (authState.hasPermission(PermissionSlugs.visualizzaUtenti))
                            CLTabItem(
                              tabName: "Dipendenti",
                              tabContent: Center(
                                  child: PagedDataTable<String, String, StoreEmployee>(
                                rowsSelectable: false,
                                idGetter: (storeEmployee) => storeEmployee.id,
                                controller: vm.storeEmployeeTableController,
                                fetchPage: vm.getAllStoreEmployeesByStore,
                                initialPage: "1",
                                initialPageSize: 25,
                                onItemTap: (item) {
                                  if (authState.hasPermission(PermissionSlugs.dettaglioUtente)) {
                                    context.customGoNamed(UserRoutes.viewUser.name, params: {"id": item.user.id}, replacedRouteName: item.user.modelIdentifier);
                                  }
                                },
                                actionsBuilder: (item) => [
                                  if (authState.hasPermission(PermissionSlugs.updateUtenti))
                                    TableAction<StoreEmployee>(
                                    content: TableActionItem(name: "Modifica", iconData: Icons.edit),
                                    onTap: (item) {
                                      context.customGoNamed(UserRoutes.editUser.name, params: {"id": item.user.id}, replacedRouteName: item.user.modelIdentifier);
                                    },
                                  ),
                                  if (authState.hasPermission(PermissionSlugs.allegaDipendentiStore))
                                    TableAction<StoreEmployee>(
                                    content: TableActionItem(name: "Rimuovi", iconData: Icons.delete),
                                    onTap: (item) async {
                                      await vm.detachUserStore(item.id);
                                    },
                                  ),
                                ],
                                columns: [
                                  TableColumn(
                                      id: "user:userData:firstName",
                                      title: const Text("Nome"),
                                      sortable: true,
                                      cellBuilder: (item) => Text(
                                            item.user.userData.firstName.toString(),
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                      sizeFactor: .2,
                                      isMain: false),
                                  TableColumn(
                                      id: "user:userData:lastName",
                                      title: const Text("Cognome"),
                                      sortable: true,
                                      cellBuilder: (item) => Text(
                                            item.user.userData.lastName.toString(),
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                      sizeFactor: .2,
                                      isMain: false),
                                  TableColumn(
                                      id: "user:userData:birthDate",
                                      title: const Text("Data di nascita"),
                                      sortable: true,
                                      cellBuilder: (item) => Text(
                                        item.user.userData.formattedDate.toString(),
                                        style: CLTheme.of(context).bodyText,
                                      ),
                                      sizeFactor: .2,
                                      isMain: false),
                                ],
                                mainFilter: TextTableFilter(
                                  id: "user:userData:firstName",
                                  title: "Nome",
                                  isMainFilter: true,
                                  chipFormatter: (text) => text,
                                ),
                                extraFilters: [],
                                mainMenus: [
                                  if (authState.hasPermission(PermissionSlugs.allegaDipendentiStore))
                                    CLButton.primary(
                                    text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                    onTap: () async {
                                      context.customGoNamed(StoreRoutes.storeEmployee.name, params: {"id": widget.id});
                                    },
                                    context: context,
                                    icon: Icons.add,
                                  )
                                ],
                              ))),
                          CLTabItem(
                              tabName: "Rapporti",
                              tabContent: Center(
                                  child: PagedDataTable<String, String, StoreReport>(
                                rowsSelectable: false,
                                idGetter: (storeReport) => storeReport.id,
                                controller: vm.storeReportTableController,
                                fetchPage: vm.getAllStoreReportByStore,
                                initialPage: "1",
                                initialPageSize: 25,
                                onItemTap: (item) {
                                  if (authState.hasPermission(PermissionSlugs.dettaglioStoreReport)) {
                                    context.customGoNamed(StoreReportRoutes.viewStoreReport.name,
                                      params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                                  }
                                },
                                actionsBuilder: (item) => [
                                  if (authState.hasPermission(PermissionSlugs.dettaglioStoreReport))
                                    TableAction<StoreReport>(
                                    content: TableActionItem(name: "Scarica rapporto", iconData: Icons.print),
                                    onTap: (report) async{
                                      await context.downloadFile(report.fileUrl);
                                    },
                                  ),
                                ],
                                columns: [
                                  TableColumn(
                                      id: "reportDate",
                                      title: const Text("Mese"),
                                      sortable: true,
                                      cellBuilder: (item) => Text(
                                            item.reportDateFormat,
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                      sizeFactor: .2,
                                      isMain: false),
                                  TableColumn(
                                      id: "createdAt",
                                      title: const Text("Creato il"),
                                      sortable: true,
                                      cellBuilder: (item) => Text(
                                            item.createdAtDate,
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                      sizeFactor: .2,
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
                                  CLButton.primary(
                                    text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                    onTap: () async {
                                      if (authState.hasPermission(PermissionSlugs.creazioneStoreReport)) {
                                        context.customGoNamed(StoreReportRoutes.newStoreReport.name, params: {"storeId": widget.id});
                                      }
                                    },
                                    context: context,
                                    icon: Icons.add,
                                  )
                                ],
                              ))),
                          if (authState.hasPermission(PermissionSlugs.updateLocation))
                            CLTabItem(
                              tabName: "Location",
                              tabContent: Center(
                                  child: PagedDataTable<String, String, Location>(
                                    rowsSelectable: false,
                                    idGetter: (location) => location.id,
                                    controller: vm.locationTableController,
                                    fetchPage: vm.getAllLocationByStore,
                                    initialPage: "1",
                                    initialPageSize: 25,
                                    onItemTap: (item) {
                                      if (authState.hasPermission(PermissionSlugs.dettaglioLocation)) {
                                        context.customGoNamed(LocationRoutes.viewLocation.name, params: {"id": item.id});
                                      }
                                    },
                                    actionsBuilder: (item) => [
                                      if (authState.hasPermission(PermissionSlugs.rimozioneLocation))
                                        TableAction<Location>(
                                        content: TableActionItem(name: 'Elimina', iconData: Icons.delete_outline_rounded),
                                        onTap: (item) async {
                                          await vm.deleteLocation(item.id);
                                        },
                                      ),
                                    ],
                                    columns: [
                                      TableColumn(
                                          id: "name",
                                          title: const Text("Nome"),
                                          sortable: true,
                                          cellBuilder: (item) => Text(
                                            item.name.toString(),
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                          sizeFactor: .2,
                                          isMain: false),
                                      TableColumn(
                                          id: "poiId",
                                          title: const Text("POI"),
                                          sortable: true,
                                          cellBuilder: (item) => Text(
                                            item.poiId.toString(),
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                          sizeFactor: .2,
                                          isMain: false),
                                      TableColumn(
                                          id: "startValidityAtDate",
                                          title: const Text("Data inizio validità"),
                                          sortable: true,
                                          cellBuilder: (item) => Text(
                                            item.startValidityAtDate,
                                            style: CLTheme.of(context).bodyText,
                                          ),
                                          sizeFactor: .2,
                                          isMain: false),
                                      TableColumn(
                                        id: "endValidityAtDate",
                                        title: const Text("Data fine validità"),
                                        sortable: true,
                                        cellBuilder: (item) => Text(
                                          item.endValidityAtDate,
                                          style: CLTheme.of(context).bodyText,
                                        ),
                                        sizeFactor: .2,
                                        isMain: false,
                                      ),
                                    ],
                                    mainFilter: TextTableFilter(
                                      id: "name",
                                      title: "Nome",
                                      isMainFilter: true,
                                      chipFormatter: (text) => text,
                                    ),
                                    extraFilters: [],
                                    mainMenus: [
                                      if (authState.hasPermission(PermissionSlugs.creazioneLocation))
                                        CLButton.primary(
                                          text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                          onTap: () {
                                            context.customGoNamed(LocationRoutes.newLocation.name, params: {"storeId": widget.id});
                                          },
                                          context: context,
                                          icon: Icons.add),
                                    ],
                                  ))),
                        ]),
                      ),
                    ],
                  ),
                ))]);
        });
  }

  String _getDayName(int dayIndex) {
    const days = ['Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato', 'Domenica'];
    if (dayIndex < 0 || dayIndex > 6) return 'Giorno sconosciuto';
    return days[dayIndex];
  }
}
