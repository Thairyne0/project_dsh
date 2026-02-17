import 'package:flutter/material.dart';
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
import '../constants/event_category_routes.constant.dart';
import '../viewmodels/event_category.viewmodel.dart';

class ViewEventCategoryPage extends StatefulWidget {
  const ViewEventCategoryPage({super.key, required this.id});

  final String id;

  @override
  State<ViewEventCategoryPage> createState() => _ViewEventCategoryPageState();
}

class _ViewEventCategoryPageState extends State<ViewEventCategoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<EventCategoryViewModel>.reactive(
        viewModelBuilder: () => EventCategoryViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
            PageAction(
                  title: "Modifica",
                  isMain: true,
                  iconData: Icons.edit,
                  onTap: () async {
                    context.customGoNamed(EventCategoryRoutes.editEventCategory.name, params: {"id": widget.id});
                  }),
            PageAction(
                  title: "Elimina",
                  isMain: true,
                  isSecondary: true,
                  needConfirmation: true,
                  iconData: Icons.delete,
                  onTap: () async {
                    await vm.deleteEventCategory(widget.id);
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
                          contentMargin: const EdgeInsets.all(Sizes.padding),
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
                                      title: Text("Nome", style: CLTheme.of(context).bodyLabel),
                                      subtitle: Text(vm.eventCategory.name, style: CLTheme.of(context).bodyText),
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Immagine", style: CLTheme.of(context).bodyLabel),
                                        SizedBox(height: 5),
                                        CLMediaViewer(
                                          clMediaViewerMode: CLMediaViewerMode.previewMode,
                                          medias: [
                                            CLMedia(
                                              fileUrl: vm.eventCategory.imageUrl,
                                            )
                                          ],
                                        )
                                      ],
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
