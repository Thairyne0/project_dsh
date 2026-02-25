import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_pill.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../ui/widgets/table_action_item.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/extension.util.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../models/machine.model.dart';
import '../constants/manage_machine_routes.constants.dart';
import '../viewmodels/manage_machine.viewmodel.dart';

class ManageMachinesPage extends StatefulWidget {
  const ManageMachinesPage({super.key});

  @override
  State<ManageMachinesPage> createState() => _ManageMachinesPageState();
}

class _ManageMachinesPageState extends State<ManageMachinesPage> {
  @override
  Widget build(BuildContext context) {
    final theme = CLTheme.of(context);
    return ViewModelBuilder<ManageMachineViewModel>.reactive(
      viewModelBuilder: () => ManageMachineViewModel(context, VMType.list, null),
      onViewModelReady: (vm) async => await vm.initialize(
        pageActions: [
          PageAction(
            title: 'Nuovo',
            isMain: true,
            iconData: Icons.add,
            onTap: () async => context.customGoNamed(ManageMachineRoutes.newMachine.name),
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
                  padding: const EdgeInsets.all(Sizes.padding * 1.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.only(bottom: Sizes.padding * 1.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Macchinari',
                                  style: theme.title.copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Gestione e monitoraggio dei macchinari',
                                  style: theme.bodyText.copyWith(
                                    color: theme.bodyText.color?.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                            CLButton.primary(
                              text: 'Aggiungi Nuovo',
                              icon: Icons.add,
                              context: context,
                              onTap: () => context.customGoNamed(ManageMachineRoutes.newMachine.name),
                            ),
                          ],
                        ),
                      ),
                      // Tabella
                      CLContainer(
                        contentPadding: EdgeInsets.zero,
                        child: PagedDataTable<String, String, Machine>(
                          rowsSelectable: false,
                          idGetter: (m) => m.id,
                          controller: vm.machinesTableController,
                          fetchPage: vm.fetchMachines,
                          initialPage: '1',
                          initialPageSize: 25,
                          showBorder: false,
                          actionsBuilder: (item) => [
                            TableAction<Machine>(
                              content: TableActionItem(name: 'Modifica', iconData: Icons.edit),
                              onTap: (m) => context.customGoNamed(
                                ManageMachineRoutes.editMachine.name,
                                params: {'id': m.id},
                              ),
                            ),
                            TableAction<Machine>(
                              content: TableActionItem(name: 'Elimina', iconData: Icons.delete_outline),
                              onTap: (m) async => await vm.deleteMachine(m.id),
                            ),
                          ],
                          columns: [
                            // Icona + Nome
                            TableColumn(
                              id: 'name',
                              title: const Text('Macchinario'),
                              sortable: true,
                              sizeFactor: .28,
                              isMain: false,
                              cellBuilder: (m) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: _statusColor(m, context).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(Sizes.borderRadius),
                                    ),
                                    child: Icon(
                                      _iconForCategory(m.iconCategory),
                                      color: _statusColor(m, context),
                                      size: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          m.name,
                                          style: theme.bodyText.copyWith(fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${m.model} · ${m.serialNumber}',
                                          style: theme.smallLabel,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Stato
                            TableColumn(
                              id: 'status',
                              title: const Text('Stato'),
                              sortable: false,
                              sizeFactor: .16,
                              isMain: false,
                              cellBuilder: (m) {
                                final color = _statusColor(m, context);
                                return CLPill(
                                  pillText: m.statusLabel,
                                  pillColor: color,
                                );
                              },
                            ),
                            // Posizione
                            TableColumn(
                              id: 'location',
                              title: const Text('Posizione'),
                              sortable: true,
                              sizeFactor: .22,
                              isMain: false,
                              cellBuilder: (m) => Text(
                                m.location,
                                style: theme.bodyText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Ore operative
                            TableColumn(
                              id: 'operatingHours',
                              title: const Text('Ore'),
                              sortable: true,
                              sizeFactor: .12,
                              isMain: false,
                              cellBuilder: (m) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${m.operatingHours}h', style: theme.bodyText.copyWith(fontWeight: FontWeight.w500)),
                                  Text('operative', style: theme.smallLabel),
                                ],
                              ),
                            ),
                            // Efficienza
                            TableColumn(
                              id: 'efficiency',
                              title: const Text('Efficienza'),
                              sortable: true,
                              sizeFactor: .14,
                              isMain: false,
                              cellBuilder: (m) {
                                final pct = m.efficiency;
                                final color = pct >= 90
                                    ? theme.success
                                    : pct >= 60
                                        ? theme.warning
                                        : theme.danger;
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: pct == 0 ? theme.secondaryText : color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      pct == 0 ? '—' : '${pct.toStringAsFixed(1)}%',
                                      style: theme.bodyText.copyWith(
                                        color: pct == 0 ? theme.secondaryText : color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                          mainFilter: TextTableFilter(
                            id: 'name',
                            title: 'Cerca macchinario',
                            isMainFilter: true,
                            chipFormatter: (v) => v,
                          ),
                          extraFilters: const [],
                          mainMenus: const [],
                        ),
                      ),
                    ],
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

// ─── Helpers ────────────────────────────────────────────────────────────────

Color _statusColor(Machine m, BuildContext context) {
  final t = CLTheme.of(context);
  switch (m.status) {
    case MachineStatus.running:     return t.success;
    case MachineStatus.idle:        return t.warning;
    case MachineStatus.maintenance: return t.info;
    case MachineStatus.error:       return t.danger;
  }
}

IconData _iconForCategory(String cat) {
  switch (cat) {
    case 'lathe':      return FontAwesomeIcons.gear;
    case 'milling':    return FontAwesomeIcons.screwdriver;
    case 'press':      return FontAwesomeIcons.compress;
    case 'robot':      return FontAwesomeIcons.robot;
    case 'compressor': return FontAwesomeIcons.wind;
    case 'laser':      return FontAwesomeIcons.bolt;
    case 'grinder':    return FontAwesomeIcons.circleHalfStroke;
    case '3d_print':   return FontAwesomeIcons.cube;
    default:           return FontAwesomeIcons.industry;
  }
}
