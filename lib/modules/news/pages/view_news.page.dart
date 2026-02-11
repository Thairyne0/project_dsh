import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
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
import '../constants/news_routes.costant.dart';
import '../viewmodels/news.viewmodel.dart';


class ViewNewsPage extends StatefulWidget {
  const ViewNewsPage({super.key, required this.id});

  final String id;

  @override
  State<ViewNewsPage> createState() => _ViewNewsPageState();
}

class _ViewNewsPageState extends State<ViewNewsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = context.read<AuthState>();
    return ViewModelBuilder<NewsViewModel>.reactive(
        viewModelBuilder: () => NewsViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
            PageAction(
                  title: "Modifica",
                  isMain: true,
                  iconData: Icons.edit,
                  onTap: () async {
                    context.customGoNamed(NewsRoutes.editNews.name, params: {"id": widget.id}, replacedRouteName: vm.news.modelIdentifier);
                  }),
            PageAction(
                  title: "Elimina",
                  isMain: true,
                  isSecondary: true,
                  needConfirmation: true,
                  iconData: Icons.delete,
                  onTap: () async {
                    await vm.deleteNews(widget.id);
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
                                  lg: 33,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Titolo", style: CLTheme.of(context).bodyLabel),
                                    subtitle: Text("${vm.news.title}", style: CLTheme.of(context).bodyText),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 33,
                                  xs: 100,
                                  child: ListTile(
                                    minVerticalPadding: 0,
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Data inizio", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                    subtitle: SelectableText("${vm.news.startingAtDate}", style: CLTheme.of(context).bodyText),
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 33,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    minVerticalPadding: 0,
                                    title: Text("Data fine", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                    subtitle: Text("${vm.news.endingAtDate}", style: CLTheme.of(context).bodyText),
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
                                  lg: 25,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text("Locandina", style: CLTheme.of(context).bodyLabel),
                                    subtitle: CLMediaViewer(
                                      clMediaViewerMode: CLMediaViewerMode.previewMode,
                                      medias: [
                                        CLMedia(
                                          fileUrl: vm.news.imageUrl,
                                        )
                                      ],
                                    )
                                  ),
                                ),
                                ResponsiveGridItem(
                                  lg: 100,
                                  xs: 100,
                                  child: ListTile(
                                    minVerticalPadding: 0,
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("In evidenza?", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      vm.news.isHighlighted ? 'Si' : 'No',
                                      style: CLTheme.of(context).bodyText,
                                    ),
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
