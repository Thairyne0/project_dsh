enum MachineStatus { running, idle, maintenance, error }

class Machine {
  final String id;
  final String name;
  final String model;
  final String serialNumber;
  final MachineStatus status;
  final double rpm;
  final double temperature;
  final double efficiency;
  final String location;
  final String lastMaintenance;
  final int operatingHours;
  final String iconCategory;

  const Machine({
    required this.id,
    required this.name,
    required this.model,
    required this.serialNumber,
    required this.status,
    required this.rpm,
    required this.temperature,
    required this.efficiency,
    required this.location,
    required this.lastMaintenance,
    required this.operatingHours,
    required this.iconCategory,
  });

  String get statusLabel {
    switch (status) {
      case MachineStatus.running:
        return 'In funzione';
      case MachineStatus.idle:
        return 'In attesa';
      case MachineStatus.maintenance:
        return 'In manutenzione';
      case MachineStatus.error:
        return 'Errore';
    }
  }
}

