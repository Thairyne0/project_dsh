import '../models/production.model.dart';

class ProductionData {
  /// Ultimi 12 mesi di dati aggregati
  static final List<MonthlyProductionSummary> monthlySummaries = [
    MonthlyProductionSummary(month: 3, year: 2025, totalUnits: 18400, totalCostEur: 42300, totalEnergyKwh: 96200, avgQualityRate: 91.2),
    MonthlyProductionSummary(month: 4, year: 2025, totalUnits: 20100, totalCostEur: 45800, totalEnergyKwh: 101500, avgQualityRate: 92.8),
    MonthlyProductionSummary(month: 5, year: 2025, totalUnits: 22300, totalCostEur: 48200, totalEnergyKwh: 108400, avgQualityRate: 93.5),
    MonthlyProductionSummary(month: 6, year: 2025, totalUnits: 19800, totalCostEur: 44100, totalEnergyKwh: 99800, avgQualityRate: 90.1),
    MonthlyProductionSummary(month: 7, year: 2025, totalUnits: 21500, totalCostEur: 47600, totalEnergyKwh: 105200, avgQualityRate: 94.0),
    MonthlyProductionSummary(month: 8, year: 2025, totalUnits: 17200, totalCostEur: 39900, totalEnergyKwh: 88600, avgQualityRate: 89.3),
    MonthlyProductionSummary(month: 9, year: 2025, totalUnits: 23600, totalCostEur: 52100, totalEnergyKwh: 114300, avgQualityRate: 95.2),
    MonthlyProductionSummary(month: 10, year: 2025, totalUnits: 24800, totalCostEur: 54700, totalEnergyKwh: 119600, avgQualityRate: 96.1),
    MonthlyProductionSummary(month: 11, year: 2025, totalUnits: 23100, totalCostEur: 51200, totalEnergyKwh: 112800, avgQualityRate: 94.7),
    MonthlyProductionSummary(month: 12, year: 2025, totalUnits: 20400, totalCostEur: 46300, totalEnergyKwh: 102100, avgQualityRate: 92.3),
    MonthlyProductionSummary(month: 1, year: 2026, totalUnits: 22700, totalCostEur: 50400, totalEnergyKwh: 110700, avgQualityRate: 93.9),
    MonthlyProductionSummary(month: 2, year: 2026, totalUnits: 25200, totalCostEur: 55900, totalEnergyKwh: 123400, avgQualityRate: 96.8),
  ];

  /// Costi ripartiti per categoria (ultimo mese)
  static const Map<String, double> costBreakdown = {
    'Energia': 30850,
    'Manutenzione': 12400,
    'Materiali': 12650,
  };

  /// Produzione per macchinario (ultimo mese)
  static const List<Map<String, dynamic>> perMachine = [
    {'id': '001', 'name': 'Tornio CNC Alpha', 'units': 6800.0, 'cost': 14200.0, 'quality': 97.1},
    {'id': '002', 'name': 'Fresatrice Beta',  'units': 5400.0, 'cost': 11800.0, 'quality': 95.3},
    {'id': '003', 'name': 'Pressa Idraulica', 'units': 3200.0, 'cost':  8900.0, 'quality': 91.0},
    {'id': '004', 'name': 'Robot Saldatura',  'units': 4800.0, 'cost': 10500.0, 'quality': 98.2},
    {'id': '005', 'name': 'Compressore Zeta', 'units':    0.0, 'cost':  2100.0, 'quality':  0.0},
    {'id': '006', 'name': 'Laser Eta',        'units': 3100.0, 'cost':  6900.0, 'quality': 99.1},
    {'id': '007', 'name': 'Rettificatrice',   'units': 1900.0, 'cost':  5200.0, 'quality': 94.6},
  ];

  /// KPI mese corrente
  static final ProductionKpi currentKpi = ProductionKpi(
    totalUnitsThisMonth: 25200,
    totalCostThisMonth: 55900,
    totalEnergyThisMonth: 123400,
    avgQualityRate: 96.8,
    productionTrend: 10.9,   // +10.9% vs mese scorso
    costTrend: 10.9,
  );

