import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/modules/events/models/user_eventProduct.model.dart';
import 'package:project_dsh/modules/events/modules/event_product/costants/event_product_routes.costant.dart';
import 'package:project_dsh/modules/events/modules/event_product/models/event_product.model.dart';
import 'package:project_dsh/ui/widgets/cl_file_picker.widget.dart';
import 'package:project_dsh/ui/widgets/excerpt_text.widget.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../ui/cl_theme.dart';
import '../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../ui/widgets/cl_container.widget.dart';
import '../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../ui/widgets/loading.widget.dart';
import '../../../../utils/base.viewmodel.dart';
import '../../../../utils/models/pageaction.model.dart';
import '../../../../utils/providers/appstate.util.provider.dart';
import '../../../ui/widgets/buttons/cl_action_text.widget.dart';
import '../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../ui/widgets/buttons/cl_soft_button.widget.dart';
import '../../../ui/widgets/cl_clipboard.widget.dart';
import '../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../ui/widgets/cl_pill.widget.dart';
import '../../../ui/widgets/cl_tabs/cl_tab_item.model.dart';
import '../../../ui/widgets/cl_tabs/cl_tab_view.widget.dart';
import '../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../ui/widgets/table_action_item.widget.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../constants/event_routes.constant.dart';
import '../models/event.model.dart';
import '../modules/event_category/constants/event_category_routes.constant.dart';
import '../viewmodels/event.viewmodel.dart';

class ViewEventPage extends StatefulWidget {
  const ViewEventPage({super.key, required this.id});

  final String id;

  @override
  State<ViewEventPage> createState() => _ViewEventPageState();
}

