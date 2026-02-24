import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import '../../../ui/cl_theme.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../ui/widgets/cl_container.widget.dart';
import '../../../ui/widgets/loading.widget.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/extension.util.dart';
import '../constants/machine_routes.constants.dart';
import '../models/machine.model.dart';
import '../viewmodels/machine.viewmodel.dart';

class MachinesPage extends StatefulWidget {
  const MachinesPage({super.key});

  @override
  State<MachinesPage> createState() => _MachinesPageState();
}

class _MachinesPageState extends State<MachinesPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MachineViewModel>.reactive(
      viewModelBuilder: () => MachineViewModel(context, VMType.list, null),
      onViewModelReady: (vm) async => await vm.initialize(),
      builder: (context, vm, child) {
        if (vm.isBusy) return const LoadingWidget();
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: Sizes.headerOffset),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Stat cards row ──────────────────────────────────
                      _buildStatCards(context, vm),
                      const SizedBox(height: Sizes.medium),

                      // ── Filtri ──────────────────────────────────────────
                      _buildFilters(context, vm),
                      const SizedBox(height: Sizes.medium),

                      // ── Griglia macchinari ──────────────────────────────
                      _buildMachineGrid(context, vm),
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

  // ─────────────────────── Stat Cards ────────────────────────────────────────
  Widget _buildStatCards(BuildContext context, MachineViewModel vm) {
    final theme = CLTheme.of(context);
    final isSmall = ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);
    final stats = [
      _StatInfo('In funzione', vm.runningCount, theme.success, FontAwesomeIcons.circlePlay),
      _StatInfo('In attesa', vm.idleCount, theme.warning, FontAwesomeIcons.circlePause),
      _StatInfo('Manutenzione', vm.maintenanceCount, theme.info, FontAwesomeIcons.wrench),
      _StatInfo('Errore', vm.errorCount, theme.danger, FontAwesomeIcons.circleExclamation),
    ];
    return Wrap(
      spacing: Sizes.small,
      runSpacing: Sizes.small,
      children: stats.map((s) {
        return SizedBox(
          width: isSmall ? double.infinity : 160,
          child: CLContainer(
            contentPadding: const EdgeInsets.all(Sizes.padding),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: s.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  ),
                  child: Icon(s.icon, color: s.color, size: 18),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${s.count}', style: theme.heading4.override(color: s.color, fontWeight: FontWeight.bold)),
                      Text(s.label, style: theme.smallText.override(color: theme.secondaryText), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────── Filtri ────────────────────────────────────────────
  Widget _buildFilters(BuildContext context, MachineViewModel vm) {
    final theme = CLTheme.of(context);
    final filters = <_FilterChip>[
      _FilterChip(null, 'Tutti'),
      _FilterChip(MachineStatus.running, 'In funzione'),
      _FilterChip(MachineStatus.idle, 'In attesa'),
      _FilterChip(MachineStatus.maintenance, 'Manutenzione'),
      _FilterChip(MachineStatus.error, 'Errore'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final selected = vm.selectedStatusFilter == f.status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => vm.filterByStatus(f.status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? theme.primary : theme.tertiaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: selected ? theme.primary : theme.borderColor),
                ),
                child: Text(
                  f.label,
                  style: theme.smallText.override(
                    color: selected ? Colors.white : theme.primaryText,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────── Grid ──────────────────────────────────────────────
  Widget _buildMachineGrid(BuildContext context, MachineViewModel vm) {
    if (vm.filteredMachines.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text('Nessun macchinario trovato.', style: CLTheme.of(context).bodyText.override(color: CLTheme.of(context).secondaryText)),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int crossAxisCount = width < 600 ? 1 : (width < 900 ? 2 : (width < 1300 ? 3 : 4));
        final double cardWidth = (width - Sizes.small * (crossAxisCount - 1)) / crossAxisCount;
        // altezza fissa per card: evita Spacer unbounded
        const double cardHeight = 160.0;

        return Wrap(
          spacing: Sizes.small,
          runSpacing: Sizes.small,
          children: List.generate(vm.filteredMachines.length, (index) {
            return SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: _MachineCard(
                machine: vm.filteredMachines[index],
                onTap: () => context.customGoNamed(
                  MachineRoutes.viewMachine.name,
                  params: {'id': vm.filteredMachines[index].id},
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ─────────────────────────────── Card ──────────────────────────────────────
class _MachineCard extends StatefulWidget {
  final Machine machine;
  final VoidCallback onTap;
  const _MachineCard({required this.machine, required this.onTap});

  @override
  State<_MachineCard> createState() => _MachineCardState();
}

class _MachineCardState extends State<_MachineCard> {
  bool _hovered = false;

  Color _statusColor(BuildContext context, MachineStatus s) {
    final t = CLTheme.of(context);
    switch (s) {
      case MachineStatus.running: return t.success;
      case MachineStatus.idle: return t.warning;
      case MachineStatus.maintenance: return t.info;
      case MachineStatus.error: return t.danger;
    }
  }

  IconData _iconForCategory(String cat) {
    switch (cat) {
      case 'lathe': return FontAwesomeIcons.gear;
      case 'milling': return FontAwesomeIcons.screwdriver;
      case 'press': return FontAwesomeIcons.compress;
      case 'robot': return FontAwesomeIcons.robot;
      case 'compressor': return FontAwesomeIcons.wind;
      case 'laser': return FontAwesomeIcons.bolt;
      case 'grinder': return FontAwesomeIcons.circleHalfStroke;
      case '3d_print': return FontAwesomeIcons.cube;
      default: return FontAwesomeIcons.industry;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CLTheme.of(context);
    final m = widget.machine;
    final statusColor = _statusColor(context, m.status);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(Sizes.borderRadius),
            border: Border.all(
              color: _hovered ? statusColor : theme.borderColor,
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: statusColor.withValues(alpha: 0.15), blurRadius: 12, spreadRadius: 1)]
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.all(Sizes.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(Sizes.borderRadius),
                      ),
                      child: Icon(_iconForCategory(m.iconCategory), color: statusColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.name, style: theme.title.override(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(m.model, style: theme.smallText.override(color: theme.secondaryText), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    // Pill status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Text(m.statusLabel, style: theme.smallText.override(color: statusColor, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // ── Metriche ────────────────────────────────────────
                Row(
                  children: [
                    _Metric(icon: FontAwesomeIcons.rotateRight, label: '${m.rpm.toStringAsFixed(0)} RPM', color: theme.secondaryText),
                    const SizedBox(width: 14),
                    _Metric(icon: FontAwesomeIcons.temperatureHalf, label: '${m.temperature}°C', color: theme.secondaryText),
                    const SizedBox(width: 14),
                    _Metric(icon: FontAwesomeIcons.chartLine, label: '${m.efficiency}%', color: theme.secondaryText),
                  ],
                ),
                const SizedBox(height: 8),
                // ── Location + ore ───────────────────────────────────
                Row(
                  children: [
                    Icon(FontAwesomeIcons.locationDot, size: 11, color: theme.secondaryText),
                    const SizedBox(width: 5),
                    Expanded(child: Text(m.location, style: theme.smallText.override(color: theme.secondaryText), overflow: TextOverflow.ellipsis)),
                    Icon(FontAwesomeIcons.clock, size: 11, color: theme.secondaryText),
                    const SizedBox(width: 4),
                    Text('${m.operatingHours}h', style: theme.smallText.override(color: theme.secondaryText)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Metric({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label, style: CLTheme.of(context).smallText.override(color: color)),
      ],
    );
  }
}

// ─────────────────────────────── Data helpers ───────────────────────────────
class _StatInfo {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  _StatInfo(this.label, this.count, this.color, this.icon);
}

class _FilterChip {
  final MachineStatus? status;
  final String label;
  _FilterChip(this.status, this.label);
}




