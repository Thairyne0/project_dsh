import 'package:barcode_widget/barcode_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/widgets/cl_pill.widget.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_action_text.widget.dart';
import '../../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../ui/widgets/table_action_item.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../../../../users/constants/permission_slug.dart';
import '../../../constants/store_routes.constant.dart';
import '../constants/promo_routes.constant.dart';
import '../models/promo.model.dart';
import '../viewmodels/promo.viewmodel.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({super.key});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<PromoViewModel>.reactive(
        viewModelBuilder: () => PromoViewModel(context, VMType.list, null),
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
                        child: PagedDataTable<String, String, Promo>(
                          rowsSelectable: false,
                          idGetter: (promo) => promo.id,
                          controller: vm.promoTableController,
                          fetchPage: vm.getAllPromo,
                          refreshListener: appState.refreshList,
                          initialPage: "1",
                          initialPageSize: 25,
                          onItemTap: (item) {
                            if (authState.hasPermission(PermissionSlugs.dettaglioPromo))
                              context.customGoNamed(PromoRoutes.viewPromo.name, params: {"id": item.id});
                          },
                          actionsBuilder: (item) => [
                            if (authState.hasPermission(PermissionSlugs.updatePromo) && item.status == PromoStatus.pending)
                              TableAction<Promo>(
                                content: TableActionItem(name: "Modifica", iconData: Icons.edit),
                                onTap: (item) {
                                  context.customGoNamed(PromoRoutes.editPromo.name, params: {"id": item.id});
                                },
                              ),
                            TableAction<Promo>(
                              content: TableActionItem(name: "QR Code", iconData: Icons.qr_code_2_rounded),
                              onTap: (item) {
                                _exportPdf(item.code);
                              },
                            ),
                            if (authState.hasPermission(PermissionSlugs.updateStatusPromo)) ...[
                              TableAction<Promo>(
                                content: TableActionItem(name: "Approvato", iconData: Icons.check_circle_outline, iconColor: CLTheme.of(context).success),
                                onTap: (item) {
                                  vm.updatePromoStatus(item.id, 1);
                                },
                              ),
                              TableAction<Promo>(
                                content: TableActionItem(name: "Non Approvato", iconData: Icons.cancel_outlined, iconColor: CLTheme.of(context).danger),
                                onTap: (item) {
                                  vm.updatePromoStatus(item.id, 2);
                                },
                              ),
                              TableAction<Promo>(
                                content: TableActionItem(name: "In Attesa", iconData: Icons.watch_later_outlined, iconColor: CLTheme.of(context).warning),
                                onTap: (item) {
                                  vm.updatePromoStatus(item.id, 0);
                                },
                              ),
                            ]
                          ],
                          columns: [
                            TableColumn(
                              id: "media",
                              title: const Text("Media"),
                              sortable: false,
                              cellBuilder: (item) => CLMediaViewer(
                                medias: [CLMedia(fileUrl: item.imageUrl)],
                                clMediaViewerMode: CLMediaViewerMode.tableMode,
                                resourceName: item.title,
                              ),
                              sizeFactor: .06,
                              isMain: false,
                            ),
                            TableColumn(
                                id: "title",
                                title: const Text("Titolo"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.title,
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .2,
                                isMain: false),
                            TableColumn(
                                id: "startingAt",
                                title: const Text("Inizio"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.startingAtDate,
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .1,
                                isMain: false),
                            TableColumn(
                                id: "endingAt",
                                title: const Text("Fine"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.endingAtDate,
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .1,
                                isMain: false),
                            /*TableColumn(
                                id: "qty",
                                title: const Text("Quantità Massima"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.qty.toString(),
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .1,
                                isMain: false),*/
                            TableColumn(
                                id: "store:name",
                                title: const Text("Store"),
                                sortable: true,
                                cellBuilder: (item) => CLActionText.primary(
                                    text: item.store.name,
                                    onTap: () {
                                      if (authState.hasPermission(PermissionSlugs.dettaglioStore))
                                        context.customGoNamed(StoreRoutes.viewStore.name, params: {"id": item.store.id});
                                    },
                                    context: context),
                                sizeFactor: .15,
                                isMain: false),
                            TableColumn(
                                id: "store:brand:name",
                                title: const Text("Brand"),
                                sortable: true,
                                cellBuilder: (item) => CLActionText.primary(
                                    text: item.store.brand.name,
                                    onTap: () {
                                      if (authState.hasPermission(PermissionSlugs.dettaglioStore))
                                        context.customGoNamed(StoreRoutes.viewStore.name, params: {"id": item.store.id});
                                    },
                                    context: context),
                                sizeFactor: .15,
                                isMain: false),
                            TableColumn(
                              id: "status",
                              title: const Text("Status"),
                              sortable: true,
                              cellBuilder: (item) {
                                Color statusColor;
                                String statusText;
                                IconData statusIcon;
                                switch (item.status.value) {
                                  case 0:
                                    statusColor = CLTheme.of(context).warning;
                                    statusText = "In attesa";
                                    statusIcon = Icons.watch_later;
                                    break;
                                  case 1:
                                    statusColor = CLTheme.of(context).success;
                                    statusText = "Approvato";
                                    statusIcon = Icons.check_circle;
                                    break;
                                  case 2:
                                    statusColor = CLTheme.of(context).danger;
                                    statusText = "Non approvato";
                                    statusIcon = Icons.cancel;
                                    break;
                                  default:
                                    statusColor = Colors.grey;
                                    statusText = "Sconosciuto";
                                    statusIcon = Icons.help;
                                }
                                return CLPill(pillColor: statusColor, pillText: statusText, icon: statusIcon);
                              },
                              sizeFactor: .15,
                              isMain: false,
                            ),
                          ],
                          mainFilter: TextTableFilter(
                            id: "title",
                            title: "Titolo",
                            isMainFilter: true,
                            chipFormatter: (text) => text,
                          ),
                          extraFilters: [],
                          mainMenus: [
                            if (authState.hasPermission(PermissionSlugs.creazionePromo))
                              CLButton.primary(
                                  text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                  onTap: () {
                                    context.customGoNamed(PromoRoutes.newPromo.name, params: {"storeId": "noShop"});
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

  Future<void> _exportPdf(String? code) async {
    final pdf = pw.Document();
    const scale = 5.0;

    pdf.addPage(pw.Page(
      build: (context) => pw.Center(
        child: pw.Column(children: [
          // Generazione del QR code in PDF
          pw.BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: "$code",
            width: 300 * PdfPageFormat.mm / scale,
            height: 300 * PdfPageFormat.mm / scale,
            textStyle: const pw.TextStyle(
              fontSize: 25 * PdfPageFormat.mm / scale,
            ),
          ),
          pw.Paragraph(text: ""),
          // Aggiungi la data e ora corrente
          pw.Paragraph(text: "Data e ora: ${DateFormat("dd/MM/yyyy - HH:mm:ss").format(DateTime.now())}"),
        ]),
      ),
    ));

    // Stampa il PDF generato
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
