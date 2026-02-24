/// Dati produzione giornaliera per un macchinario
class DailyProduction {
  final String machineId;
  final String machineName;
  final DateTime date;
  final double unitsProduced;
  final double defectiveUnits;
  final double operatingHours;
  final double energyConsumptionKwh;
  final double maintenanceCostEur;
  final double materialCostEur;

  const DailyProduction({
    required this.machineId,
    required this.machineName,
    required this.date,
    required this.unitsProduced,
    required this.defectiveUnits,
    required this.operatingHours,
    required this.energyConsumptionKwh,
    required this.maintenanceCostEur,
    required this.materialCostEur,
  });

  double get totalCostEur => energyConsumptionKwh * 0.25 + maintenanceCostEur + materialCostEur;
  double get qualityRate => unitsProduced > 0 ? ((unitsProduced - defectiveUnits) / unitsProduced) * 100 : 0;
}

/// Aggregato mensile per grafici
class MonthlyProductionSummary {
  final int month; // 1..12
  final int year;
  final double totalUnits;
  final double totalCostEur;
  final double totalEnergyKwh;
  final double avgQualityRate;

  const MonthlyProductionSummary({
    required this.month,
    required this.year,
    required this.totalUnits,
    required this.totalCostEur,
    required this.totalEnergyKwh,
    required this.avgQualityRate,
  });

  String get monthLabel {
    const months = ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic'];
    return months[month - 1];
  }
}

/// KPI summary per la hero section
class ProductionKpi {
  final double totalUnitsThisMonth;
  final double totalCostThisMonth;
  final double totalEnergyThisMonth;
  final double avgQualityRate;
  final double productionTrend; // % rispetto al mese precedente
  final double costTrend;

  const ProductionKpi({
    required this.totalUnitsThisMonth,
    required this.totalCostThisMonth,
    required this.totalEnergyThisMonth,
    required this.avgQualityRate,
    required this.productionTrend,
    required this.costTrend,
  });
}

/// OEE (Overall Equipment Effectiveness) per un macchinario
/// OEE = Disponibilità × Performance × Qualità
class OeeMachine {
  final String machineId;
  final String machineName;
  final double availability;   // 0..100 %
  final double performance;    // 0..100 %
  final double quality;        // 0..100 %

  const OeeMachine({
    required this.machineId,
    required this.machineName,
    required this.availability,
    required this.performance,
    required this.quality,
  });

  double get oee => (availability / 100) * (performance / 100) * (quality / 100) * 100;

  String get oeeLabel {
    if (oee >= 85) return 'Eccellente';
    if (oee >= 65) return 'Accettabile';
    return 'Da migliorare';
  }
}

/// Dati per il radar chart di confronto tra macchinari
/// Ogni asse è normalizzato 0..100
class MachineRadarData {
  final String machineName;
  final double units;       // produzione normalizzata
  final double quality;     // qualità %
  final double efficiency;  // efficienza energetica normalizzata
  final double availability;// disponibilità %
  final double cost;        // costo invertito (100 - costo_norm)

  const MachineRadarData({
    required this.machineName,
    required this.units,
    required this.quality,
    required this.efficiency,
    required this.availability,
    required this.cost,
  });

  List<double> get values => [units, quality, efficiency, availability, cost];
}

/// Alert automatico quando una metrica supera/scende sotto soglia
enum AlertSeverity { info, warning, critical }

class ProductionAlert {
  final String machineId;
  final String machineName;
  final String message;
  final AlertSeverity severity;
  final String metric;     // es. "qualità", "costo", "fermo"
  final double value;
  final double threshold;

  const ProductionAlert({
    required this.machineId,
    required this.machineName,
    required this.message,
    required this.severity,
    required this.metric,
    required this.value,
    required this.threshold,
  });
}

/// Proiezione fine mese basata sul ritmo attuale
class ProjectionData {
  final double currentUnits;
  final double projectedUnits;
  final double currentCost;
  final double projectedCost;
  final double budgetTarget;
  final double productionTarget;
  final int daysElapsed;
  final int totalDaysInMonth;

  const ProjectionData({
    required this.currentUnits,
    required this.projectedUnits,
    required this.currentCost,
    required this.projectedCost,
    required this.budgetTarget,
    required this.productionTarget,
    required this.daysElapsed,
    required this.totalDaysInMonth,
  });

  double get progressPct => daysElapsed / totalDaysInMonth * 100;
  double get unitsVsTarget => projectedUnits / productionTarget * 100;
  double get costVsBudget => projectedCost / budgetTarget * 100;
  bool get onTrackProduction => unitsVsTarget >= 95;
  bool get onTrackCost => costVsBudget <= 105;
}
