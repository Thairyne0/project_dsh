import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
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
                  padding: const EdgeInsets.all(Sizes.padding),
                  child: CLContainer(
                    title: 'Macchinari',
                    child: vm.machines.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(Sizes.padding),
                            child: Center(
                              child: Text('Nessun macchinario presente.',
                                  style: theme.bodyText.override(color: theme.secondaryText)),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: vm.machines.length,
                            separatorBuilder: (_, __) => Divider(color: theme.borderColor, height: 1),
                            itemBuilder: (context, index) {
                              final m = vm.machines[index];
                              return _ManageRow(
                                machine: m,
                                onEdit: () => context.customGoNamed(
                                  ManageMachineRoutes.editMachine.name,
                                  params: {'id': m.id},
                                ),
                                onDelete: () async {
                                  await vm.deleteMachine(m.id);
                                },
                              );
                            },
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

// ─────────────────────── Row item ──────────────────────────────────────────
class _ManageRow extends StatelessWidget {
  final Machine machine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ManageRow({required this.machine, required this.onEdit, required this.onDelete});

  Color _statusColor(BuildContext context) {
    final t = CLTheme.of(context);
    switch (machine.status) {
      case MachineStatus.running: return t.success;
      case MachineStatus.idle:    return t.warning;
      case MachineStatus.maintenance: return t.info;
      case MachineStatus.error:  return t.danger;
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

  @override
  Widget build(BuildContext context) {
    final theme = CLTheme.of(context);
    final statusColor = _statusColor(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.padding, vertical: Sizes.small),
      child: Row(
        children: [
          // Icona categoria
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
            ),
            child: Icon(_iconForCategory(machine.iconCategory), color: statusColor, size: 16),
          ),
          const SizedBox(width: Sizes.small),
          // Info
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(machine.name,
                    style: theme.bodyText.override(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('${machine.model} · ${machine.serialNumber}',
                    style: theme.smallText.override(color: theme.secondaryText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: Sizes.small),
          // Pill stato
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text(machine.statusLabel,
                    style: theme.smallText.override(color: statusColor, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: Sizes.small),
          // Azioni
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit, size: 18, color: theme.primary),
            tooltip: 'Modifica',
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, size: 18, color: theme.danger),
            tooltip: 'Elimina',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

