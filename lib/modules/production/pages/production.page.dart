import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../ui/cl_theme.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../ui/widgets/cl_container.widget.dart';
import '../../../ui/widgets/loading.widget.dart';
import '../../../utils/base.viewmodel.dart';
import '../models/production.model.dart';
import '../viewmodels/production.viewmodel.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────────────────────
class ProductionPage extends StatefulWidget {
  const ProductionPage({super.key});
  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  static const _tabs = [
    (Icons.dashboard_outlined,       'Panoramica'),
    (Icons.bar_chart_outlined,       'Grafici'),
    (Icons.precision_manufacturing_outlined, 'Macchinari'),
    (Icons.notifications_outlined,   'Alert'),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _tabs.length, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductionViewModel>.reactive(
      viewModelBuilder: () => ProductionViewModel(context, VMType.list, null),
      onViewModelReady: (vm) async => await vm.initialize(),
      builder: (context, vm, child) {
        if (vm.isBusy) return const LoadingWidget();
        final t = CLTheme.of(context);

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: Sizes.headerOffset),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.padding, vertical: Sizes.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Tab bar ──────────────────────────────────────
                      CLContainer(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: Sizes.padding, vertical: 6),
                        child: TabBar(
                          controller: _tab,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          dividerColor: Colors.transparent,
                          indicator: BoxDecoration(
                            color: t.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: t.primary,
                          unselectedLabelColor: t.secondaryText,
                          labelStyle: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                          unselectedLabelStyle:
                              const TextStyle(fontSize: 12),
                          tabs: _tabs.map((e) => Tab(
                            height: 36,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(e.$1, size: 15),
                                const SizedBox(width: 6),
                                Text(e.$2),
                                // Badge alert
                                if (e.$2 == 'Alert' && vm.alerts.isNotEmpty) ...[
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: t.danger,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('${vm.alerts.length}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ],
                            ),
                          )).toList(),
                        ),
                      ),
                      const SizedBox(height: Sizes.padding),

                      // ── Contenuto tab corrente ────────────────────────
                      _buildTabContent(vm),
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

  Widget _buildTabContent(ProductionViewModel vm) {
    switch (_tab.index) {
      case 0: return _TabOverview(vm: vm);
      case 1: return _TabCharts(vm: vm, tabController: _tab);
      case 2: return _TabMachines(vm: vm);
      case 3: return _TabAlerts(vm: vm);
      default: return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPER — sezione con titolo + descrizione grigia
// ─────────────────────────────────────────────────────────────────────────────
class _Section extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;
  final EdgeInsets? contentPadding;

  const _Section({
    required this.title,
    required this.description,
    required this.child,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    return CLContainer(
      titleWidget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.bodyLabel),
          const SizedBox(height: 3),
          Text(description,
              style: t.smallText.override(color: t.secondaryText)),
        ],
      ),
      contentPadding: contentPadding ??
          const EdgeInsets.fromLTRB(
              Sizes.padding, 4, Sizes.padding, Sizes.padding),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 0 — PANORAMICA  (KPI + proiezione)
// ─────────────────────────────────────────────────────────────────────────────
class _TabOverview extends StatelessWidget {
  final ProductionViewModel vm;
  const _TabOverview({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _KpiRow(vm: vm),
        if (vm.projection != null) ...[
          const SizedBox(height: Sizes.padding),
          _ProjectionCard(projection: vm.projection!),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1 — GRAFICI  (toggle + bar + costi + qualità)
// ─────────────────────────────────────────────────────────────────────────────
class _TabCharts extends StatelessWidget {
  final ProductionViewModel vm;
  final TabController tabController;
  const _TabCharts({required this.vm, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PeriodToggle(vm: vm),
        const SizedBox(height: Sizes.padding),
        _ProductionBarChart(vm: vm),
        const SizedBox(height: Sizes.padding),
        LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth > 800;
          return wide
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _CostLineChart(vm: vm)),
                      const SizedBox(width: Sizes.padding),
                      SizedBox(width: 280, child: _CostDonutChart(vm: vm)),
                    ],
                  ))
              : Column(children: [
                  _CostLineChart(vm: vm),
                  const SizedBox(height: Sizes.padding),
                  _CostDonutChart(vm: vm),
                ]);
        }),
        const SizedBox(height: Sizes.padding),
        _QualityLineChart(vm: vm),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2 — MACCHINARI  (filtro + tabella + OEE + radar)
// ─────────────────────────────────────────────────────────────────────────────
class _TabMachines extends StatelessWidget {
  final ProductionViewModel vm;
  const _TabMachines({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MachineFilterBar(vm: vm),
        const SizedBox(height: Sizes.padding),
        _PerMachineTable(vm: vm),
        const SizedBox(height: Sizes.padding),
        _OeeSection(vm: vm),
        const SizedBox(height: Sizes.padding),
        _RadarSection(vm: vm),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3 — ALERT  (banner dismissabili)
// ─────────────────────────────────────────────────────────────────────────────
class _TabAlerts extends StatelessWidget {
  final ProductionViewModel vm;
  const _TabAlerts({required this.vm});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    if (vm.alerts.isEmpty) {
      return CLContainer(
        contentPadding: const EdgeInsets.all(Sizes.padding * 2),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline,
                  size: 40, color: t.success),
              const SizedBox(height: 12),
              Text('Nessun alert attivo',
                  style: t.bodyLabel.override(color: t.success)),
              const SizedBox(height: 4),
              Text('Tutti i macchinari operano nei parametri.',
                  style: t.smallText.override(color: t.secondaryText)),
            ],
          ),
        ),
      );
    }
    return _AlertBanner(vm: vm);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KPI ROW
// ─────────────────────────────────────────────────────────────────────────────
class _KpiRow extends StatelessWidget {
  final ProductionViewModel vm;
  const _KpiRow({required this.vm});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final kpi = vm.kpi;
    if (kpi == null) return const SizedBox.shrink();

    final activeOee = vm.oeeData.where((m) => m.oee > 0);
    final avgOee = activeOee.isEmpty
        ? 0.0
        : activeOee.map((m) => m.oee).reduce((a, b) => a + b) /
            activeOee.length;

    final items = [
      _KpiItem('Unità prodotte',
          '${(kpi.totalUnitsThisMonth / 1000).toStringAsFixed(1)}k',
          FontAwesomeIcons.boxesStacked, t.primary, kpi.productionTrend),
      _KpiItem('Costi totali',
          '€${(kpi.totalCostThisMonth / 1000).toStringAsFixed(1)}k',
          FontAwesomeIcons.euroSign, t.danger, kpi.costTrend),
      _KpiItem('Energia',
          '${(kpi.totalEnergyThisMonth / 1000).toStringAsFixed(1)}k kWh',
          FontAwesomeIcons.bolt, t.warning, null),
      _KpiItem('Qualità media',
          '${kpi.avgQualityRate.toStringAsFixed(1)}%',
          FontAwesomeIcons.award, t.success, null),
      _KpiItem(
          'OEE medio',
          '${avgOee.toStringAsFixed(1)}%',
          FontAwesomeIcons.gaugeHigh,
          avgOee >= 85
              ? t.success
              : (avgOee >= 65 ? t.warning : t.danger),
          null),
    ];

    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 1000
          ? 5
          : c.maxWidth >= 700
              ? 3
              : c.maxWidth >= 480
                  ? 2
                  : 1;
      final sp = Sizes.small;
      final w = (c.maxWidth - sp * (cols - 1)) / cols;
      return Wrap(
        spacing: sp,
        runSpacing: sp,
        children: items
            .map((item) => SizedBox(
                  width: w,
                  child: CLContainer(
                    contentPadding: const EdgeInsets.all(Sizes.padding),
                    child: Row(children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(Sizes.borderRadius),
                        ),
                        child: Icon(item.icon, color: item.color, size: 17),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.value,
                              style: t.heading4.override(
                                  color: item.color,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(item.label,
                              style: t.smallText
                                  .override(color: t.secondaryText)),
                          if (item.trend != null) ...[
                            const SizedBox(height: 4),
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item.trend! >= 0
                                        ? FontAwesomeIcons.arrowTrendUp
                                        : FontAwesomeIcons.arrowTrendDown,
                                    size: 10,
                                    color: item.trend! >= 0
                                        ? t.success
                                        : t.danger,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '${item.trend! >= 0 ? '+' : ''}${item.trend!.toStringAsFixed(1)}% vs mese prec.',
                                      style: t.smallText.override(
                                        color: item.trend! >= 0
                                            ? t.success
                                            : t.danger,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ]),
                          ],
                        ],
                      )),
                    ]),
                  ),
                ))
            .toList(),
      );
    });
  }
}

