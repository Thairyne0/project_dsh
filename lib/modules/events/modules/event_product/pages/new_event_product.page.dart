import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
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
import '../../../models/event.model.dart';
import '../viewmodels/event_product.viewmodel.dart';

class NewEventProductPage extends StatefulWidget {
  const NewEventProductPage({super.key, required this.eventId});

  final String eventId;

  @override
  createState() => NewEventProductPageState();
}

class NewEventProductPageState extends State<NewEventProductPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return ViewModelBuilder<EventProductViewModel>.reactive(
        viewModelBuilder: () => EventProductViewModel(context, VMType.create, widget.eventId),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.createEventProduct();
                      appState.refreshList.add(true);
                      context.pop();
                    }
                  }),
            ]),
        builder: (context, vm, child) {
          return vm.isBusy
              ? const LoadingWidget()
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CLContainer(
                          contentMargin: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                          child: Column(
                            children: [
                              ResponsiveGrid(
                                gridSpacing: Sizes.padding,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ResponsiveGridItem(
                                      lg: 25,
                                      xs: 100,
                                      child: Column(
                                        children: [
                                          CLDropdown<Event>.singleAsync(
                                            validators: [Validators.required],
                                            searchCallback: vm.getAllEvent,
                                            searchColumn: "title",
                                            selectedValues: vm.selectedEvent,
                                            isEnabled: vm.selectedEvent == null,
                                            valueToShow: (item) {
                                              return item.modelIdentifier;
                                            },
                                            onSelectItem: (item) {
                                              vm.selectedEvent = item;
                                            },
                                            hint: "Seleziona un Evento",
                                            itemBuilder: (context, item) {
                                              return Text(item.modelIdentifier);
                                            },
                                          ),
                                        ],
                                      )),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.nameTEC, labelText: "Nome", validators: [Validators.required], isRequired: true),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.qtyTEC, labelText: "Quantità", validators: [Validators.required], isRequired: true),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(
                                      controller: vm.qtyPerUserTEC,
                                      labelText: "Quantità per Utente",
                                      validators: [Validators.required],
                                      isRequired: true,
                                    ),
                                  ),

                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField.currency(
                                        initValue: "0",
                                        controller: vm.defaultPriceTEC,
                                        labelText: "Prezzo Standard",
                                        validators: [Validators.required],
                                        isRequired: true,
                                        isEnabled: vm.selectedEvent?.isBuyable ?? false),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField.currency(
                                        initValue: "0",
                                        controller: vm.zeroFourPriceTEC,
                                        labelText: "Prezzo 0-4 Anni",
                                        validators: [Validators.required],
                                        isRequired: true,
                                        isEnabled: vm.selectedEvent?.isBuyable ?? false),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField.currency(
                                        initValue: "0",
                                        controller: vm.under14PriceTEC,
                                        labelText: "Prezzo Under 14 Anni",
                                        validators: [Validators.required],
                                        isRequired: true,
                                        isEnabled: vm.selectedEvent?.isBuyable ?? false),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField.currency(
                                        initValue: "0",
                                        controller: vm.over65PriceTEC,
                                        labelText: "Prezzo Over 65",
                                        validators: [Validators.required],
                                        isRequired: true,
                                        isEnabled: vm.selectedEvent?.isBuyable ?? false),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(
                                        initValue: "0",
                                        controller: vm.defaultPointPriceTEC,
                                        labelText: "Prezzo Punti Standard",
                                        validators: [Validators.required],
                                        isRequired: true,
                                        isEnabled: vm.selectedEvent?.isBuyable ?? false),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(
                                        initValue: "0",
                                        controller: vm.zeroFourPointPriceTEC,
                                        labelText: "Prezzo Punti 0-4 Anni",
                                        validators: [Validators.required],
                                        isRequired: true,
                                        isEnabled: vm.selectedEvent?.isBuyable ?? false),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(
                                        initValue: "0",
                                        controller: vm.under14PointPriceTEC,
                                        labelText: "Prezzo Punti Under 14 Anni",
                                        validators: [Validators.required],
                                        isRequired: true,
                                        isEnabled: vm.selectedEvent?.isBuyable ?? false),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(
                                        initValue: "0",
                                        controller: vm.over65PointPriceTEC,
                                        labelText: "Prezzo Punti Over 65",
                                        validators: [Validators.required],
                                        isRequired: true,
                                        isEnabled: vm.selectedEvent?.isBuyable ?? false),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 100,
                                    xs: 100,
                                    child: CLTextField.quill(
                                      quillController: vm.descriptionTEC,
                                      labelText: "Descrizione",
                                      validators: [Validators.required],
                                      isRequired: true,
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 100,
                                    xs: 100,
                                    child: Text(
                                        "Informazione: Se inserisci 0 in uno o più campi, questo prodotto,per la relativa fascia, sarà considerato gratuito."),
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
