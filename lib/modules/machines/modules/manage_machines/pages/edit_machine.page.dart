import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../models/machine.model.dart';
import '../viewmodels/manage_machine.viewmodel.dart';
import 'new_machine.page.dart'; // riusa _StatusSelector e _CategorySelector

class EditMachinePage extends StatefulWidget {
  const EditMachinePage({super.key, required this.id});
  final String id;

  @override
  State<EditMachinePage> createState() => _EditMachinePageState();
}

class _EditMachinePageState extends State<EditMachinePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ManageMachineViewModel>.reactive(
      viewModelBuilder: () => ManageMachineViewModel(context, VMType.edit, widget.id),
      onViewModelReady: (vm) async => await vm.initialize(
        pageActions: [
          PageAction(
            title: 'Salva',
            isMain: true,
            iconData: Icons.save,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                context.pop();
              }
            },
          ),
        ],
      ),
      builder: (context, vm, child) {
        if (vm.isBusy) return const LoadingWidget();
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: Sizes.headerOffset),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.padding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CLContainer(
                          title: 'Informazioni Generali',
                          contentPadding: const EdgeInsets.all(Sizes.padding),
                          child: ResponsiveGrid(
                            gridSpacing: Sizes.padding,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ResponsiveGridItem(lg: 50, xs: 100, child: CLTextField(controller: vm.nameTEC, labelText: 'Nome macchinario', isRequired: true, validators: [(v) => (v == null || v.isEmpty) ? 'Campo obbligatorio' : null])),
                              ResponsiveGridItem(lg: 50, xs: 100, child: CLTextField(controller: vm.modelTEC, labelText: 'Modello', isRequired: true, validators: [(v) => (v == null || v.isEmpty) ? 'Campo obbligatorio' : null])),
                              ResponsiveGridItem(lg: 50, xs: 100, child: CLTextField(controller: vm.serialNumberTEC, labelText: 'Numero seriale', isRequired: true, validators: [(v) => (v == null || v.isEmpty) ? 'Campo obbligatorio' : null])),
                              ResponsiveGridItem(lg: 50, xs: 100, child: CLTextField(controller: vm.locationTEC, labelText: 'Posizione / Reparto')),
                              ResponsiveGridItem(lg: 50, xs: 100, child: CLTextField(controller: vm.lastMaintenanceTEC, labelText: 'Ultima manutenzione')),
                              ResponsiveGridItem(lg: 50, xs: 100, child: CLTextField.number(controller: vm.operatingHoursTEC, labelText: 'Ore operative')),
                            ],
                          ),
                        ),
                        const SizedBox(height: Sizes.medium),
                        CLContainer(
                          title: 'Metriche',
                          contentPadding: const EdgeInsets.all(Sizes.padding),
                          child: ResponsiveGrid(
                            gridSpacing: Sizes.padding,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ResponsiveGridItem(lg: 33, xs: 100, child: CLTextField.number(controller: vm.rpmTEC, labelText: 'RPM', withDecimal: true)),
                              ResponsiveGridItem(lg: 33, xs: 100, child: CLTextField.number(controller: vm.temperatureTEC, labelText: 'Temperatura (°C)', withDecimal: true)),
                              ResponsiveGridItem(lg: 33, xs: 100, child: CLTextField.number(controller: vm.efficiencyTEC, labelText: 'Efficienza (%)', withDecimal: true)),
                            ],
                          ),
                        ),
                        const SizedBox(height: Sizes.medium),
                        CLContainer(
                          title: 'Stato e Categoria',
                          contentPadding: const EdgeInsets.all(Sizes.padding),
                          child: ResponsiveGrid(
                            gridSpacing: Sizes.padding,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ResponsiveGridItem(
                                lg: 50, xs: 100,
                                child: MachineStatusSelector(
                                  selected: vm.selectedStatus,
                                  onChanged: vm.setStatus,
                                ),
                              ),
                              ResponsiveGridItem(
                                lg: 50, xs: 100,
                                child: MachineCategorySelector(
                                  selected: vm.selectedIconCategory,
                                  onChanged: vm.setIconCategory,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}




