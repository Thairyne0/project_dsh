import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_dsh/modules/store/pages/new_store.page.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/widgets/cl_file_picker.widget.dart';
import 'package:project_dsh/utils/providers/appstate.util.provider.dart';
import '../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../ui/widgets/cl_container.widget.dart';
import '../../../../ui/widgets/cl_dropdown/cl_dropdown.dart';
import '../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../ui/widgets/loading.widget.dart';
import '../../../../ui/widgets/textfield_validator.dart';
import '../../../../utils/base.viewmodel.dart';
import '../../../../utils/models/pageaction.model.dart';
import '../../../ui/cl_theme.dart';
import '../../event_category/models/event_category.model.dart';
import '../../event_category/pages/new_event_category.page.dart';
import '../../store/modules/location/models/location.model.dart';
import '../../store/models/store.model.dart' as StoreModel;
import '../viewmodels/event.viewmodel.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({super.key});

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return ViewModelBuilder<EventViewModel>.reactive(
        viewModelBuilder: () => EventViewModel(context, VMType.create, null),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          PageAction(
              title: "Salva",
              isMain: true,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await vm.createEvent();
                  appState.refreshList.add(true);
                  context.pop();
                  //context.customGoNamed(EventRoutes.viewEvent.name, params: {'id': vm.event.id}, replacedRouteName: vm.event.modelIdentifier);
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
                                child: CLDropdown<EventCategory>.singleAsync(
                                  onAddNew: () {
                                    // Mostra un dialog con la pagina di creazione categoria
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext dialogContext) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          insetPadding: const EdgeInsets.all(Sizes.padding),
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: 800,
                                              maxHeight: MediaQuery.of(context).size.height * 0.8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: CLTheme.of(context).secondaryBackground,
                                              borderRadius: BorderRadius.circular(Sizes.borderRadius),
                                            ),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                                                  child: SingleChildScrollView(
                                                    padding: const EdgeInsets.only(top: 48),
                                                    child: const NewEventCategoryPage(),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: CLTheme.of(context).primaryText,
                                                        size: 24,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(dialogContext).pop();
                                                      },
                                                      tooltip: 'Chiudi',
                                                      splashRadius: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  addNewLabel: 'Aggiungi categoria',
                                  validators: [Validators.required],
                                  searchCallback: vm.getAllEventCategory,
                                  searchColumn: "name",
                                  valueToShow: (item) => item.modelIdentifier,
                                  onSelectItem: (item) {
                                    vm.selectedEventCategory = item!;
                                  },
                                  hint: "Seleziona una categoria",
                                  itemBuilder: (context, item) {
                                    return Text(item.modelIdentifier);
                                  },
                                )),
                            ResponsiveGridItem(lg: 50, xs: 100, child: Container()),
                            ResponsiveGridItem(
                              lg: 50,
                              xs: 100,
                              child: CLTextField(controller: vm.titleTEC, labelText: "Titolo", validators: [Validators.required], isRequired: true),
                            ),
                            ResponsiveGridItem(
                              lg: 50,
                              xs: 100,
                              child: CLTextField(controller: vm.pointsRewardTEC, labelText: "Punti da assegnare", validators: [Validators.required], isRequired: true),
                            ),
                            ResponsiveGridItem(
                              lg: 50,
                              xs: 100,
                              child: CLTextField.date(
                                controller: vm.startingAtTEC,
                                labelText: "Data inizio",
                                withTime: true,
                                validators: [Validators.required],
                                isRequired: true,
                                onDateTimeSelected: (picked) {
                                  vm.selectedStartingAtDate = picked;
                                },
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 50,
                              xs: 100,
                              child: CLTextField.date(
                                controller: vm.endingAtTEC,
                                labelText: "Data Fine",
                                withTime: true,
                                validators: [Validators.required],
                                isRequired: true,
                                onDateTimeSelected: (picked) {
                                  vm.selectedEndingAtDate = picked;
                                },
                              ),
                            ),
                            ResponsiveGridItem(
                                lg: 50,
                                xs: 100,
                                child: Column(
                                  children: [
                                    CLDropdown<StoreModel.Store>.singleAsync(
                                      onAddNew: (){

                                        // Mostra un dialog con la pagina di creazione categoria
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext dialogContext) {
                                            return Dialog(
                                              backgroundColor: Colors.transparent,
                                              insetPadding: const EdgeInsets.all(Sizes.padding),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                  maxWidth: 800,
                                                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: CLTheme.of(context).secondaryBackground,
                                                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(Sizes.borderRadius),
                                                      child: SingleChildScrollView(
                                                        padding: const EdgeInsets.only(top: 48),
                                                        child: const NewStorePage(),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 8,
                                                      right: 8,
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: CLTheme.of(context).primaryText,
                                                            size: 24,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(dialogContext).pop();
                                                          },
                                                          tooltip: 'Chiudi',
                                                          splashRadius: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      validators: [Validators.required],
                                      searchCallback: vm.getAllStore,
                                      searchColumn: "name",
                                      valueToShow: (item) => item.modelIdentifier,
                                      onSelectItem: (item) {
                                        vm.selectedStore = item!;
                                      },
                                      hint: "Seleziona uno store",
                                      itemBuilder: (context, item) {
                                        return Text(item.modelIdentifier);
                                      },
                                    )
                                  ],
                                )),
                            ResponsiveGridItem(
                                lg: 50,
                                xs: 100,
                                child: Column(
                                  children: [
                                    CLDropdown<Location>.singleAsync(
                                      validators: [Validators.required],
                                      searchCallback: vm.getAllLocation,
                                      searchColumn: "name",
                                      valueToShow: (item) => item.modelIdentifier,
                                      onSelectItem: (item) {
                                        vm.selectedLocation = item!;
                                      },
                                      hint: "Seleziona una location",
                                      itemBuilder: (context, item) {
                                        return Text(item.modelIdentifier);
                                      },
                                    )
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
                              lg: 50,
                              xs: 100,
                              child: vm.imageFile == null
                                  ? ClFilePicker.single(
                                allowedExtensions: ['jpg', 'jpeg', 'png'],
                                onPickedFile: (file) {
                                  vm.imageFile = file;
                                },
                              )
                                  : ClFilePicker.single(
                                allowedExtensions: ['jpg', 'jpeg', 'png'],
                                onPickedFile: (file) {
                                  setState(() {
                                    vm.imageFile = file;
                                  });
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      activeColor: CLTheme.of(context).secondary,
                                      splashRadius: 0,
                                      value: vm.isBuyable,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          vm.isBuyable = newValue ?? false;
                                          if (vm.isBuyable == false) {
                                            vm.isBothMoneyAndPoints = false;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Acquistabile?', style: CLTheme.of(context).bodyLabel),
                                ],
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 50,
                              xs: 100,
                              child: vm.isBuyable
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      activeColor: CLTheme.of(context).secondary,
                                      splashRadius: 0,
                                      value: vm.isBothMoneyAndPoints,
                                      onChanged: (bool? newValue) {
                                        vm.setIsBothMoneyAndPoints(newValue!);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Euro + punti?', style: CLTheme.of(context).bodyLabel),
                                ],
                              )
                                  : Container(),
                            ),
                            ResponsiveGridItem(
                              lg: 50,
                              xs: 100,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      activeColor: CLTheme.of(context).secondary,
                                      value: vm.additionalPurchase,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          vm.additionalPurchase = newValue ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Azione aggiuntiva necessaria?', style: CLTheme.of(context).bodyLabel),
                                ],
                              ),
                            ),
                            if (vm.additionalPurchase)
                              ResponsiveGridItem(
                                lg: 100,
                                xs: 100,
                                child: Column(
                                  children: [
                                    CLDropdown<StoreModel.Store>.singleAsync(
                                      validators: [Validators.required],
                                      searchCallback: vm.getAllStore,
                                      searchColumn: "name",
                                      valueToShow: (item) => item.modelIdentifier,
                                      onSelectItem: (item) {
                                        vm.selectedAdditionalPurchaseStore = item!;
                                      },
                                      hint: "Seleziona uno store dove validare l'acquisto",
                                      itemBuilder: (context, item) {
                                        return Text(item.modelIdentifier);
                                      },
                                    )
                                  ],
                                ),
                              ),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      activeColor: CLTheme.of(context).secondary,
                                      splashRadius: 0,
                                      value: vm.isHighlighted,
                                      onChanged: (bool? newValue) {
                                        vm.setIsHighlighted(newValue!);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('In evidenza?', style: CLTheme.of(context).bodyLabel),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Sizes.padding)
                ],
              ),
            ),
          ))]);
        });
  }
}
