import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sembast/sembast.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:project_dsh/modules/users/modules/role_permission/models/user_permission.model.dart';
import 'package:project_dsh/ui/widgets/table_action_item.widget.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../ui/cl_theme.dart';
import '../../../../utils/providers/appstate.util.provider.dart';
import '../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../ui/widgets/cl_tabs/cl_tab_item.model.dart';
import '../../../ui/widgets/cl_tabs/cl_tab_view.widget.dart';
import '../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../constants/permission_slug.dart';
import '../constants/users_routes.constants.dart';
import '../viewmodels/user.viewmodel.dart';

class ViewUserPage extends StatefulWidget {
  const ViewUserPage({super.key, required this.id});

  final String id;

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<UserViewModel>.reactive(
        viewModelBuilder: () => UserViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              if (authState.hasPermission(PermissionSlugs.updateUtenti))
                PageAction(
                    title: "Modifica",
                    isMain: true,
                    iconData: Icons.edit,
                    onTap: () async {
                      context.customGoNamed(UserRoutes.editUser.name, params: {"id": widget.id}, replacedRouteName: vm.user.modelIdentifier);
                    }),
              if (authState.hasPermission(PermissionSlugs.rimozioneUtenti))
                PageAction(
                    title: "Elimina",
                    isMain: true,
                    isSecondary: true,
                    needConfirmation: true,
                    iconData: Icons.delete,
                    onTap: () async {
                      await vm.deleteUser(widget.id);
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
          child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                    child: Column(
                      children: [
                        CLContainer(
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
                                      subtitle: Text("${vm.user.userData.firstName}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Cognome", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.user.userData.lastName}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Genere", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.user.userData.gender}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Data di nascita", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.user.userData.formattedDate}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Residenza", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.user.userData.cityOfResidence.name}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("CAP di residenza", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.user.userData.cap}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(lg: 25, xs: 100),
                                  /*ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Codice Fiscale", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.user.userData.fiscalCode}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),*/
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Email", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.user.email}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Telefono", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.user.phone}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Punti", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.user.pointsAmount}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(lg: 25, xs: 100),
                                  ResponsiveGridItem(
                                    lg: 100,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Ruolo", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.user.role.name}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 33,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Privacy Foto", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                vm.user.photoPolicyAcceptance == true ? Icons.check_circle : Icons.cancel,
                                                color: vm.user.photoPolicyAcceptance == true ? Colors.green : Colors.red,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                vm.user.photoPolicyAcceptance == true ? "Accettata" : "Non accettata",
                                                style: CLTheme.of(context).bodyText,
                                              ),
                                            ],
                                          ),
                                          if (vm.user.photoPolicyAcceptedAt != null) ...[
                                            SizedBox(height: 4),
                                            Text(
                                              "Data: ${DateFormat('dd/MM/yyyy HH:mm').format(vm.user.photoPolicyAcceptedAt!)}",
                                              style: CLTheme.of(context).bodyText.copyWith(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 33,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Privacy Marketing", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                vm.user.marketingPolicyAcceptance == true ? Icons.check_circle : Icons.cancel,
                                                color: vm.user.marketingPolicyAcceptance == true ? Colors.green : Colors.red,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                vm.user.marketingPolicyAcceptance == true ? "Accettata" : "Non accettata",
                                                style: CLTheme.of(context).bodyText,
                                              ),
                                            ],
                                          ),
                                          if (vm.user.marketingPolicyAcceptedAt != null) ...[
                                            SizedBox(height: 4),
                                            Text(
                                              "Data: ${DateFormat('dd/MM/yyyy HH:mm').format(vm.user.marketingPolicyAcceptedAt!)}",
                                              style: CLTheme.of(context).bodyText.copyWith(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 33,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Privacy Newsletter", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                vm.user.newsletterPolicyAcceptance == true ? Icons.check_circle : Icons.cancel,
                                                color: vm.user.newsletterPolicyAcceptance == true ? Colors.green : Colors.red,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                vm.user.newsletterPolicyAcceptance == true ? "Accettata" : "Non accettata",
                                                style: CLTheme.of(context).bodyText,
                                              ),
                                            ],
                                          ),
                                          if (vm.user.newsPolicyAcceptedAt != null) ...[
                                            SizedBox(height: 4),
                                            Text(
                                              "Data: ${DateFormat('dd/MM/yyyy HH:mm').format(vm.user.newsPolicyAcceptedAt!)}",
                                              style: CLTheme.of(context).bodyText.copyWith(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 33,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Privacy Generale", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                vm.user.generalPolicyAcceptance == true ? Icons.check_circle : Icons.cancel,
                                                color: vm.user.generalPolicyAcceptance == true ? Colors.green : Colors.red,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                vm.user.generalPolicyAcceptance == true ? "Accettata" : "Non accettata",
                                                style: CLTheme.of(context).bodyText,
                                              ),
                                            ],
                                          ),
                                          if (vm.user.generalPolicyAcceptedAt != null) ...[
                                            SizedBox(height: 4),
                                            Text(
                                              "Data: ${DateFormat('dd/MM/yyyy HH:mm').format(vm.user.generalPolicyAcceptedAt!)}",
                                              style: CLTheme.of(context).bodyText.copyWith(fontSize: 12, color: Colors.grey),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Sizes.padding),
                        if (authState.hasPermission(PermissionSlugs.visualizzaPermessi))
                          CLTabView(
                            clTabItems: [
                              CLTabItem(
                                  tabName: "Permessi",
                                  tabContent: Center(
                                      child: PagedDataTable<String, String, UserPermission>(
                                    rowsSelectable: false,
                                    idGetter: (userPermission) => userPermission.id,
                                    controller: vm.userPermissionTableController,
                                    fetchPage: vm.getAllUserPermission,
                                    initialPage: "1",
                                    initialPageSize: 25,
                                    onItemTap: (item) {},
                                    actionsBuilder: (item) => [
                                      if (authState.hasPermission(PermissionSlugs.rimuoviPermessoDaUtente))
                                        TableAction<UserPermission>(
                                          content: TableActionItem(name: 'Rimuovi', iconData: Icons.delete_outline_rounded),
                                          onTap: (item) async {
                                            await vm.detachPermissionToUser(item.id);
                                          },
                                        ),
                                    ],
                                    columns: [
                                      TableColumn(
                                          id: "permission:name",
                                          title: const Text("Nome"),
                                          sortable: true,
                                          cellBuilder: (item) => Text(
                                                item.permission!.name,
                                                style: CLTheme.of(context).bodyText,
                                              ),
                                          sizeFactor: .2,
                                          isMain: false),
                                    ],
                                    mainFilter: TextTableFilter(
                                      id: "permission:name",
                                      title: "Nome",
                                      isMainFilter: true,
                                      chipFormatter: (text) => text,
                                    ),
                                    extraFilters: [],
                                    mainMenus: [
                                      if (authState.hasPermission(PermissionSlugs.aggiungiPermessoAdUtente))
                                        CLButton.primary(
                                            text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                            onTap: () {
                                              context.customGoNamed(
                                                UserRoutes.addPermissionToUser.name,
                                                params: {"id": widget.id},
                                              );
                                            },
                                            context: context,
                                            icon: Icons.add),
                                    ],
                                  ))),
                              CLTabItem(
                                  tabName: "Transazioni",
                                  tabContent: Center(),
                              )],
                          ),
                      ],
                    ),
                  ),
                ))]);
        });
  }

}
