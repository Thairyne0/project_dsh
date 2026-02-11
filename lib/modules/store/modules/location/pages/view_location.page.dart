import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_action_text.widget.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../../../../users/constants/permission_slug.dart';
import '../../../constants/store_routes.constant.dart';
import '../constants/location_routes.constant.dart';
import '../viewmodels/location.viewmodel.dart';

class ViewLocationPage extends StatefulWidget {
  const ViewLocationPage({super.key, required this.id});

  final String id;

  @override
  State<ViewLocationPage> createState() => _ViewLocationPageState();
}

class _ViewLocationPageState extends State<ViewLocationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = context.read<AuthState>();
    return ViewModelBuilder<LocationViewModel>.reactive(
        viewModelBuilder: () =>
            LocationViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              if (authState.hasPermission(PermissionSlugs.updateLocation))
                PageAction(
                    title: "Modifica",
                    isMain: true,
                    iconData: Icons.edit,
                    onTap: () async {
                      context.customGoNamed(LocationRoutes.editLocation.name,
                          params: {"locationId": widget.id},
                          replacedRouteName: vm.location.modelIdentifier);
                    }),
              if (authState.hasPermission(PermissionSlugs.rimozioneLocation))
                PageAction(
                    title: "Elimina",
                    isMain: true,
                    isSecondary: true,
                    needConfirmation: true,
                    iconData: Icons.delete,
                    onTap: () async {
                      await vm.deleteLocation(widget.id);
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: Sizes.padding),
                    child: Column(
                      children: [
                        CLContainer(
                          backgroundColor: Colors.white,
                          child: ResponsiveGrid(
                            mainAxisAlignment: MainAxisAlignment.start,
                            gridSpacing: Sizes.padding,
                            showHorizontalDivider: true,
                            children: [
                              ResponsiveGridItem(
                                lg: 100,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Store",
                                      style: CLTheme.of(context)
                                          .smallLabel
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  subtitle: CLActionText.primary(
                                    text: vm.location.store.name,
                                    onTap: () {
                                      if (authState.hasPermission(
                                          PermissionSlugs.dettaglioStore))
                                        context.customGoNamed(
                                            StoreRoutes.viewStore.name,
                                            params: {
                                              "id": vm.location.store.id
                                            });
                                    },
                                    context: context,
                                  ),
                                ),
                              ),
                              ResponsiveGridItem(
                                lg: 25,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Nome",
                                      style: CLTheme.of(context)
                                          .smallLabel
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  subtitle: Text("${vm.location.name}",
                                      style: CLTheme.of(context).bodyText),
                                ),
                              ),
                              ResponsiveGridItem(
                                lg: 25,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Civico",
                                      style: CLTheme.of(context)
                                          .smallLabel
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  subtitle: Text("${vm.location.civic}",
                                      style: CLTheme.of(context).bodyText),
                                ),
                              ),
                              ResponsiveGridItem(
                                lg: 25,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Numero POI",
                                      style: CLTheme.of(context)
                                          .smallLabel
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  subtitle: Text("${vm.location.poiId}",
                                      style: CLTheme.of(context).bodyText),
                                ),
                              ),
                              ResponsiveGridItem(
                                lg: 25,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Metri quadri",
                                      style: CLTheme.of(context)
                                          .smallLabel
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  subtitle: Text("${vm.location.sq}",
                                      style: CLTheme.of(context).bodyText),
                                ),
                              ),
                              ResponsiveGridItem(
                                lg: 25,
                                xs: 100,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Data inizio validità",
                                      style: CLTheme.of(context).bodyLabel),
                                  subtitle: Text(
                                      "${vm.location.startValidityAtDate}",
                                      style: CLTheme.of(context).bodyText),
                                ),
                              ),
                              ResponsiveGridItem(
                                lg: 25,
                                xs: 100,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Data fine validità",
                                      style: CLTheme.of(context).bodyLabel),
                                  subtitle: Text(
                                      "${vm.location.endValidityAtDate}",
                                      style: CLTheme.of(context).bodyText),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))]);
        });
  }
}
