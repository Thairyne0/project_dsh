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

class EditEventProductPage extends StatefulWidget {
  const EditEventProductPage({super.key, required this.id});

  final String id;

  @override
  State<EditEventProductPage> createState() => EditEventProductPageState();
}

class EditEventProductPageState extends State<EditEventProductPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return ViewModelBuilder<EventProductViewModel>.reactive(
        viewModelBuilder: () => EventProductViewModel(context, VMType.edit, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.updateEventProduct(widget.id);
                      context.read<AppState>().markForRefresh();
                    context.pop();}
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
                          contentMargin: const EdgeInsets.symmetric(horizontal:Sizes.padding),
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
                                          searchColumn: "name",
                                          valueToShow: (item) {
                                            return item.title;
                                          },
                                          selectedValues: vm.selectedEvent,
                                          onSelectItem: (item) {
                                            vm.selectedEvent = item;
                                          },
                                          hint: "Seleziona Evento",
                                          itemBuilder: (context, item) {
                                            return Text(item.title);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.nameTEC, labelText: "Nome", validators: [Validators.required]),
                                  ),

                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.qtyTEC, labelText: "Quantità", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.qtyPerUserTEC, labelText: "Quantità per utente", validators: [Validators.required]),
                                  ),

                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.defaultPriceTEC, labelText: "Prezzo Standard", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.zeroFourPriceTEC, labelText: "Prezzo 0-4 Anni", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.under14PriceTEC, labelText: "Prezzo Under 14 Anni", validators: [Validators.required],),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.over65PriceTEC, labelText: "Prezzo Over 65", validators: [Validators.required],
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.defaultPointPriceTEC, labelText: "Prezzo Punti Standard", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.zeroFourPointPriceTEC, labelText: "Prezzo Punti 0-4 Anni", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.under14PointPriceTEC, labelText: "Prezzo Punti Under 14 Anni", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100, child: CLTextField(controller: vm.over65PointPriceTEC, labelText: "Prezzo Punti Over 65", validators: [Validators.required],
                                  ),
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
                                    child:Text("Informazione: Se inserisci 0 in uno o più campi, questo prodotto,per la relativa fascia, sarà considerato gratuito."),
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
