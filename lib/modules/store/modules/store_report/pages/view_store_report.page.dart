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
import '../viewmodels/store_report.viewmodel.dart';

class ViewStoreReportPage extends StatefulWidget {
  const ViewStoreReportPage({super.key, required this.id});

  final String id;

  @override
  State<ViewStoreReportPage> createState() => _ViewStoreReportPageState();
}

class _ViewStoreReportPageState extends State<ViewStoreReportPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = context.read<AuthState>();
    return ViewModelBuilder<StoreReportViewModel>.reactive(
        viewModelBuilder: () => StoreReportViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Stampa",
                  isMain: true,
                  iconData: Icons.print,
                  onTap: () async {
                    await context.downloadFile(vm.storeReport.fileUrl);
                  }),
          if (authState.hasPermission(PermissionSlugs.rimozioneStoreReport))
            PageAction(
                  title: "Elimina",
                  isMain: true,
                  isSecondary: true,
                  needConfirmation: true,
                  iconData: Icons.delete,
                  onTap: () async {
                    await vm.deleteStoreReport(widget.id);
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
                                    lg: 50,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Store", style: CLTheme.of(context).bodyLabel),
                                      subtitle: CLActionText.primary(
                                          text: vm.storeReport.store.name,
                                          onTap: () {
                                            if (authState.hasPermission(PermissionSlugs.dettaglioStore))
                                              context.customGoNamed(StoreRoutes.viewStore.name, params: {"id": vm.storeReport.store.id});
                                          },
                                          context: context),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Mese e anno del report", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.storeReport.reportDateFormat}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 100,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Numero ingressi ", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.storeReport.ingressi}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                      lg: 20,
                                      xs: 100,
                                      child: Row(
                                        children: [
                                          Text(""),
                                        ],
                                      )),
                                  ResponsiveGridItem(
                                      lg: 16,
                                      xs: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Iva 22%",
                                            style: CLTheme.of(context).subTitle,
                                          ),
                                        ],
                                      )),
                                  ResponsiveGridItem(
                                      lg: 16,
                                      xs: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Iva 10%",
                                            style: CLTheme.of(context).subTitle,
                                          ),
                                        ],
                                      )),
                                  ResponsiveGridItem(
                                      lg: 16,
                                      xs: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Iva 5%",
                                            style: CLTheme.of(context).subTitle,
                                          ),
                                        ],
                                      )),
                                  ResponsiveGridItem(
                                      lg: 16,
                                      xs: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Iva 4%",
                                            style: CLTheme.of(context).subTitle,
                                          ),
                                        ],
                                      )),
                                  ResponsiveGridItem(
                                      lg: 16,
                                      xs: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Iva 0%",
                                            style: CLTheme.of(context).subTitle,
                                          ),
                                        ],
                                      )),


                                  ResponsiveGridItem(
                                      lg: 20,
                                      xs: 100,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Imponibile",
                                            style: CLTheme.of(context).subTitle,
                                          ),
                                        ],
                                      )),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.imponibile22}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.imponibile10}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.imponibile5}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.imponibile4}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.imponibile0}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                      lg: 20,
                                      xs: 100,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Iva",
                                            style: CLTheme.of(context).subTitle,
                                          ),
                                        ],
                                      )),


                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.iva22}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.iva10}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.iva5}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.iva4}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.iva0}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),

                                  ResponsiveGridItem(
                                      lg: 20,
                                      xs: 100,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Totale",
                                            style: CLTheme.of(context).subTitle,
                                          ),
                                        ],
                                      )),



                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.totale22}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.totale10}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.totale5}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.totale4}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.totale0}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),

                                  ResponsiveGridItem(
                                      lg: 20,
                                      xs: 100,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Numero scontrini",
                                            style: CLTheme.of(context).subTitle,
                                          ),
                                        ],
                                      )),

                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.numeroScontrini22}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.numeroScontrini10}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.numeroScontrini5}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.numeroScontrini4}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 16,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      subtitle: Text("${vm.storeReport.numeroScontrini0}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 20,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Note del report ", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.storeReport.note}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ))]);
        });
  }
}