  /// Ultimi 7 giorni (produzione giornaliera aggregata)
  static final List<Map<String, dynamic>> last7Days = [
    {'day': 'Lun', 'units': 820.0, 'cost': 1820.0},
    {'day': 'Mar', 'units': 940.0, 'cost': 2050.0},
    {'day': 'Mer', 'units': 870.0, 'cost': 1940.0},
    {'day': 'Gio', 'units': 990.0, 'cost': 2180.0},
    {'day': 'Ven', 'units': 1050.0, 'cost': 2310.0},
    {'day': 'Sab', 'units': 610.0, 'cost': 1380.0},
    {'day': 'Dom', 'units': 420.0, 'cost':  960.0},
  ];

  /// OEE per macchinario (mese corrente)
  static const List<OeeMachine> oeeData = [
    OeeMachine(machineId: '001', machineName: 'Tornio CNC Alpha',  availability: 93.2, performance: 88.4, quality: 97.1),
    OeeMachine(machineId: '002', machineName: 'Fresatrice Beta',   availability: 89.5, performance: 84.0, quality: 95.3),
    OeeMachine(machineId: '003', machineName: 'Pressa Idraulica',  availability: 61.0, performance: 72.5, quality: 91.0),
    OeeMachine(machineId: '004', machineName: 'Robot Saldatura',   availability: 95.8, performance: 91.2, quality: 98.2),
    OeeMachine(machineId: '005', machineName: 'Compressore Zeta',  availability: 12.0, performance: 0.0,  quality:  0.0),
    OeeMachine(machineId: '006', machineName: 'Laser Eta',         availability: 91.3, performance: 87.6, quality: 99.1),
    OeeMachine(machineId: '007', machineName: 'Rettificatrice',    availability: 78.4, performance: 76.0, quality: 94.6),
  ];

  /// Radar chart — 5 assi normalizzati 0-100 per ogni macchinario
  /// (solo prime 5 macchine attive per leggibilità)
  static const List<MachineRadarData> radarData = [
    MachineRadarData(machineName: 'Tornio Alpha',  units: 100.0, quality: 97.1, efficiency: 88.0, availability: 93.2, cost: 72.0),
    MachineRadarData(machineName: 'Fresatrice Beta', units: 79.4, quality: 95.3, efficiency: 80.0, availability: 89.5, cost: 68.0),
    MachineRadarData(machineName: 'Robot Saldatura', units: 70.6, quality: 98.2, efficiency: 92.0, availability: 95.8, cost: 74.0),
    MachineRadarData(machineName: 'Laser Eta',     units: 45.6, quality: 99.1, efficiency: 95.0, availability: 91.3, cost: 81.0),
    MachineRadarData(machineName: 'Rettificatrice', units: 27.9, quality: 94.6, efficiency: 70.0, availability: 78.4, cost: 65.0),
  ];

  /// Alert automatici generati dalle soglie
  static const List<ProductionAlert> alerts = [
    ProductionAlert(
      machineId: '005', machineName: 'Compressore Zeta',
      message: 'Macchina ferma da oltre 18 giorni — nessuna unità prodotta nel mese corrente.',
      severity: AlertSeverity.critical,
      metric: 'disponibilità', value: 12.0, threshold: 70.0,
    ),
    ProductionAlert(
      machineId: '003', machineName: 'Pressa Idraulica',
      message: 'Disponibilità al 61% — sotto la soglia accettabile del 70%. Pianificare manutenzione.',
      severity: AlertSeverity.warning,
      metric: 'disponibilità', value: 61.0, threshold: 70.0,
    ),
    ProductionAlert(
      machineId: '007', machineName: 'Rettificatrice',
      message: 'OEE al 56.4% — performance sotto il target del 65%. Verificare cicli di lavoro.',
      severity: AlertSeverity.warning,
      metric: 'OEE', value: 56.4, threshold: 65.0,
    ),
    ProductionAlert(
      machineId: '002', machineName: 'Fresatrice Beta',
      message: 'Costo mensile in aumento del 8.3% rispetto al mese precedente.',
      severity: AlertSeverity.info,
      metric: 'costo', value: 11800.0, threshold: 10900.0,
    ),
  ];

  /// Proiezione fine mese (febbraio 2026 — 24 giorni su 28 trascorsi)
  static const ProjectionData projection = ProjectionData(
    currentUnits: 21600,
    projectedUnits: 25200,
    currentCost: 47900,
    projectedCost: 55900,
    budgetTarget: 54000,
    productionTarget: 24000,
    daysElapsed: 24,
    totalDaysInMonth: 28,
  );
}
