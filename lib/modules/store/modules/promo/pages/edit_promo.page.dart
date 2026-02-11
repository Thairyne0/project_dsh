import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_dropdown/cl_dropdown.dart';
import '../../../../../ui/widgets/cl_file_picker.widget.dart';
import '../../../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/textfield_validator.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../models/store.model.dart';
import '../viewmodels/promo.viewmodel.dart';

class EditPromoPage extends StatefulWidget {
  const EditPromoPage({super.key, required this.id});

  final String id;

  @override
  createState() => EditPromoPageState();
}

class EditPromoPageState extends State<EditPromoPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool imageAvailable = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PromoViewModel>.reactive(
        viewModelBuilder: () => PromoViewModel(context, VMType.edit, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.updatePromo(widget.id);
                      context.read<AppState>().markForRefresh();
                      context.pop();
                    }
                  }),
            ]),
        builder: (context, vm, child) {
          return vm.isBusy
              ? LoadingWidget()
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
                                          valueToShow: (item) {
                                            return item.name;
                                          },
                                          selectedValues: vm.selectedStore,
                                          onSelectItem: (item) {
                                            vm.selectedStore = item!;
                                          },
                                          hint: "Store",
                                          itemBuilder: (context, item) {
                                            return Text(item.name);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                    child: CLTextField(controller: vm.titleTEC, labelText: "Titolo", validators: [Validators.required]),
                                  ),

                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.qtyTEC, labelText: "Quantità massima", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(
                                        controller: vm.qtyPerUserTEC, labelText: "Quantità max riscattabile Per Utente", validators: [Validators.required]),
                                  ),

                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField.date(
                                        controller: vm.startingAtTEC,
                                        labelText: "Data inizio",
                                        initialSelectedDateTime: vm.selectedStartingAt,
                                        validators: [Validators.required],
                                        withTime: true,
                                        onDateTimeSelected: (date) {
                                          vm.selectedStartingAt = date;
                                        }),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField.date(
                                        controller: vm.endingAtTEC,
                                        labelText: "Data fine",
                                        withTime: true,
                                        initialSelectedDateTime: vm.selectedStartingAt,
                                        validators: [Validators.required],
                                        onDateTimeSelected: (date) {
                                          vm.selectedEndingAt = date;
                                        }),
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
                                        const Text('In evidenza?'),
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
                                      initialFile: CLMedia(fileUrl: vm.promo.imageUrl),
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
