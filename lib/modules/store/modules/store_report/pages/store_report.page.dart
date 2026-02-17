import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/modules/store/modules/store_report/constants/store_report_routes.constant.dart';
import 'package:project_dsh/modules/store/modules/store_report/models/store_report.model.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../../ui/widgets/buttons/cl_soft_button.widget.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../ui/widgets/textfield_validator.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../../../utils/providers/authstate.util.provider.dart';
import '../../../../users/constants/permission_slug.dart';
import '../viewmodels/store_report.viewmodel.dart';

class StoreReportPage extends StatefulWidget {
  const StoreReportPage({super.key});

  @override
  State<StoreReportPage> createState() => StoreReportPageState();
}

class StoreReportPageState extends State<StoreReportPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<StoreReportViewModel>.reactive(
        viewModelBuilder: () => StoreReportViewModel(context, VMType.list, null),
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
                        child: PagedDataTable<String, String, StoreReport>(
                          idGetter: (storeReport) => storeReport.id,
                          controller: vm.storeReportTableController,
                          fetchPage: vm.getAllStoreReport,
                          refreshListener: appState.refreshList,
                          initialPage: "1",
                          initialPageSize: 25,
                          onItemTap: (item) {
                            if (authState.hasPermission(PermissionSlugs.dettaglioStoreReport)) {
                              context.customGoNamed(StoreReportRoutes.viewStoreReport.name, params: {"id": item.id});
                            }
                          },
                          columns: [
                            TableColumn(
                                id: "store:name",
                                title: const Text("Negozio"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.store.name,
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .3,
                                isMain: false),
                            TableColumn(
                                id: "store:reportDate",
                                title: const Text("Data"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.reportDateFormat,
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .3,
                                isMain: false),
                          ],
                          mainFilter: TextTableFilter(
                            id: "store:name",
                            title: "Nome store",
                            isMainFilter: true,
                            chipFormatter: (text) => text,
                          ),
                          extraFilters: [
                            /*DateRangePickerTableFilter(
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        chipFormatter: (date) => date.toString(),
                        id: "createdAt",
                        title: "Data",
                        isMainFilter: false,
                      ),*/
                          ],
                          mainMenus: [
                            CLButton.primary(
                                context: context,
                                text: ResponsiveBreakpoints.of(context).isDesktop ? "Download Excel" : "",
                                onTap: () {
                                  vm.reportDateTEC.clear();
                                  vm.selectedReportDateFormat = null;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            backgroundColor: CLTheme.of(context).secondaryBackground,
                                            title: Text("Seleziona una data", style: CLTheme.of(context).title),
                                            content: SizedBox(
                                              width: 300,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CLTextField.date(
                                                    controller: vm.reportDateTEC,
                                                    labelText: "Mese e anno",
                                                    withTime: false,
                                                    withoutDay: true,
                                                    validators: [Validators.required],
                                                    isRequired: true,
                                                    onDateTimeSelected: (picked) {
                                                      vm.selectedReportDateFormat = picked;
                                                    },
                                                  ),
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
                                                    text: 'Download',
                                                    onTap: () async {
                                                      Navigator.of(context).pop();
                                                      await vm.downloadExcelReport();
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
                                icon: Icons.download),
                          ],
                        ),
                      )
                    ],
                  ),
                ))]);
        });
  }
}
