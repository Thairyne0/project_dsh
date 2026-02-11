import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/widgets/cl_file_picker.widget.dart';
import '../../../../../ui/cl_theme.dart';
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
import '../../../models/store.model.dart';
import '../viewmodels/promo.viewmodel.dart';

class NewPromoPage extends StatefulWidget {
  const NewPromoPage({super.key, required this.storeId});

  final String? storeId;


  @override
  createState() => NewPromoPageState();
}

class NewPromoPageState extends State<NewPromoPage> with TickerProviderStateMixin {
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
    return ViewModelBuilder<PromoViewModel>.reactive(
        viewModelBuilder: () => PromoViewModel(context, VMType.create, widget.storeId),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.createPromo();
                      appState.refreshList.add(true);
                      context.pop();
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
                                      child: Column(
                                        children: [
                                          CLDropdown<Store>.singleAsync(
                                            validators: [Validators.required],
                                            searchCallback: vm.getAllStore,
                                            searchColumn: "name",
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
                                    child: CLTextField(controller: vm.titleTEC, labelText: "Titolo", validators: [Validators.required], isRequired: true),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child:
                                        CLTextField(controller: vm.qtyTEC, labelText: "Quantità massima", validators: [Validators.required], isRequired: true),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(
                                      controller: vm.qtyPerUserTEC,
                                      labelText: "Quantità max riscattabile Per Utente",
                                      validators: [Validators.required],
                                      isRequired: true,
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField.date(
                                      controller: vm.startingAtTEC,
                                      isRequired: true,
                                      labelText: "Data inizio",
                                      validators: [Validators.required],
                                      withTime: false,
                                      onDateTimeSelected: (picked) {
                                        vm.selectedStartingAt = picked;
                                      },
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField.date(
                                      controller: vm.endingAtTEC,
                                      isRequired: true,
                                      labelText: "Data Fine",
                                      withTime: false,
                                      validators: [Validators.required],
                                      onDateTimeSelected: (picked) {
                                        vm.selectedEndingAt = picked;
                                      },
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
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 100,
                                    xs: 100,
                                    child: ClFilePicker.single(
                                      allowedExtensions: ['jpg', 'jpeg', 'png'],
                                      onPickedFile: (file) {
                                        setState(() {
                                          vm.imageFile = file;
                                        });
                                      },
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
                ))]);
        });
  }
}
