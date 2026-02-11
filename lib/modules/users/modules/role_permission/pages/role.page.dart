import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/widgets/table_action_item.widget.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../../../constants/permission_slug.dart';
import '../constants/role_permission_routes.constant.dart';
import '../models/role.model.dart';
import '../viewmodels/role_permission.viewmodel.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<RoleViewModel>.reactive(
        viewModelBuilder: () => RoleViewModel(context, VMType.list, null),
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
                        child: PagedDataTable<String, String, Role>(
                          rowsSelectable: false,
                          idGetter: (role) => role.id,
                          controller: vm.roleTableController,
                          refreshListener: appState.refreshList,
                          fetchPage: vm.getAllRole,
                          initialPage: "1",
                          initialPageSize: 25,
                          onItemTap: (item) {
                            if (authState.hasPermission(PermissionSlugs.dettaglioRuolo))
                              context.customGoNamed(RoleRoutes.viewRole.name, params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                          },
                          actionsBuilder: (item) => [
                            if (authState.hasPermission(PermissionSlugs.updateRuolo))
                              TableAction<Role>(
                              content: TableActionItem(name: "Modifica", iconData: Icons.edit),
                              onTap: (item) {
                                  context.customGoNamed(RoleRoutes.editRole.name, params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                              },
                            ),
                            /*TableAction<Role>(
                                content: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  hoverColor: Colors.transparent,
                                  leading: Icon(Icons.delete, size: Sizes.medium, color: CLTheme.of(context).primaryText),
                                  title: Text("Elimina", style: CLTheme.of(context).bodyText),
                                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: Sizes.small, color: CLTheme.of(context).primaryText),
                                ),
                                onTap: (item) {
                                  if (authState.hasPermission(PermissionSlugs.rimozioneRuolo))
                                    context.customGoNamed(RoleRoutes.editRole.name, params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                                },
                              )*/
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
                                sizeFactor: .8,
                                isMain: false),
                          ],
                          mainFilter: TextTableFilter(
                            id: "name",
                            title: "Name",
                            isMainFilter: true,
                            chipFormatter: (text) => text,
                          ),
                          extraFilters: [],
                          mainMenus: [
                            if (authState.hasPermission(PermissionSlugs.creazioneRuolo))
                              CLButton.primary(
                                  text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                  onTap: () {
                                    context.customGoNamed(RoleRoutes.newRole.name);
                                  },
                                  context: context,
                                  icon: Icons.add),
                          ],
                        ),
                      )
                    ],
                  ),
                );
        });
  }
}
