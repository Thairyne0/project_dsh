import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/modules/store/modules/brand/constants/brand_routes.costant.dart';
import 'package:project_dsh/ui/widgets/excerpt_text.widget.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../../../../users/constants/permission_slug.dart';
import '../viewmodels/brand.viewmodel.dart';

class ViewBrandPage extends StatefulWidget {
  const ViewBrandPage({super.key, required this.id});

  final String id;

  @override
  State<ViewBrandPage> createState() => _ViewBrandPageState();
}

class _ViewBrandPageState extends State<ViewBrandPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = context.read<AuthState>();
    return ViewModelBuilder<BrandViewModel>.reactive(
        viewModelBuilder: () => BrandViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          if (authState.hasPermission(PermissionSlugs.updateBrand))
            PageAction(
                  title: "Modifica",
                  isMain: true,
                  iconData: Icons.edit,
                  onTap: () async {
                    context.customGoNamed(BrandRoutes.editBrand.name, params: {"id": widget.id}, replacedRouteName: vm.brand.modelIdentifier);
                  }),
          if (authState.hasPermission(PermissionSlugs.rimozioneBrand))
            PageAction(
                  title: "Elimina",
                  isMain: true,
                  isSecondary: true,
                  needConfirmation: true,
                  iconData: Icons.delete,
                  onTap: () async {
                    await vm.deleteBrand(widget.id);
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
          child: Column(
                    children: [
                      CLContainer(
                        contentMargin: const EdgeInsets.symmetric(horizontal:Sizes.padding),
                        child:
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
                                    subtitle: Text(vm.brand.name, style: CLTheme.of(context).bodyText),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Descrizione", style: CLTheme.of(context).bodyLabel),
                                    subtitle: ExcerptText(text:vm.brand.description, textStyle: CLTheme.of(context).bodyText),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text("Logo", style: CLTheme.of(context).bodyLabel),
                                    subtitle: CLMediaViewer(
                                      clMediaViewerMode: CLMediaViewerMode.previewMode,
                                      medias: [
                                        CLMedia(
                                          fileUrl: vm.brand.imageUrl,
                                        )
                                      ],
                                    )
                                  ),
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
