import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/cl_theme.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_dropdown/cl_dropdown.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/textfield_validator.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../constants/store_routes.constant.dart';
import '../../../models/store.model.dart';
import '../viewmodels/store_report.viewmodel.dart';

class NewStoreReportPage extends StatefulWidget {
  const NewStoreReportPage({super.key, required this.storeId});
  final String storeId;


  @override
  createState() => NewStoreReportPageState();
}

class NewStoreReportPageState extends State<NewStoreReportPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoreReportViewModel>.reactive(
        viewModelBuilder: () => StoreReportViewModel(context, VMType.create, widget.storeId),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.createStoreReport();
                      context.read<AppState>().markForRefresh();
                      context.customGoNamed(StoreRoutes.stores.name);
                    }
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
                    key: _formKey,
                    child: CLContainer(
                      contentMargin: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                      child: ResponsiveGrid(
                        gridSpacing: Sizes.padding,
                        children: [
                          ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: Column(
                                children: [
                                  CLDropdown<Store>.singleAsync(
                                    validators: [Validators.required],
                                    searchCallback: vm.getAllStore,
                                    searchColumn: "title",
                                    selectedValues: vm.selectedStore,
                                    isEnabled: vm.selectedStore == null,
                                    valueToShow: (item) {
                                      return item.modelIdentifier;
                                    },
                                    onSelectItem: (item) {
                                      vm.selectedStore = item;
                                    },
                                    hint: "Seleziona uno Store",
                                    itemBuilder: (context, item) {
                                      return Text(item.modelIdentifier);
                                    },
                                  ),
                                ],
                              )),
                          ResponsiveGridItem(
                            lg: 50,
                            xs: 100,
                            child: CLTextField.date(
                              controller: vm.reportDateTEC,
                              labelText: "Mese e anno del report",
                              withTime: false,
                              withoutDay: true,
                              validators: [Validators.required],
                              isRequired: true,
                              onDateTimeSelected: (picked) {
                                vm.selectedReportDateFormat = picked;
                              },
                            ),
                          ),
                          ResponsiveGridItem(
                            lg: 50,
                            xs: 50,
                            child: CLTextField.number(controller: vm.ingressiTEC, labelText: "Numero ingressi (ove presente il contapersone)"),
                          ),
                          ResponsiveGridItem(
                              lg: 100,
                              xs: 100,
                              child: Row(
                                children: [
                                  Text(
                                    "Valore dati",
                                    style: CLTheme.of(context).title,
                                  ),
                                  SizedBox(
                                    width: 22,
                                  ),
                                  Expanded(child: Divider(color: CLTheme.of(context).alternate, thickness: 2))
                                ],
                              )),
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.imponibile22TEC, labelText: "",withDecimal: true,)),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.imponibile10TEC, labelText: "",withDecimal: true)),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.imponibile5TEC, labelText:"",withDecimal: true)),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.imponibile4TEC, labelText: "",withDecimal: true)),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.imponibile0TEC, labelText: "",withDecimal: true)),
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
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.iva22TEC, labelText: "",withDecimal: true)),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.iva10TEC, labelText: "",withDecimal: true )),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.iva5TEC, labelText: "",withDecimal: true )),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.iva4TEC, labelText: "",withDecimal: true )),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.iva0TEC, labelText: "",withDecimal: true )),
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
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.totale22TEC, labelText: "",withDecimal: true)),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.totale10TEC, labelText: "",withDecimal: true)),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.totale5TEC, labelText: "",withDecimal: true)),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.totale4TEC, labelText: "",withDecimal: true)),
                          ResponsiveGridItem(lg: 16, xs: 100, child: CLTextField.number(controller: vm.totale0TEC, labelText: "",withDecimal: true)),
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
                              child: CLTextField.number(
                                controller: vm.numeroScontrini22TEC,
                                labelText: "",
                                  withDecimal: true
                              )),
                          ResponsiveGridItem(
                              lg: 16,
                              xs: 100,
                              child: CLTextField.number(
                                controller: vm.numeroScontrini10TEC,
                                labelText: "",
                                  withDecimal: true
                              )),
                          ResponsiveGridItem(
                              lg: 16,
                              xs: 100,
                              child: CLTextField.number(
                                controller: vm.numeroScontrini5TEC,
                                labelText: "",
                                  withDecimal: true
                              )),
                          ResponsiveGridItem(
                              lg: 16,
                              xs: 100,
                              child: CLTextField.number(
                                controller: vm.numeroScontrini4TEC,
                                labelText: "",
                                  withDecimal: true
                              )),
                          ResponsiveGridItem(
                              lg: 16,
                              xs: 100,
                              child: CLTextField.number(
                                controller: vm.numeroScontrini0TEC,
                                labelText: "",
                                  withDecimal: true
                              )),
                          ResponsiveGridItem(lg: 100, xs: 100, child: CLTextField.textArea(controller: vm.noteTEC, labelText: "Note del report",)),
                          ResponsiveGridItem(
                              lg: 100,
                              xs: 100,
                              child: RichText(
                                key: Key('richTextWidget'), // Aggiungiamo una key per il test
                                text: TextSpan(
                                  text: 'Il presente form, correttamente compilato, va inviato ',
                                  style: CLTheme.of(context).bodyText.copyWith(color: CLTheme.of(context).secondaryText),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "entro e non oltre il giorno 5 del mese successivo a quello di riferimento",
                                      style: CLTheme.of(context).bodyText.copyWith(color: CLTheme.of(context).primary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ))]);
        });
  }
}
