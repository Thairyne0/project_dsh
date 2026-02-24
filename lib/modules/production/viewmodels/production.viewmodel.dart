import 'package:flutter/material.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/models/pageaction.model.dart';
import '../data/production_data.dart';
import '../models/production.model.dart';

enum ProductionViewMode { monthly, weekly }

class ProductionViewModel extends CLBaseViewModel {
  List<MonthlyProductionSummary> monthlySummaries = [];
  ProductionKpi? kpi;
  ProductionViewMode viewMode = ProductionViewMode.monthly;

  /// Indice del mese selezionato nel grafico (default: ultimo)
  int selectedMonthIndex = 11;

  // ── Filtro macchinario ────────────────────────────────────────────────
  /// null = tutti i macchinari
  String? selectedMachineId;

  // ── Alert (dismissabili) ──────────────────────────────────────────────
  late List<ProductionAlert> _activeAlerts;
  List<ProductionAlert> get alerts => _activeAlerts;

  // ── OEE ───────────────────────────────────────────────────────────────
  List<OeeMachine> oeeData = [];

  // ── Radar ─────────────────────────────────────────────────────────────
  List<MachineRadarData> radarData = [];

  // ── Proiezione ────────────────────────────────────────────────────────
  ProjectionData? projection;

  ProductionViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    monthlySummaries = List.from(ProductionData.monthlySummaries);
    kpi = ProductionData.currentKpi;
    selectedMonthIndex = monthlySummaries.length - 1;
    _activeAlerts = List.from(ProductionData.alerts);
    oeeData = List.from(ProductionData.oeeData);
    radarData = List.from(ProductionData.radarData);
    projection = ProductionData.projection;
    setBusy(false);
  }

  void setViewMode(ProductionViewMode mode) {
    viewMode = mode;
    notifyListeners();
  }

  void selectMonth(int index) {
    selectedMonthIndex = index;
    notifyListeners();
  }

  // ── Filtro macchinario ────────────────────────────────────────────────
  void selectMachine(String? id) {
    selectedMachineId = id;
    notifyListeners();
  }

  /// Nomi + id di tutti i macchinari (per il chip selector)
  List<Map<String, String>> get machineOptions => ProductionData.perMachine
      .map((m) => {'id': m['id'] as String, 'name': m['name'] as String})
      .toList();

  /// Dati perMachine filtrati per macchinario selezionato
  List<Map<String, dynamic>> get perMachineData {
    if (selectedMachineId == null) return ProductionData.perMachine;
    return ProductionData.perMachine
        .where((m) => m['id'] == selectedMachineId)
        .toList();
  }

  /// OEE filtrato
  List<OeeMachine> get filteredOee {
    if (selectedMachineId == null) return oeeData;
    return oeeData.where((m) => m.machineId == selectedMachineId).toList();
  }

  // ── Alert dismiss ─────────────────────────────────────────────────────
  void dismissAlert(ProductionAlert alert) {
    _activeAlerts.remove(alert);
    notifyListeners();
  }

  // ── Getter grafici ────────────────────────────────────────────────────
  MonthlyProductionSummary? get selectedMonth =>
      monthlySummaries.isNotEmpty ? monthlySummaries[selectedMonthIndex] : null;

  List<double> get productionBarValues =>
      monthlySummaries.map((m) => m.totalUnits).toList();

  List<double> get costLineValues =>
      monthlySummaries.map((m) => m.totalCostEur).toList();

  List<double> get qualityLineValues =>
      monthlySummaries.map((m) => m.avgQualityRate).toList();

  List<String> get monthLabels =>
      monthlySummaries.map((m) => m.monthLabel).toList();

  Map<String, double> get costBreakdown => ProductionData.costBreakdown;

  List<Map<String, dynamic>> get weeklyData => ProductionData.last7Days;
}
