import 'package:flutter/material.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/api_manager.util.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../data/machines_data.dart';
import '../../../models/machine.model.dart';

class ManageMachineViewModel extends CLBaseViewModel {
  // Lista mutabile (copia locale dei dati fittizi)
  List<Machine> machines = [];
  Machine? selectedMachine;

  PagedDataTableController<String, String, Machine> machinesTableController =
      PagedDataTableController<String, String, Machine>();

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

  /// Fetch compatibile con PagedDataTable — serve la lista locale con filtro sul nome
  Future<(List<Machine>, Pagination?)> fetchMachines({
    int? page,
    int? perPage,
    Map<String, dynamic>? searchBy,
    Map<String, dynamic>? orderBy,
  }) async {
    List<Machine> result = List<Machine>.from(machines);

    // Filtro testuale sul nome
    final query = searchBy?['name']?.toString().toLowerCase() ?? '';
    if (query.isNotEmpty) {
      result = result.where((m) => m.name.toLowerCase().contains(query)).toList();
    }

    // Ordinamento
    if (orderBy != null && orderBy.isNotEmpty) {
      final col = orderBy.keys.first;
      final desc = orderBy[col] == true;
      result.sort((a, b) {
        int cmp = 0;
        switch (col) {
          case 'name':          cmp = a.name.compareTo(b.name); break;
          case 'location':      cmp = a.location.compareTo(b.location); break;
          case 'operatingHours': cmp = a.operatingHours.compareTo(b.operatingHours); break;
          case 'efficiency':    cmp = a.efficiency.compareTo(b.efficiency); break;
        }
        return desc ? -cmp : cmp;
      });
    }

    final pageSize = perPage ?? result.length;
    final currentPage = (page != null ? int.tryParse(page.toString()) ?? 1 : 1);
    final start = (currentPage - 1) * pageSize;
    final end = (start + pageSize).clamp(0, result.length);
    final pageItems = result.sublist(start.clamp(0, result.length), end);
    final totalPages = (result.length / pageSize).ceil();
    final hasNext = currentPage < totalPages;

    final pagination = Pagination();
    pagination.total = result.length;
    pagination.perPage = pageSize;
    pagination.currentPage = currentPage;
    pagination.lastPage = totalPages;
    pagination.next = hasNext ? currentPage + 1 : null;

    return (pageItems, pagination);
  }

  /// Simula eliminazione e aggiorna la tabella
  Future<void> deleteMachine(String id) async {
    machines.removeWhere((m) => m.id == id);
    machinesTableController.refresh();
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