class _KpiItem {
  final String label, value;
  final IconData icon;
  final Color color;
  final double? trend;
  _KpiItem(this.label, this.value, this.icon, this.color, this.trend);
}

// ─────────────────────────────────────────────────────────────────────────────
// PROIEZIONE FINE MESE
// ─────────────────────────────────────────────────────────────────────────────
class _ProjectionCard extends StatelessWidget {
  final ProjectionData projection;
  const _ProjectionCard({required this.projection});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final p = projection;

    return CLContainer(
      titleWidget: Row(children: [
        Icon(FontAwesomeIcons.chartPie, size: 13, color: t.primary),
        const SizedBox(width: 6),
        Text('Proiezione Fine Mese', style: t.bodyLabel),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: t.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Giorno ${p.daysElapsed} / ${p.totalDaysInMonth}',
            style: t.smallText
                .override(color: t.primary, fontWeight: FontWeight.w600),
          ),
        ),
      ]),
      contentPadding: const EdgeInsets.fromLTRB(
          Sizes.padding, 4, Sizes.padding, Sizes.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Avanzamento mese: ${p.progressPct.toStringAsFixed(0)}%',
              style: t.smallText.override(color: t.secondaryText)),
          const SizedBox(height: 6),
          _ProgressBar(value: p.progressPct / 100, color: t.primary),
          const SizedBox(height: Sizes.padding),
          LayoutBuilder(builder: (ctx, c) {
            final wide = c.maxWidth > 600;
            final items = [
              _ProjItem(
                label: 'Produzione',
                current:
                    '${(p.currentUnits / 1000).toStringAsFixed(1)}k u',
                projected:
                    '${(p.projectedUnits / 1000).toStringAsFixed(1)}k u',
                target:
                    '${(p.productionTarget / 1000).toStringAsFixed(1)}k u',
                pct: p.unitsVsTarget,
                onTrack: p.onTrackProduction,
                icon: FontAwesomeIcons.boxesStacked,
                theme: t,
              ),
              _ProjItem(
                label: 'Costi',
                current: '€${(p.currentCost / 1000).toStringAsFixed(1)}k',
                projected:
                    '€${(p.projectedCost / 1000).toStringAsFixed(1)}k',
                target:
                    '€${(p.budgetTarget / 1000).toStringAsFixed(1)}k budget',
                pct: p.costVsBudget,
                onTrack: p.onTrackCost,
                icon: FontAwesomeIcons.euroSign,
                theme: t,
                invertPct: true,
              ),
            ];
            return wide
                ? Row(children: [
                    Expanded(child: items[0]),
                    const SizedBox(width: Sizes.padding),
                    Expanded(child: items[1]),
                  ])
                : Column(children: [
                    items[0],
                    const SizedBox(height: 12),
                    items[1]
                  ]);
          }),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  const _ProgressBar({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 8,
        backgroundColor: t.borderColor,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}

class _ProjItem extends StatelessWidget {
  final String label, current, projected, target;
  final double pct;
  final bool onTrack;
  final IconData icon;
  final CLTheme theme;
  final bool invertPct;
  const _ProjItem({
    required this.label,
    required this.current,
    required this.projected,
    required this.target,
    required this.pct,
    required this.onTrack,
    required this.icon,
    required this.theme,
    this.invertPct = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final good = invertPct ? pct <= 105 : pct >= 95;
    final barColor = good ? t.success : t.danger;
    final barValue = invertPct
        ? (1 - ((pct - 100) / 50).clamp(0.0, 1.0))
        : (pct / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.tertiaryBackground,
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
        border: Border.all(color: t.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Icon(icon, size: 12, color: t.secondaryText),
            const SizedBox(width: 6),
            Text(label, style: t.bodyLabel),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: barColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                good ? 'In linea' : 'Fuori target',
                style: t.smallText
                    .override(color: barColor, fontWeight: FontWeight.w600),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          _ProgressBar(value: barValue, color: barColor),
          const SizedBox(height: 8),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Attuale',
                          style: t.smallText
                              .override(color: t.secondaryText)),
                      Text(current,
                          style: t.bodyText
                              .override(fontWeight: FontWeight.w600)),
                    ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Proiezione',
                          style: t.smallText
                              .override(color: t.secondaryText)),
                      Text(projected,
                          style: t.bodyText.override(
                              color: barColor,
                              fontWeight: FontWeight.w600)),
                    ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Target',
                          style: t.smallText
                              .override(color: t.secondaryText)),
                      Text(target,
                          style: t.bodyText
                              .override(fontWeight: FontWeight.w600)),
                    ]),
              ]),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PERIOD TOGGLE (solo tab Grafici)
