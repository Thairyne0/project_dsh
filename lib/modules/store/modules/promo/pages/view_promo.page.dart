import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_action_text.widget.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../../../../users/constants/permission_slug.dart';
import '../../../constants/store_routes.constant.dart';
import '../../brand/constants/brand_routes.costant.dart';
import '../constants/promo_routes.constant.dart';
import '../viewmodels/promo.viewmodel.dart';

class ViewPromoPage extends StatefulWidget {
  const ViewPromoPage({super.key, required this.id});

  final String id;

  @override
  State<ViewPromoPage> createState() => _ViewPromoPageState();
}

class _ViewPromoPageState extends State<ViewPromoPage> {
  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<PromoViewModel>.reactive(
        viewModelBuilder: () => PromoViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              if (authState.hasPermission(PermissionSlugs.updatePromo))
                PageAction(
                    title: "Modifica",
                    isMain: true,
                    iconData: Icons.edit,
                    onTap: () async {
                      context.customGoNamed(PromoRoutes.editPromo.name, params: {"id": widget.id}, replacedRouteName: vm.promo.modelIdentifier);
                    }),
              if (authState.hasPermission(PermissionSlugs.rimozionePromo))
                PageAction(
                    title: "Elimina",
                    isMain: true,
                    isSecondary: true,
                    needConfirmation: true,
                    iconData: Icons.delete,
                    onTap: () async {
                      await vm.deletePromo(widget.id);
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
                                showHorizontalDivider: true,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        minTileHeight: 0,
                                        title: Text("Store", style: CLTheme.of(context).bodyLabel),
                                        subtitle: CLActionText.primary(
                                          text: vm.promo.store.name,
                                          onTap: () {
                                            if (authState.hasPermission(PermissionSlugs.dettaglioStore))
                                              context.customGoNamed(StoreRoutes.viewStore.name, params: {"id": vm.promo.store.id});
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
                                        title: Text("Brand", style: CLTheme.of(context).bodyLabel),
                                        subtitle: CLActionText.primary(
                                          text: vm.promo.store.brand.name,

                                          onTap: () {
                                            if (authState.hasPermission(PermissionSlugs.dettaglioBrand))
                                              context.customGoNamed(BrandRoutes.viewBrand.name, params: {"id": vm.promo.store.brand.id});
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
                                      title: Text("Titolo", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.promo.title}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),

                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Quantità massima", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.promo.qty}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Quantità max riscattabile Per Utente", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.promo.qtyPerUser}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),

                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Codice", style: CLTheme.of(context).bodyLabel),
                                      subtitle: SelectableText("${vm.promo.code}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Data inizio", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.promo.startingAtDate}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("Data fine", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text("${vm.promo.endingAtDate}", style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      minVerticalPadding: 0,
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title: Text("In evidenza?", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                        vm.promo.isHighlighted ? 'Si' : 'No',
                                        style: CLTheme.of(context).bodyText,
                                      ),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 100,
                                    xs: 100,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Descrizione", style: CLTheme.of(context).bodyLabel),
                                        const SizedBox(height: Sizes.padding),
                                        Container(
                                            padding: const EdgeInsets.all(Sizes.padding),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: CLTheme.of(context).alternate),
                                              borderRadius: BorderRadius.circular(Sizes.borderRadius),
                                            ),
                                            child: quill.QuillEditor(
                                              controller: quill.QuillController(
                                                document: vm.descriptionDoc!,
                                                readOnly: true,
                                                selection: const TextSelection.collapsed(offset: 0),
                                              ),
                                              scrollController: ScrollController(),
                                              focusNode: FocusNode(),
                                            ),),
                                      ],
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 100,
                                    xs: 100,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Regolamento", style: CLTheme.of(context).bodyLabel),
                                        const SizedBox(height: Sizes.padding),
                                        Container(
                                            padding: const EdgeInsets.all(Sizes.padding),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: CLTheme.of(context).alternate),
                                              borderRadius: BorderRadius.circular(Sizes.borderRadius),
                                            ),
                                            child: quill.QuillEditor(
                                              controller: quill.QuillController(
                                                document: vm.ruleTextDoc!,
                                                readOnly: true,
                                                selection: const TextSelection.collapsed(offset: 0),
                                              ),
                                              scrollController: ScrollController(),
                                              focusNode: FocusNode(),
                                            ),),
                                      ],
                                    ),
                                  ),

                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text("Locandina", style: CLTheme.of(context).bodyLabel),
                                        subtitle: CLMediaViewer(
                                          clMediaViewerMode: CLMediaViewerMode.previewMode,
                                          medias: [
                                            CLMedia(
                                              fileUrl: vm.promo.imageUrl,
                                            )
                                          ],
                                        )),
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
