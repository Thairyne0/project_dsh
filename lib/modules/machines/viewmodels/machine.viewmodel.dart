import 'package:flutter/material.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/models/pageaction.model.dart';
import '../data/machines_data.dart';
import '../models/machine.model.dart';

class MachineViewModel extends CLBaseViewModel {
  List<Machine> machines = [];
  List<Machine> filteredMachines = [];
  MachineStatus? selectedStatusFilter;
  Machine? selectedMachine;

  MachineViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);

    switch (viewModelType) {
      case VMType.list:
        machines = List<Machine>.from(MachinesData.machines);
        filteredMachines = machines;
        break;
      case VMType.detail:
        final String id = extraParams as String;
        selectedMachine = MachinesData.machines.firstWhere((m) => m.id == id);
        break;
      default:
        break;
    }

    setBusy(false);
  }

  void filterByStatus(MachineStatus? status) {
    selectedStatusFilter = status;
    if (status == null) {
      filteredMachines = machines;
    } else {
      filteredMachines = machines.where((m) => m.status == status).toList();
    }
    notifyListeners();
  }

  int get runningCount => machines.where((m) => m.status == MachineStatus.running).length;
  int get idleCount => machines.where((m) => m.status == MachineStatus.idle).length;
  int get maintenanceCount => machines.where((m) => m.status == MachineStatus.maintenance).length;
  int get errorCount => machines.where((m) => m.status == MachineStatus.error).length;
}