class _ViewEventPageState extends State<ViewEventPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<EventViewModel>.reactive(
        viewModelBuilder: () => EventViewModel(context, VMType.detail, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
                PageAction(
                    title: "Modifica",
                    isMain: true,
                    iconData: Icons.edit,
                    onTap: () async {
                      context.customGoNamed(EventRoutes.editEvent.name, params: {"id": widget.id}, replacedRouteName: vm.event.modelIdentifier);
                    }),
                PageAction(
                    title: "Elimina",
                    isMain: true,
                    isSecondary: true,
                    needConfirmation: true,
                    iconData: Icons.delete,
                    onTap: () async {
                      await vm.deleteEvent(widget.id);
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
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.padding),
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
                                    title: Text("Categoria Evento", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                    subtitle: CLActionText.primary(
                                        text: vm.event.eventCategory.name,
                                        onTap: () {
                                            context.customGoNamed(EventCategoryRoutes.viewEventCategory.name,
                                                params: {"id": vm.event.eventCategory.id}, replacedRouteName: vm.event.eventCategory.name);
                                        },
                                        context: context),
                                  )),
                              ResponsiveGridItem(
                                lg: 33,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Titolo", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Text(vm.event.title, style: CLTheme.of(context).bodyText),
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
                                  subtitle: SelectableText(vm.event.startingAtDate, style: CLTheme.of(context).bodyText),
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
                                  subtitle: Text(vm.event.endingAtDate, style: CLTheme.of(context).bodyText),
                                ),
                              ),
                              ResponsiveGridItem(
                                  lg: 33,
                                  xs: 100,
                                  child: ListTile(
                                    minVerticalPadding: 0,
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Store", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                    subtitle: CLActionText.primary(
                                        text: "",
                                        onTap: () {
                                        },
                                        context: context),
                                  )),
                              ResponsiveGridItem(
                                lg: 33,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Location", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: CLActionText.primary(
                                      text: "",
                                      onTap: () {
                                      },
                                      context: context),
                                ),
                              ),
                              ResponsiveGridItem(
                                lg: 33,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Punti da assegnare", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Text("${vm.event.pointsReward}", style: CLTheme.of(context).bodyText),
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
                                      ),
                                    ),
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ResponsiveGridItem(
                                  lg: 100,
                                  xs: 100,
                                  child: ListTile(
                                    minVerticalPadding: 0,
                                    contentPadding: EdgeInsets.zero,
                                    minTileHeight: 0,
                                    title: Text("Media", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                    subtitle: CLMediaViewer(
                                      clMediaViewerMode: CLMediaViewerMode.previewMode,
                                      medias: [
                                        CLMedia(
                                          fileUrl: vm.event.imageUrl,
                                        )
                                      ],
                                    ),
                                  )),
                              ResponsiveGridItem(
                                lg: 25,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("In evidenza?", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    vm.event.isHighlighted ? 'Si' : 'No',
                                    style: CLTheme.of(context).bodyText,
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
                                  title: Text("Partecipanti totali", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    "${vm.event.totalParticipant}",
                                    style: CLTheme.of(context).bodyText,
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
                                  title: Text(
                                    "Picco di partecipanti",
                                    style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    vm.event.participantPeakDate != null
                                        ? "${vm.event.participantPeak} partecipanti alle ${vm.event.participantPeakDateFormatted}"
                                        : "Nessun picco registrato",
                                    style: CLTheme.of(context).bodyText,
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
                                  title: Text(
                                    "Status",
                                    style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Builder(builder: (ctx) {
                                    Color statusColor;
                                    String statusText;
                                    IconData statusIcon;
                                    switch (vm.event.status.value) {
                                      case 0:
                                        statusColor = CLTheme.of(ctx).warning;
                                        statusText = "In attesa";
                                        statusIcon = Icons.watch_later;
                                        break;
                                      case 1:
                                        statusColor = CLTheme.of(ctx).success;
                                        statusText = "Approvato";
                                        statusIcon = Icons.check_circle;
                                        break;
                                      case 2:
                                        statusColor = CLTheme.of(ctx).danger;
                                        statusText = "Non approvato";
                                        statusIcon = Icons.cancel;
                                        break;
                                      default:
                                        statusColor = Colors.grey;
                                        statusText = "Sconosciuto";
                                        statusIcon = Icons.help;
                                    }
                                    return CLPill(
                                      pillColor: statusColor,
                                      pillText: statusText,
                                      icon: statusIcon,
                                    );
                                  }),
                                ),
                              ),
                              ResponsiveGridItem(
                                lg: 100,
                                xs: 100,
                                child: Row(
                                  children: [
                                    Text(
                                      'Configurazioni aggiuntive',
                                      style: CLTheme.of(context).bodyLabel,
                                    ),
                                    SizedBox(width: 22),
                                    Expanded(
                                      child: Divider(thickness: 2, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                              ResponsiveGridItem(
                                lg: 25,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Acquistabile?", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    vm.event.isBuyable ? 'Si' : 'No',
                                    style: CLTheme.of(context).bodyText,
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
                                  title: Text("Euro+Punti?", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    vm.event.isBothMoneyAndPoints ? 'Si' : 'No',
                                    style: CLTheme.of(context).bodyText,
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
                                  title: Text("Azione aggiuntiva necessaria?", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    vm.event.additionalPurchase ? 'Si' : 'No',
                                    style: CLTheme.of(context).bodyText,
                                  ),
                                ),
                              ),
                              if (vm.event.additionalPurchase)
                                ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: ListTile(
                                      minVerticalPadding: 0,
                                      contentPadding: EdgeInsets.zero,
                                      minTileHeight: 0,
                                      title:
                                          Text("Store per validazione acquisto", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                      subtitle: CLActionText.primary(
                                          text: "",
                                          onTap: () {
                                          },
                                          context: context),
                                    )),
                              ResponsiveGridItem(
                                lg: 100,
                                xs: 100,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  minTileHeight: 0,
                                  title: Text("Descrizione aggiuntiva", style: CLTheme.of(context).smallLabel.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: ExcerptText(text: vm.event.additionalPurchaseDescription, textStyle: CLTheme.of(context).bodyText),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Sizes.padding),
                          CLTabView(clTabItems: [
                            CLTabItem(
                                tabName: "Prodotti Evento",
                                tabContent: Center(
                                    child: PagedDataTable<String, String, EventProduct>(
                                  rowsSelectable: false,
                                  showBorder: false,
                                  idGetter: (eventProduct) => eventProduct.id,
                                  controller: vm.eventProductTableController,
                                  fetchPage: vm.getEventProductByEvent,
                                  initialPage: "1",
                                  initialPageSize: 25,
                                  onItemTap: (item) {
                                      context.customGoNamed(EventProductRoutes.viewEventProduct.name,
                                          params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                                  },
                                  actionsBuilder: (item) => [
                                      TableAction<EventProduct>(
                                        content: TableActionItem(name: "Modifica", iconData: Icons.edit),
                                        onTap: (item) {
                                          context.customGoNamed(EventProductRoutes.editEventProduct.name,
                                              params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                                        },
                                      ),
                                    /*TableAction<EventProduct>(
                                    content: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      hoverColor: Colors.transparent,
                                      leading: Icon(Icons.delete, size: Sizes.medium, color: CLTheme.of(context).primaryText),
                                      title: Text("Elimina", style: CLTheme.of(context).bodyText),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: Sizes.small, color: CLTheme.of(context).primaryText),
                                    ),
                                    onTap: (item) async {
                                      await vm.deleteEvent(item.id);
                                      appState.refreshList.add(true);
                                    },
                                  )*/
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
                                        sizeFactor: .2,
                                        isMain: false),
                                    TableColumn(
                                        id: "qty",
                                        title: const Text("Quantità"),
                                        sortable: true,
                                        cellBuilder: (item) => Text(
                                              item.qty.toString(),
                                              style: CLTheme.of(context).bodyText,
                                            ),
                                        sizeFactor: .2,
                                        isMain: false),
                                    TableColumn(
                                        id: "qtyPerUser",
                                        title: const Text("Quantità per utente"),
                                        sortable: true,
                                        cellBuilder: (item) => Text(
                                              item.qtyPerUser.toString(),
                                              style: CLTheme.of(context).bodyText,
                                            ),
                                        sizeFactor: .3,
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
                                      CLButton.primary(
                                          text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                          onTap: () {
                                            context.customGoNamed(EventProductRoutes.newEventProduct.name, params: {"eventId": widget.id});
                                          },
                                          context: context,
                                          icon: Icons.add),
                                  ],
                                ))),
                              CLTabItem(
                                  tabName: "Utenti registrati",
                                  tabContent: Center(
                                      child: PagedDataTable<String, String, UserEventProduct>(
                                    rowsSelectable: false,
                                    showBorder: false,
                                    idGetter: (userEventProduct) => userEventProduct.id,
                                    controller: vm.userEventProductTableController,
                                    fetchPage: vm.getAllUserEventProducts,
                                    initialPage: "1",
                                    refreshListener: appState.refreshList,
                                    initialPageSize: 25,
                                    onItemTap: (item) {
                                      /*context.customGoNamed(UserRoutes.viewUser.name,
                                      params: {"id": widget.id}, replacedRouteName: vm.user.modelIdentifier);*/
                                    },
                                    /*tableActions: [
                                  TableAction<User>(
                                    content: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      hoverColor: Colors.transparent,
                                      leading: Icon(Icons.edit, size: Sizes.medium, color: CLTheme.of(context).primaryText),
                                      title: Text("Modifica", style: CLTheme.of(context).bodyText),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: Sizes.small, color: CLTheme.of(context).primaryText),
                                    ),
                                    onTap: (item) {
                                      context.customGoNamed(UserRoutes.editUser.name,
                                          params: {"id": widget.id}, replacedRouteName: vm.user.modelIdentifier);
                                    },
                                  )
                                ],*/
                                    columns: [
                                      TableColumn(
                                          id: "progressive",
                                          title: const Text("N°"),
                                          sortable: true,
                                          cellBuilder: (item) => Text(
                                                item.progressive != null ? item.progressive.toString() : '-',
                                                style: CLTheme.of(context).bodyText,
                                              ),
                                          sizeFactor: .05,
                                          isMain: false),
                                      TableColumn(
                                          id: "userEventProduct:user:userData:firstName",
                                          title: const Text("Acquirente"),
                                          sortable: true,
                                          cellBuilder: (item) => Text(
                                                "${item.user.userData.firstName} ${item.user.userData.lastName}",
                                                style: CLTheme.of(context).bodyText,
                                              ),
                                          sizeFactor: .1,
                                          isMain: false),
                                      TableColumn(
                                        id: "firstName",
                                        title: const Text("Intestatario"),
                                        sortable: true,
                                        cellBuilder: (item) {
                                          if (item.firstName!.isEmpty) {
                                            return Text(
                                              "N/A",
                                              style: CLTheme.of(context).bodyText,
                                            );
                                          }
                                          return Text(
                                            "${item.firstName} ${item.lastName}",
                                            style: CLTheme.of(context).bodyText,
                                          );
                                        },
                                        sizeFactor: .1,
                                        isMain: false,
                                      ),
                                      TableColumn(
                                          id: "code",
                                          title: const Text("Codice"),
                                          sortable: true,
                                          cellBuilder: (item) => CLClipboardWidget(
                                                text: item.code,
                                                textStyle: CLTheme.of(context).bodyText,
                                                showAlert: true,
                                              ),
                                          sizeFactor: .3,
                                          isMain: false),
                                      TableColumn(
                                          id: "ageRange",
                                          title: const Text("Range Età"),
                                          sortable: true,
                                          cellBuilder: (item) => Text(
                                                item.ageRange.label.toString(),
                                                style: CLTheme.of(context).bodyText,
                                              ),
                                          sizeFactor: .1,
                                          isMain: false),
                                      TableColumn(
                                          id: "media",
                                          title: const Text("Media"),
                                          sortable: false,
                                          cellBuilder: (item) => item.mediaUrls.isNotEmpty
                                              ? CLMediaViewer(
                                                  medias: item.mediaUrls.map((mediaUrl) => CLMedia(fileUrl: mediaUrl)).toList(),
                                                  clMediaViewerMode: CLMediaViewerMode.tableMode,
                                                )
                                              : Text(
                                                  "-",
                                                  style: CLTheme.of(context).bodyText,
                                                ),
                                          sizeFactor: .2,
                                          isMain: false),
                                      TableColumn(
                                        id: "policyAcceptance",
                                        title: Tooltip(
                                            message: 'Accetta la privacy policy?', child: Icon(Icons.policy_rounded, color: CLTheme.of(context).secondaryText)),
                                        sortable: true,
                                        cellBuilder: (item) => Text(
                                          item.policyAcceptance ? "Sì" : "No",
                                          style: CLTheme.of(context).bodyText,
                                        ),
                                        sizeFactor: .05,
                                        isMain: false,
                                      ),
                                      TableColumn(
                                        id: "isPierluigi",
                                        title: Tooltip(
                                            message: 'Portatore di handicap?',
                                            child: Icon(Icons.wheelchair_pickup_rounded, color: CLTheme.of(context).secondaryText)),
                                        sortable: true,
                                        cellBuilder: (item) => Text(
                                          item.isPierluigi ? "Sì" : "No",
                                          style: CLTheme.of(context).bodyText,
                                        ),
                                        sizeFactor: .05,
                                        isMain: false,
                                      ),
                                    ],
                                    mainFilter: TextTableFilter(
                                      id: "user:userData:firstName",
                                      title: "Acquirente",
                                      isMainFilter: true,
                                      chipFormatter: (text) => text,
                                    ),
                                    extraFilters: [],
                                    mainMenus: [
                                        CLButton.primary(
                                            text: ResponsiveBreakpoints.of(context).isDesktop ? "Carica foto evento" : "",
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  DateTime? selectedDate;
                                                  return StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return AlertDialog(
                                                        backgroundColor: CLTheme.of(context).secondaryBackground,
                                                        title: Text("Seleziona un file zip", style: CLTheme.of(context).title),
                                                        content: SizedBox(
                                                          width: 600,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Center(
                                                                child: ClFilePicker.single(
                                                                  onPickedFile: (file) {
                                                                    vm.bulkMediaFile = file;
                                                                    // gestisci il file qui
                                                                  },
                                                                  allowedExtensions: ["zip"],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Text(
                                                                "Per caricare correttamente le immagini dei partecipanti all’evento, è necessario utilizzare un file ZIP contenente esclusivamente le foto associate ai biglietti. Ogni immagine deve essere nominata utilizzando il codice del biglietto del partecipante. Nel caso in cui un partecipante abbia più foto, i file devono essere rinominati seguendo questa convenzione: codicebiglietto_1.jpg, codicebiglietto_2.jpg, e così via. Solo le immagini verranno elaborate, e tutte le altre tipologie di file verranno ignorate.",
                                                                style: CLTheme.of(context)
                                                                    .smallText
                                                                    .copyWith(color: CLTheme.of(context).secondaryText, fontStyle: FontStyle.italic),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              CLSoftButton.danger(
                                                                text: 'Annulla',
                                                                onTap: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                context: context,
                                                                iconAlignment: IconAlignment.start,
                                                              ),
                                                              CLButton.primary(
                                                                text: 'Carica',
                                                                onTap: () async {
                                                                  await vm.bulkUploadUserEventProductMedia(vm.event.id);
                                                                  appState.refreshList.add(true);
                                                                  Navigator.of(context).pop();
                                                                },
                                                                context: context,
                                                                iconAlignment: IconAlignment.start,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            context: context,
                                            icon: Icons.upload_file),
                                    ],
                                  ))),
                          ]),
                        SizedBox(height: Sizes.padding),
                      ],
                    ),
                  ),
                ))]);
        });
  }
}
