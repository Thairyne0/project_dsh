import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../constants/announcement_routes.costant.dart';
import '../viewmodels/announcement.viewmodel.dart';

class ViewAnnouncementPage extends StatefulWidget {
  const ViewAnnouncementPage({super.key, required this.id});

  final String id;

  @override
  State<ViewAnnouncementPage> createState() => ViewAnnouncementPageState();
}

class ViewAnnouncementPageState extends State<ViewAnnouncementPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<AnnouncementViewModel>.reactive(
        viewModelBuilder: () => AnnouncementViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
            PageAction(
                  title: "Modifica",
                  isMain: true,
                  iconData: Icons.edit,
                  onTap: () async {
                    context.customGoNamed(AnnouncementRoutes.editAnnouncement.name, params: {"id": widget.id}, replacedRouteName: vm.announcement.modelIdentifier);
                  }),
            PageAction(
                  title: "Elimina",
                  isMain: true,
                  isSecondary: true,
                  needConfirmation: true,
                  iconData: Icons.delete,
                  onTap: () async {
                    await vm.deleteAnnouncement(widget.id);
                    appState.refreshList.add(true);
                    context.pop();
                  }),
            ]),
        builder: (context, vm, child) {
          return vm.isBusy
              ? const LoadingWidget()
              : SingleChildScrollView(
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
                                  lg: 100,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Titolo", style: CLTheme.of(context).bodyLabel),
                                    subtitle: Text(vm.announcement.title, style: CLTheme.of(context).bodyText),
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
                                    children: [
                                       Row(
                                          children: [
                                            Text(
                                              'Allegati',
                                              style: CLTheme.of(context).bodyLabel,
                                            ),
                                          ],
                                        ),
                                      CLMediaViewer(
                                        medias: vm.announcement.mediaUrls
                                            .map((url) => CLMedia(
                                          fileUrl: url,
                                        ))
                                            .toList(),
                                        clMediaViewerMode: CLMediaViewerMode.previewMode,
                                      ),
                                    ],
                                  ),
                                )
                               /* ResponsiveGridItem(
                                  lg: 25,
                                  xs: 100,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text("Logo", style: CLTheme.of(context).bodyLabel),
                                    subtitle: Image.network(
                                      vm.announcement.mediaUrls,
                                      fit: BoxFit.cover, // 🔎 Adatta l'immagine al contenitore
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child; // ✅ Mostra l'immagine una volta caricata

                                        // 🔄 Mostra un indicatore di caricamento durante il download
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        // ❌ Mostra un'icona in caso di errore nel caricamento
                                        return const Center(
                                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                        );
                                      },
                                    )
                                  ),
                                ),*/
                              ],
                            ),
                      )
                    ],
                  ),
                );
        });
  }
}
