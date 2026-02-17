import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/modules/users/modules/role_permission/models/role_permission.model.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_tabs/cl_tab_item.model.dart';
import '../../../../../ui/widgets/cl_tabs/cl_tab_view.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../../../constants/permission_slug.dart';
import '../constants/role_permission_routes.constant.dart';
import '../viewmodels/role_permission.viewmodel.dart';

class ViewRolePage extends StatefulWidget {
  const ViewRolePage({super.key, required this.id});

  final String id;

  @override
  State<ViewRolePage> createState() => _ViewRolePageState();
}

class _ViewRolePageState extends State<ViewRolePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<RoleViewModel>.reactive(
        viewModelBuilder: () => RoleViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          if (authState.hasPermission(PermissionSlugs.updateRuolo))
            PageAction(
                  title: "Modifica",
                  isMain: true,
                  iconData: Icons.edit,
                  onTap: () async {
                      context.customGoNamed(RoleRoutes.editRole.name, params: {"id": widget.id}, replacedRouteName: vm.role.modelIdentifier);
                  }),
              if (authState.hasPermission(PermissionSlugs.rimozioneRuolo))
                PageAction(
                    title: "Elimina",
                    isMain: true,
                    isSecondary: true,
                    needConfirmation: true,
                    iconData: Icons.delete,
                    onTap: () async {
                      await vm.deleteRole(widget.id);
                      appState.refreshList.add(true);
                      context.pop();
                    }),
            ]),
        builder: (context, vm, child) {
          return vm.isBusy
              ? const LoadingWidget()
              : SingleChildScrollView(
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
                                showHorizontalDivider: true,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Nome", style: CLTheme.of(context).bodyLabel),
                                          Text(vm.role.name, style: CLTheme.of(context).bodyText),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Slug", style: CLTheme.of(context).bodyLabel),
                                            Text(vm.role.slug, style: CLTheme.of(context).bodyText),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Sizes.padding),
                        CLTabView(
                          clTabItems: [
                            CLTabItem(
                                tabName: "Permessi",
                                tabContent: Center(
                                    child: PagedDataTable<String, String, RolePermission>(
                                  rowsSelectable: false,
                                  idGetter: (permission) => permission.id,
                                  controller: vm.rolePermissionTableController,
                                  fetchPage: vm.getAllRolePermission,
                                  initialPage: "1",
                                  initialPageSize: 25,
                                  onItemTap: (item) {},
                                  actionsBuilder: (item) => [
                                    if (authState.hasPermission(PermissionSlugs.rimuoviPermessoDaRuolo))
                                      TableAction<RolePermission>(
                                      content: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.delete_outline_rounded, size: Sizes.medium, color: CLTheme.of(context).secondaryText),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Rimuovi", style: CLTheme.of(context).bodyText, maxLines: 1)
                                        ],
                                      ),
                                      onTap: (item) async {
                                        await vm.detachPermissionToRole(item.id);
                                      },
                                    ),
                                  ],
                                  columns: [
                                    TableColumn(
                                        id: "name",
                                        title: const Text("Nome"),
                                        sortable: true,
                                        cellBuilder: (item) => Text(
                                              item.permission.name,
                                              style: CLTheme.of(context).bodyText,
                                            ),
                                        sizeFactor: .4,
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
                                    if (authState.hasPermission(PermissionSlugs.allegaPermessoARuolo))
                                      CLButton.primary(
                                        text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                        onTap: () {
                                          context.customGoNamed(
                                            RoleRoutes.addPermissionToRole.name,
                                            params: {"id": widget.id},
                                          );
                                        },
                                        context: context,
                                        icon: Icons.add),
                                  ],
                                ))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
        });
  }
}
