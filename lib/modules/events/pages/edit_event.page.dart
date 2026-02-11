import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/widgets/cl_file_picker.widget.dart';
import 'package:project_dsh/ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import 'package:project_dsh/ui/widgets/cl_text_field.widget.dart';
import '../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../ui/widgets/cl_container.widget.dart';
import '../../../../ui/widgets/cl_dropdown/cl_dropdown.dart';
import '../../../../ui/widgets/loading.widget.dart';
import '../../../../ui/widgets/textfield_validator.dart';
import '../../../../utils/base.viewmodel.dart';
import '../../../../utils/models/pageaction.model.dart';
import '../../../../utils/providers/appstate.util.provider.dart';
import '../../../ui/cl_theme.dart';
import '../modules/event_category/models/event_category.model.dart';
import '../viewmodels/event.viewmodel.dart';

class EditEventPage extends StatefulWidget {
  EditEventPage({super.key, required this.id});

  final String id;

  @override
  createState() => EditEventPageState();
}

class EditEventPageState extends State<EditEventPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool imageAvailable = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return ViewModelBuilder<EventViewModel>.reactive(
        viewModelBuilder: () => EventViewModel(context, VMType.edit, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.updateEvent(widget.id);
                      context.read<AppState>().markForRefresh();
                      context.pop();
                    }
                  }),
            ]),
        builder: (context, vm, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(),
            child: vm.isBusy
                ? const LoadingWidget()
                : CustomScrollView(
                slivers: [
            SliverPadding(
            padding: const EdgeInsets.only(top: Sizes.headerOffset),
            sliver: SliverToBoxAdapter(
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
                                        lg: 50,
                                        xs: 100,
                                        child: Column(
                                          children: [
                                            CLDropdown<EventCategory>.singleAsync(
                                              validators: [Validators.required],
                                              searchCallback: vm.getAllEventCategory,
                                              searchColumn: "name",
                                              valueToShow: (item) => item.modelIdentifier,
                                              onSelectItem: (item) {
                                                vm.selectedEventCategory = item!;
                                              },
                                              hint: "Seleziona una categoria",
                                              selectedValues: vm.event.eventCategory,
                                              itemBuilder: (context, item) {
                                                return Text(item.modelIdentifier);
                                              },
                                            )
                                          ],
                                        )),
                                    ResponsiveGridItem(lg: 50, xs: 100, child: Container()),
                                    ResponsiveGridItem(
                                      lg: 50,
                                      xs: 100,
                                      child: CLTextField(controller: vm.titleTEC, labelText: "Titolo", validators: [Validators.required]),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 50,
                                      xs: 100,
                                      child: CLTextField(controller: vm.pointsRewardTEC, labelText: "Punti da assegnare", validators: [Validators.required]),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 50,
                                      xs: 100,
                                      child: CLTextField.date(
                                          controller: vm.startingAtTEC,
                                          labelText: "Data inizio",
                                          validators: [Validators.required],
                                          withTime: true,
                                          initialSelectedDateTime: vm.selectedStartingAtDate,
                                          onDateTimeSelected: (date) {
                                            vm.selectedStartingAtDate = date;
                                          }),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 50,
                                      xs: 100,
                                      child: CLTextField.date(
                                          controller: vm.endingAtTEC,
                                          labelText: "Data fine",
                                          validators: [Validators.required],
                                          withTime: true,
                                          initialSelectedDateTime: vm.selectedEndingAtDate,
                                          onDateTimeSelected: (date) {
                                            vm.selectedEndingAtDate = date;
                                          }),
                                    ),
                                    ResponsiveGridItem(
                                        lg: 50,
                                        xs: 100,
                                        child: Column(
                                          children: [

                                          ],
                                        )),
                                    ResponsiveGridItem(
                                        lg: 50,
                                        xs: 100,
                                        child: Column(
                                          children: [

                                          ],
                                        )),
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
                                      child: CLTextField.quill(
                                        quillController: vm.ruleTextTEC,
                                        labelText: "Regolamento",
                                        validators: [Validators.required],
                                        isRequired: true,
                                      ),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 100,
                                      xs: 100,
                                      child: ClFilePicker.single(
                                        initialFile: vm.imageFile,
                                        allowedExtensions: ['jpg', 'jpeg', 'png'],
                                        onPickedFile: (file) async {
                                          vm.imageFile = file;
                                        },
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
                                      lg: 50,
                                      xs: 100,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: vm.isBuyable,
                                            onChanged: (bool? newValue) {
                                              setState(() {
                                                vm.isBuyable = newValue ?? false;
                                              });
                                            },
                                          ),
                                          const Text('Acquistabile?'),
                                        ],
                                      ),
                                    ),
                                    if (vm.isBuyable)
                                      ResponsiveGridItem(
                                        lg: 50,
                                        xs: 100,
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: vm.isBothMoneyAndPoints,
                                              onChanged: (bool? newValue) {
                                                vm.setIsBothMoneyAndPoints(newValue!);
                                              },
                                            ),
                                            const Text('Euro+Punti?'),
                                          ],
                                        ),
                                      ),


                                    ResponsiveGridItem(
                                      lg: 50,
                                      xs: 100,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: vm.additionalPurchase,
                                            onChanged: (bool? newValue) {
                                              setState(() {
                                                vm.additionalPurchase = newValue ?? false;
                                              });
                                            },
                                          ),
                                          const Text('Azione aggiuntiva necessaria?'),
                                        ],
                                      ),
                                    ),
                                    if (vm.additionalPurchase)
                                      ResponsiveGridItem(
                                          lg: 100,
                                          xs: 100,
                                          child: Column(
                                            children: [
                                            ],
                                          )),
                                    if (vm.additionalPurchase)
                                      ResponsiveGridItem(
                                        lg: 100,
                                        xs: 100,
                                        child: CLTextField.textArea(
                                          controller: vm.additionalPurchaseDescriptionTEC,
                                          labelText: "Descrizione aggiuntiva",
                                          isRequired: true,
                                          validators: [Validators.required],
                                        ),
                                      ),
                                    ResponsiveGridItem(
                                      lg: 100,
                                      xs: 100,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: vm.isHighlighted,
                                            onChanged: (bool? newValue) {
                                              setState(() {
                                                vm.isHighlighted = newValue ?? false;
                                              });
                                            },
                                          ),
                                          const Text('Evento in evidenza?'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Sizes.padding)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          )]));
        });
  }
}
