import 'package:flutter/material.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../data/machines_data.dart';
import '../../../models/machine.model.dart';

class ManageMachineViewModel extends CLBaseViewModel {
  // Lista mutabile (copia locale dei dati fittizi)
  List<Machine> machines = [];
  Machine? selectedMachine;

  // Form controllers
  TextEditingController nameTEC = TextEditingController();
  TextEditingController modelTEC = TextEditingController();
  TextEditingController serialNumberTEC = TextEditingController();
  TextEditingController locationTEC = TextEditingController();
  TextEditingController lastMaintenanceTEC = TextEditingController();
  TextEditingController operatingHoursTEC = TextEditingController();
  TextEditingController rpmTEC = TextEditingController();
  TextEditingController temperatureTEC = TextEditingController();
  TextEditingController efficiencyTEC = TextEditingController();
  MachineStatus selectedStatus = MachineStatus.idle;
  String selectedIconCategory = 'lathe';

  ManageMachineViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);

    switch (viewModelType) {
      case VMType.list:
        machines = List<Machine>.from(MachinesData.machines);
        break;
      case VMType.create:
        break;
      case VMType.edit:
        final String id = extraParams as String;
        selectedMachine = MachinesData.machines.firstWhere((m) => m.id == id);
        _populateFormFromMachine(selectedMachine!);
        break;
      default:
        break;
    }

    setBusy(false);
  }

  void _populateFormFromMachine(Machine m) {
    nameTEC.text = m.name;
    modelTEC.text = m.model;
    serialNumberTEC.text = m.serialNumber;
    locationTEC.text = m.location;
    lastMaintenanceTEC.text = m.lastMaintenance;
    operatingHoursTEC.text = m.operatingHours.toString();
    rpmTEC.text = m.rpm.toString();
    temperatureTEC.text = m.temperature.toString();
    efficiencyTEC.text = m.efficiency.toString();
    selectedStatus = m.status;
    selectedIconCategory = m.iconCategory;
    notifyListeners();
  }

  void setStatus(MachineStatus status) {
    selectedStatus = status;
    notifyListeners();
  }

  void setIconCategory(String cat) {
    selectedIconCategory = cat;
    notifyListeners();
  }

  /// Simula eliminazione (dati fittizi, rimuove dalla lista locale)
  Future<void> deleteMachine(String id) async {
    machines.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  @override
  void dispose() {
    nameTEC.dispose();
    modelTEC.dispose();
    serialNumberTEC.dispose();
    locationTEC.dispose();
    lastMaintenanceTEC.dispose();
    operatingHoursTEC.dispose();
    rpmTEC.dispose();
    temperatureTEC.dispose();
    efficiencyTEC.dispose();
    super.dispose();
  }
}
