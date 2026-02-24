import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../models/machine.model.dart';
import '../viewmodels/manage_machine.viewmodel.dart';

class NewMachinePage extends StatefulWidget {
  const NewMachinePage({super.key});

  @override
  State<NewMachinePage> createState() => _NewMachinePageState();
}

class _NewMachinePageState extends State<NewMachinePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ManageMachineViewModel>.reactive(
      viewModelBuilder: () => ManageMachineViewModel(context, VMType.create, null),
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

// ─────────────────────── Selettori riutilizzabili ───────────────────────────

class MachineStatusSelector extends StatelessWidget {
  final MachineStatus selected;
  final void Function(MachineStatus) onChanged;
  const MachineStatusSelector({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = CLTheme.of(context);
    final items = [
      (MachineStatus.running, 'In funzione', theme.success),
      (MachineStatus.idle, 'In attesa', theme.warning),
      (MachineStatus.maintenance, 'In manutenzione', theme.info),
      (MachineStatus.error, 'Errore', theme.danger),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stato', style: theme.bodyLabel),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((e) {
            final isSelected = selected == e.$1;
            return GestureDetector(
              onTap: () => onChanged(e.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? e.$3.withValues(alpha: 0.15) : theme.tertiaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? e.$3 : theme.borderColor, width: isSelected ? 1.5 : 1),
                ),
                child: Text(e.$2, style: theme.smallText.override(color: isSelected ? e.$3 : theme.secondaryText, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MachineCategorySelector extends StatelessWidget {
  final String selected;
  final void Function(String) onChanged;
  const MachineCategorySelector({super.key, required this.selected, required this.onChanged});

  static const _categories = [
    ('lathe', 'Tornio'),
    ('milling', 'Fresatrice'),
    ('press', 'Pressa'),
    ('robot', 'Robot'),
    ('compressor', 'Compressore'),
    ('laser', 'Laser'),
    ('grinder', 'Rettificatrice'),
    ('3d_print', 'Stampante 3D'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = CLTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categoria', style: theme.bodyLabel),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((e) {
            final isSelected = selected == e.$1;
            return GestureDetector(
              onTap: () => onChanged(e.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? theme.primary.withValues(alpha: 0.12) : theme.tertiaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? theme.primary : theme.borderColor, width: isSelected ? 1.5 : 1),
                ),
                child: Text(e.$2, style: theme.smallText.override(color: isSelected ? theme.primary : theme.secondaryText, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}