// ─────────────────────────────────────────────────────────────────────────────
class _PeriodToggle extends StatelessWidget {
  final ProductionViewModel vm;
  const _PeriodToggle({required this.vm});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    return CLContainer(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.padding, vertical: 10),
      child: Row(children: [
        Text('Periodo:', style: t.bodyLabel),
        const SizedBox(width: 10),
        ...[
          (ProductionViewMode.monthly, 'Mensile'),
          (ProductionViewMode.weekly, 'Settimanale'),
        ].map((e) {
          final sel = vm.viewMode == e.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => vm.setViewMode(e.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: sel ? t.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: sel ? t.primary : t.borderColor),
                ),
                child: Text(e.$2,
                    style: t.smallText.override(
                        color: sel ? Colors.white : t.secondaryText,
                        fontWeight: sel
                            ? FontWeight.w600
                            : FontWeight.normal)),
              ),
            ),
          );
        }),
        const Spacer(),
        Text(
          vm.viewMode == ProductionViewMode.monthly
              ? 'Ultimi 12 mesi'
              : 'Ultimi 7 giorni',
          style: t.smallText.override(color: t.secondaryText),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MACHINE FILTER BAR (solo tab Macchinari)
// ─────────────────────────────────────────────────────────────────────────────
class _MachineFilterBar extends StatelessWidget {
  final ProductionViewModel vm;
  const _MachineFilterBar({required this.vm});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final options = [
      {'id': null as String?, 'name': 'Tutti'},
      ...vm.machineOptions.map(
          (m) => {'id': m['id'] as String?, 'name': m['name'] as String?}),
    ];

    return CLContainer(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.padding, vertical: 10),
      child: Row(children: [
        Text('Filtra:', style: t.bodyLabel),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: options.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final opt = options[i];
                final sel = vm.selectedMachineId == opt['id'];
                final name = opt['name'] as String;
                return GestureDetector(
                  onTap: () => vm.selectMachine(opt['id']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: sel
                          ? t.primary.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: sel ? t.primary : t.borderColor),
                    ),
                    child: Text(
                      name.length > 14
                          ? '${name.substring(0, 13)}…'
                          : name,
                      style: t.smallText.override(
                        color: sel ? t.primary : t.secondaryText,
                        fontWeight: sel
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ALERT BANNER
// ─────────────────────────────────────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  final ProductionViewModel vm;
  const _AlertBanner({required this.vm});

  Color _color(AlertSeverity s, CLTheme t) {
    switch (s) {
      case AlertSeverity.critical: return t.danger;
      case AlertSeverity.warning:  return t.warning;
      case AlertSeverity.info:     return t.info;
    }
  }

  IconData _icon(AlertSeverity s) {
    switch (s) {
      case AlertSeverity.critical: return FontAwesomeIcons.triangleExclamation;
      case AlertSeverity.warning:  return FontAwesomeIcons.circleExclamation;
      case AlertSeverity.info:     return FontAwesomeIcons.circleInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    return CLContainer(
      titleWidget: Row(children: [
        Icon(FontAwesomeIcons.bell, size: 13, color: t.danger),
        const SizedBox(width: 6),
        Text('Alert attivi (${vm.alerts.length})', style: t.bodyLabel),
      ]),
      contentPadding: const EdgeInsets.fromLTRB(
          Sizes.padding, 4, Sizes.padding, Sizes.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: vm.alerts.map((a) {
          final color = _color(a.severity, t);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
              border:
                  Border.all(color: color.withValues(alpha: 0.30)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_icon(a.severity), size: 14, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(a.machineName,
                          style: t.smallText.override(
                              color: color,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(a.message,
                          style:
                              t.smallText.override(color: t.primaryText)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => vm.dismissAlert(a),
                  child: Icon(Icons.close, size: 14, color: t.secondaryText),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BAR CHART — Produzione
// ─────────────────────────────────────────────────────────────────────────────
class _ProductionBarChart extends StatelessWidget {
  final ProductionViewModel vm;
  const _ProductionBarChart({required this.vm});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final isW = vm.viewMode == ProductionViewMode.weekly;
    final labels = isW
        ? vm.weeklyData.map((d) => d['day'] as String).toList()
        : vm.monthLabels;
    final values = isW
        ? vm.weeklyData.map((d) => d['units'] as double).toList()
        : vm.productionBarValues;
    final maxY = values.reduce((a, b) => a > b ? a : b) * 1.2;

    return _Section(
      title: 'Volume di Produzione',
      description: isW
          ? 'Unità prodotte per giorno nella settimana corrente.'
          : 'Unità prodotte per mese negli ultimi 12 mesi.',
      child: SizedBox(
        height: 230,
        child: BarChart(BarChartData(
          maxY: maxY,
          minY: 0,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (g, gi, rod, ri) => BarTooltipItem(
                '${labels[gi]}\n${rod.toY.toStringAsFixed(0)} unità',
                const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (v, _) => Text(
                v >= 1000
                    ? '${(v / 1000).toStringAsFixed(0)}k'
                    : v.toStringAsFixed(0),
                style: TextStyle(color: t.secondaryText, fontSize: 10),
              ),
            )),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= labels.length)
                  return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(labels[i],
                      style: TextStyle(
                          color: t.secondaryText, fontSize: 10)),
                );
              },
            )),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: t.borderColor, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: values.asMap().entries
              .map((e) => BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        width: isW ? 28 : 14,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                        gradient: LinearGradient(
                          colors: [
                            t.primary.withValues(alpha: 0.7),
                            t.primary
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      )
                    ],
                  ))
              .toList(),
        )),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LINE CHART — Costi
// ─────────────────────────────────────────────────────────────────────────────
class _CostLineChart extends StatelessWidget {
  final ProductionViewModel vm;
  const _CostLineChart({required this.vm});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final isW = vm.viewMode == ProductionViewMode.weekly;
    final labels = isW
        ? vm.weeklyData.map((d) => d['day'] as String).toList()
        : vm.monthLabels;
    final values = isW
        ? vm.weeklyData.map((d) => d['cost'] as double).toList()
        : vm.costLineValues;
    final spots = values.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    final maxY = values.reduce((a, b) => a > b ? a : b) * 1.15;

    return _Section(
      title: 'Andamento Costi',
      description: 'Costi operativi totali (energia + manutenzione + materiali).',
      child: SizedBox(
        height: 210,
        child: LineChart(LineChartData(
          minY: 0,
          maxY: maxY,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots
                  .map((s) => LineTooltipItem(
                        '${labels[s.x.toInt()]}\n€${s.y.toStringAsFixed(0)}',
                        const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ))
                  .toList(),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              getTitlesWidget: (v, _) => Text(
                  '€${(v / 1000).toStringAsFixed(0)}k',
                  style:
                      TextStyle(color: t.secondaryText, fontSize: 10)),
            )),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              interval: isW ? 1 : 2,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= labels.length)
                  return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(labels[i],
                      style: TextStyle(
                          color: t.secondaryText, fontSize: 10)),
                );
              },
            )),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: t.borderColor, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: t.danger,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    t.danger.withValues(alpha: 0.18),
                    t.danger.withValues(alpha: 0.0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DONUT — Ripartizione costi
// ─────────────────────────────────────────────────────────────────────────────
class _CostDonutChart extends StatelessWidget {
  final ProductionViewModel vm;
  const _CostDonutChart({required this.vm});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final breakdown = vm.costBreakdown;
    final total = breakdown.values.fold(0.0, (a, b) => a + b);
    final colors = [t.warning, t.info, t.success];
    final entries = breakdown.entries.toList();

    return _Section(
      title: 'Ripartizione Costi',
      description: 'Distribuzione percentuale per categoria. Mese corrente.',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            child: PieChart(PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 40,
              sections: entries.asMap().entries.map((e) {
                final pct = (e.value.value / total) * 100;
                return PieChartSectionData(
                  value: e.value.value,
                  color: colors[e.key % colors.length],
                  radius: 50,
                  title: '${pct.toStringAsFixed(0)}%',
                  titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              }).toList(),
            )),
          ),
          const SizedBox(height: Sizes.small),
          ...entries.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: colors[e.key % colors.length],
                          shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(e.value.key, style: t.smallText)),
                  Text(
                      '€${(e.value.value / 1000).toStringAsFixed(1)}k',
                      style: t.smallText
                          .override(fontWeight: FontWeight.w600)),
                ]),
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LINE CHART — Qualità
// ─────────────────────────────────────────────────────────────────────────────
class _QualityLineChart extends StatelessWidget {
  final ProductionViewModel vm;
  const _QualityLineChart({required this.vm});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final labels = vm.monthLabels;
    final values = vm.qualityLineValues;
    final spots = values.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return _Section(
      title: 'Indice di Qualità',
      description:
          '% unità conformi per mese. Target ≥ 95% (linea tratteggiata).',
      child: SizedBox(
        height: 190,
        child: LineChart(LineChartData(
          minY: 85,
          maxY: 100,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots
                  .map((s) => LineTooltipItem(
                        '${labels[s.x.toInt()]}: ${s.y.toStringAsFixed(1)}%',
                        const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ))
                  .toList(),
            ),
          ),
          extraLinesData: ExtraLinesData(horizontalLines: [
            HorizontalLine(
              y: 95,
              color: t.success.withValues(alpha: 0.5),
              strokeWidth: 1.2,
              dashArray: [5, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                labelResolver: (_) => 'target 95%',
                style: TextStyle(color: t.success, fontSize: 9),
              ),
            ),
          ]),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (v, _) => Text(
                  '${v.toStringAsFixed(0)}%',
                  style:
                      TextStyle(color: t.secondaryText, fontSize: 10)),
            )),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= labels.length)
                  return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(labels[i],
                      style: TextStyle(
                          color: t.secondaryText, fontSize: 10)),
                );
              },
            )),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: t.borderColor, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: t.success,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (sp, pct, bar, i) => FlDotCirclePainter(
                    radius: 3,
                    color: t.success,
                    strokeWidth: 1.5,
                    strokeColor: Colors.white),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    t.success.withValues(alpha: 0.15),
                    t.success.withValues(alpha: 0.0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OEE SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _OeeSection extends StatelessWidget {
  final ProductionViewModel vm;
  const _OeeSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final data = vm.filteredOee;

    return _Section(
      title: 'OEE — Overall Equipment Effectiveness',
      description:
          'Disponibilità × Performance × Qualità per macchinario. ≥85 % eccellente · 65–85 % accettabile · <65 % da migliorare.',
      child: LayoutBuilder(builder: (context, c) {
        final cols = c.maxWidth >= 900
            ? 3
            : c.maxWidth >= 560
                ? 2
                : 1;
        final spacing = Sizes.small;
        final cardWidth = (c.maxWidth - spacing * (cols - 1)) / cols;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: data.map((m) {
            final oeeColor = m.oee >= 85
                ? t.success
                : (m.oee >= 65 ? t.warning : t.danger);
            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: t.primaryBackground,
                  borderRadius: BorderRadius.circular(Sizes.borderRadius),
                  border: Border.all(color: t.borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    // ── Indicatore circolare OEE ──
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: CircularProgressIndicator(
                              value: (m.oee / 100).clamp(0.0, 1.0),
                              strokeWidth: 5,
                              strokeCap: StrokeCap.round,
                              backgroundColor: t.borderColor,
                              valueColor: AlwaysStoppedAnimation(oeeColor),
                            ),
                          ),
                          Text(
                            '${m.oee.toStringAsFixed(0)}%',
                            style: t.smallText.override(
                                fontWeight: FontWeight.w700,
                                color: oeeColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    // ── Dettagli ──
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  m.machineName,
                                  style: t.smallText
                                      .override(fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: oeeColor.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  m.oeeLabel,
                                  style: t.smallText.override(
                                      color: oeeColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _OeeMiniBar(
                              label: 'Disp.',
                              value: m.availability,
                              color: const Color(0xFFF59E0B),
                              theme: t),
                          const SizedBox(height: 5),
                          _OeeMiniBar(
                              label: 'Perf.',
                              value: m.performance,
                              color: const Color(0xFF6366F1),
                              theme: t),
                          const SizedBox(height: 5),
                          _OeeMiniBar(
                              label: 'Qual.',
                              value: m.quality,
                              color: const Color(0xFF14B8A6),
                              theme: t),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}

class _OeeMiniBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final CLTheme theme;
  const _OeeMiniBar(
      {required this.label,
      required this.value,
      required this.color,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    final t = theme;
    return Row(children: [
      SizedBox(
        width: 36,
        child: Text(label,
            style: t.smallText.override(color: t.secondaryText, fontSize: 10)),
      ),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: (value / 100).clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: t.borderColor,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ),
      const SizedBox(width: 6),
      SizedBox(
        width: 30,
        child: Text('${value.toStringAsFixed(0)}%',
            style: t.smallText.override(fontWeight: FontWeight.w600, fontSize: 10),
            textAlign: TextAlign.end),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RADAR — confronto macchinari
// ─────────────────────────────────────────────────────────────────────────────
class _RadarSection extends StatelessWidget {
  final ProductionViewModel vm;
  const _RadarSection({required this.vm});

  static const _axes = [
    'Produzione', 'Qualità', 'Efficienza', 'Disponibilità', 'Costo↓'
  ];

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final data = vm.radarData;
    final palette = [t.primary, t.success, t.warning, t.info, t.danger];

    return _Section(
      title: 'Confronto Macchinari',
      description:
          '5 dimensioni normalizzate 0–100. "Costo↓" = più alto = meno costoso.',
      child: LayoutBuilder(builder: (context, c) {
        final size = c.maxWidth.clamp(200.0, 480.0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size * 0.85,
              child: RadarChart(RadarChartData(
                dataSets: data.asMap().entries
                    .map((e) => RadarDataSet(
                          dataEntries: e.value.values
                              .map((v) => RadarEntry(value: v))
                              .toList(),
                          fillColor: palette[e.key % palette.length]
                              .withValues(alpha: 0.12),
                          borderColor: palette[e.key % palette.length],
                          borderWidth: 1.8,
                          entryRadius: 2,
                        ))
                    .toList(),
                radarShape: RadarShape.polygon,
                tickCount: 4,
                ticksTextStyle:
                    TextStyle(color: t.secondaryText, fontSize: 9),
                tickBorderData:
                    BorderSide(color: t.borderColor, width: 1),
                gridBorderData:
                    BorderSide(color: t.borderColor, width: 0.8),
                radarBorderData:
                    BorderSide(color: t.borderColor, width: 1),
                getTitle: (index, angle) =>
                    RadarChartTitle(text: _axes[index], angle: 0),
                titleTextStyle: TextStyle(
                    color: t.secondaryText,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
                titlePositionPercentageOffset: 0.15,
              )),
            ),
            const SizedBox(height: Sizes.small),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: data.asMap().entries
                  .map((e) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color:
                                      palette[e.key % palette.length],
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Text(e.value.machineName,
                              style: t.smallText
                                  .override(color: t.secondaryText)),
                        ],
                      ))
                  .toList(),
            ),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TABLE — Per macchinario
// ─────────────────────────────────────────────────────────────────────────────
class _PerMachineTable extends StatelessWidget {
  final ProductionViewModel vm;
  const _PerMachineTable({required this.vm});

  @override
  Widget build(BuildContext context) {
    final t = CLTheme.of(context);
    final data = vm.perMachineData;

    return _Section(
      title: 'Dettaglio per Macchinario',
      description:
          'Unità, costi e qualità nel mese corrente. Badge: verde ≥95% · giallo ≥85% · rosso <85%.',
      contentPadding: const EdgeInsets.fromLTRB(
          Sizes.padding, 4, Sizes.padding, Sizes.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: t.borderColor))),
            child: Row(children: [
              Expanded(
                  flex: 5,
                  child:
                      Text('Macchinario', style: t.bodyLabel)),
              Expanded(
                  flex: 2,
                  child: Text('Unità',
                      style: t.bodyLabel,
                      textAlign: TextAlign.end)),
              Expanded(
                  flex: 2,
                  child: Text('Costo (€)',
                      style: t.bodyLabel,
                      textAlign: TextAlign.end)),
              Expanded(
                  flex: 2,
                  child: Text('Qualità',
                      style: t.bodyLabel,
                      textAlign: TextAlign.end)),
            ]),
          ),
          ...data.map((m) {
            final q = m['quality'] as double;
            final qColor = q >= 95
                ? t.success
                : (q >= 85 ? t.warning : t.danger);
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: t.borderColor, width: 0.5))),
              child: Row(children: [
                Expanded(
                    flex: 5,
                    child: Text(m['name'] as String,
                        style: t.bodyText,
                        overflow: TextOverflow.ellipsis)),
                Expanded(
                    flex: 2,
                    child: Text(
                      (m['units'] as double) > 0
                          ? (m['units'] as double).toStringAsFixed(0)
                          : '—',
                      style: t.bodyText,
                      textAlign: TextAlign.end,
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                        (m['cost'] as double).toStringAsFixed(0),
                        style: t.bodyText,
                        textAlign: TextAlign.end)),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: qColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        q > 0 ? '${q.toStringAsFixed(1)}%' : '—',
                        style: t.smallText.override(
                            color: qColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ]),
            );
          }),
        ],
      ),
    );
  }
}

