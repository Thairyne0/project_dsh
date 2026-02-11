import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/widgets/buttons/cl_action_text.widget.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../../../constants/event_routes.constant.dart';
import '../costants/event_product_routes.costant.dart';
import '../viewmodels/event_product.viewmodel.dart';

class ViewEventProductPage extends StatefulWidget {
  const ViewEventProductPage({super.key, required this.id});

  final String id;

  @override
  State<ViewEventProductPage> createState() => _ViewEventProductPageState();
}

class _ViewEventProductPageState extends State<ViewEventProductPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<EventProductViewModel>.reactive(
        viewModelBuilder: () => EventProductViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
            PageAction(
              title: "Modifica",
              isMain: true,
              iconData: Icons.edit,
              onTap: () async {
                context.customGoNamed(EventProductRoutes.editEventProduct.name, params: {"id": widget.id});
              }),
            PageAction(
              title: "Elimina",
              isMain: true,
              isSecondary: true,
              needConfirmation: true,
              iconData: Icons.delete,
              onTap: () async {
                await vm.deleteEventProduct(widget.id);
                appState.refreshList.add(true);
                context.pop();
              }),
        ]),
        builder: (context, vm, child) {
          return vm.isBusy
              ? const LoadingWidget()
              : SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  CLContainer(
                    contentMargin: const EdgeInsets.symmetric(horizontal:Sizes.padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveGrid(
                          gridSpacing: Sizes.padding,
                          mainAxisAlignment: MainAxisAlignment.start,
                          showHorizontalDivider: true,
                          children: [
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Evento", style: CLTheme.of(context).bodyLabel),
                                subtitle: CLActionText.primary(
                                  text: vm.eventProduct.event.title,
                                  onTap: () {
                                      context.customGoNamed(EventRoutes.viewEvent.name, params: {"id": vm.eventProduct.event.id});
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
                                title: Text("Nome", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.name}", style: CLTheme.of(context).bodyText),
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Quantità", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.qty}", style: CLTheme.of(context).bodyText),
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Utilizzo per utente", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.qtyPerUser}", style: CLTheme.of(context).bodyText),
                              ),
                            ),

                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Prezzo Standard", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.defaultPrice} €", style: CLTheme.of(context).bodyText),
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Prezzo 0-4 anni", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.zeroFourPrice} €", style: CLTheme.of(context).bodyText),
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Prezzo Under 14 anni", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.under14Price} €", style: CLTheme.of(context).bodyText),
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Prezzo over 65 anni", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.over65Price} €", style: CLTheme.of(context).bodyText),
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Prezzo Punti Standard", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.defaultPointPrice} Pt", style: CLTheme.of(context).bodyText),
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Prezzo Punti 0-4 anni", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.zeroFourPointPrice} Pt", style: CLTheme.of(context).bodyText),
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Prezzo Punti Under 14 anni", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.under14PointPrice} Pt", style: CLTheme.of(context).bodyText),
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ListTile(
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                minTileHeight: 0,
                                title: Text("Prezzo Punti over 65 anni", style: CLTheme.of(context).bodyLabel),
                                subtitle: Text("${vm.eventProduct.over65PointPrice} Pt", style: CLTheme.of(context).bodyText),
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
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
