import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../ui/widgets/table_action_item.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../../../../users/constants/permission_slug.dart';
import '../constants/location_routes.constant.dart';
import '../models/location.model.dart';
import '../viewmodels/location.viewmodel.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<LocationViewModel>.reactive(
        viewModelBuilder: () => LocationViewModel(context, VMType.list, null),
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
                          child: PagedDataTable<String, String, Location>(
                            rowsSelectable: false,
                            idGetter: (location) => location.id,
                            controller: vm.locationTableController,
                            refreshListener: appState.refreshList,
                            fetchPage: vm.getAllLocation,
                            initialPage: "1",
                            initialPageSize: 25,
                            onItemTap: (item) {
                              if (authState.hasPermission(PermissionSlugs.dettaglioLocation))
                                context.customGoNamed(LocationRoutes.viewLocation.name, params: {"id": item.id});
                            },
                            actionsBuilder: (item) => [
                              if (authState.hasPermission(PermissionSlugs.updateLocation))
                              TableAction<Location>(
                                content:TableActionItem(name: "Modifica", iconData: Icons.edit),
                                onTap: (item) {
                                  context.customGoNamed(LocationRoutes.editLocation.name, params: {"id": item.id});
                                },
                              )
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
                                    context.customGoNamed(LocationRoutes.newLocation.name);
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
