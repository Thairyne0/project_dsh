import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../ui/cl_theme.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../ui/widgets/cl_container.widget.dart';
import '../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../ui/widgets/loading.widget.dart';
import '../../../utils/base.viewmodel.dart';
import '../models/machine.model.dart';
import '../viewmodels/machine.viewmodel.dart';

class ViewMachinePage extends StatefulWidget {
  const ViewMachinePage({super.key, required this.id});
  final String id;

  @override
  State<ViewMachinePage> createState() => _ViewMachinePageState();
}

class _ViewMachinePageState extends State<ViewMachinePage> {
  @override
  Widget build(BuildContext context) {
    final theme = CLTheme.of(context);
    return ViewModelBuilder<MachineViewModel>.reactive(
      viewModelBuilder: () => MachineViewModel(context, VMType.detail, widget.id),
      onViewModelReady: (vm) async => await vm.initialize(),
      builder: (context, vm, child) {
        if (vm.isBusy) return const LoadingWidget();
        final m = vm.selectedMachine;
        if (m == null) {
          return Center(child: Text('Macchinario non trovato.', style: theme.bodyText));
        }
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
                      // ── Hero header card ─────────────────────────────
                      _HeroCard(machine: m),
                      const SizedBox(height: Sizes.medium),

                      // ── Dati tecnici ─────────────────────────────────
                      CLContainer(
                        title: 'Dati Tecnici',
                        contentPadding: const EdgeInsets.all(Sizes.padding),
                        child: ResponsiveGrid(
                          gridSpacing: Sizes.padding,
                          mainAxisAlignment: MainAxisAlignment.start,
                          showHorizontalDivider: true,
                          children: [
                            _infoTile(context, 'Modello', m.model, lg: 33),
                            _infoTile(context, 'Numero seriale', m.serialNumber, lg: 33),
                            _infoTile(context, 'Posizione', m.location, lg: 33),
                            _infoTile(context, 'Ultima manutenzione', m.lastMaintenance, lg: 33),
                            _infoTile(context, 'Ore operative', '${m.operatingHours} h', lg: 33),
                            _infoTile(context, 'Stato', m.statusLabel, lg: 33),
                          ],
                        ),
                      ),
                      const SizedBox(height: Sizes.medium),

                      // ── Metriche in tempo reale ──────────────────────
                      CLContainer(
                        title: 'Metriche Operative',
                        contentPadding: const EdgeInsets.all(Sizes.padding),
                        child: ResponsiveGrid(
                          gridSpacing: Sizes.padding,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ResponsiveGridItem(
                              lg: 33,
                              xs: 100,
                              child: _MetricCard(
                                icon: FontAwesomeIcons.rotateRight,
                                label: 'Velocità',
                                value: '${m.rpm.toStringAsFixed(0)} RPM',
                                color: theme.info,
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 33,
                              xs: 100,
                              child: _MetricCard(
                                icon: FontAwesomeIcons.temperatureHalf,
                                label: 'Temperatura',
                                value: '${m.temperature} °C',
                                color: m.temperature > 85 ? theme.danger : theme.warning,
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 33,
                              xs: 100,
                              child: _MetricCard(
                                icon: FontAwesomeIcons.chartLine,
                                label: 'Efficienza',
                                value: '${m.efficiency} %',
                                color: m.efficiency >= 90 ? theme.success : theme.warning,
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
          ],
        );
      },
    );
  }

  ResponsiveGridItem _infoTile(BuildContext context, String label, String value, {double lg = 50}) {
    return ResponsiveGridItem(
      lg: lg,
      xs: 100,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minTileHeight: 0,
        title: Text(label, style: CLTheme.of(context).bodyLabel),
        subtitle: Text(value, style: CLTheme.of(context).bodyText),
      ),
    );
  }
}

// ─────────────────────── Hero Card ─────────────────────────────────────────
class _HeroCard extends StatelessWidget {
  final Machine machine;
  const _HeroCard({required this.machine});

  Color _statusColor(BuildContext context) {
    final t = CLTheme.of(context);
    switch (machine.status) {
      case MachineStatus.running: return t.success;
      case MachineStatus.idle: return t.warning;
      case MachineStatus.maintenance: return t.info;
      case MachineStatus.error: return t.danger;
    }
  }

  IconData _iconForCategory() {
    switch (machine.iconCategory) {
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
    final statusColor = _statusColor(context);

    return CLContainer(
      contentPadding: const EdgeInsets.all(Sizes.padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
            ),
            child: Icon(_iconForCategory(), color: statusColor, size: 32),
          ),
          const SizedBox(width: Sizes.padding),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(machine.name, style: theme.heading4.override(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(machine.model, style: theme.bodyText.override(color: theme.secondaryText)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.locationDot, size: 12, color: theme.secondaryText),
                    const SizedBox(width: 6),
                    Text(machine.location, style: theme.smallText.override(color: theme.secondaryText)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(machine.statusLabel, style: theme.bodyLabel.override(color: statusColor, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Metric Card ───────────────────────────────────────
class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CLTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(Sizes.padding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.smallText.override(color: theme.secondaryText)),
              const SizedBox(height: 2),
              Text(value, style: theme.heading5.override(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}




