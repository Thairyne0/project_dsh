import 'package:intl/intl.dart';
import 'package:project_dsh/modules/store/modules/brand/models/brand.model.dart';
import 'package:project_dsh/modules/store/modules/store_category/models/store_category.model.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';

import '../../../models/store.model.dart';


class StoreReport extends BaseModel {
  @override
  String get modelIdentifier => store.name;

  String id;
  String fileUrl;
  String note;
  String storeId;
  Store store;
  DateTime reportDate;
  double imponibile22;
  double imponibile10;
  double imponibile5;
  double imponibile4;
  double imponibile0;
  double iva22;
  double iva10;
  double iva5;
  double iva4;
  double iva0;
  double totale22;
  double totale10;
  double totale5;
  double totale4;
  double totale0;
  int numeroScontrini22;
  int numeroScontrini10;
  int numeroScontrini5;
  int numeroScontrini4;
  int numeroScontrini0;
  int ingressi;
  DateTime createdAt;




  StoreReport._internal({
    required this.id,
    required this.fileUrl,
    required this.note,
    required this.storeId,
    required this.store,
    required this.reportDate,
    required this.imponibile22,
    required this.imponibile10,
    required this.imponibile5,
    required this.imponibile4,
    required this.imponibile0,
    required this.iva22,
    required this.iva10,
    required this.iva5,
    required this.iva4,
    required this.iva0,
    required this.totale22,
    required this.totale10,
    required this.totale5,
    required this.totale4,
    required this.totale0,
    required this.numeroScontrini22,
    required this.numeroScontrini10,
    required this.numeroScontrini5,
    required this.numeroScontrini4,
    required this.numeroScontrini0,
    required this.ingressi,
    required this.createdAt,
  });

  factory StoreReport({
    String id = "",
    String fileUrl = "",
    String storeId = "",
    String note = "",
    required Store store,
    DateTime? reportDate,
    double imponibile22 = 0.00,
    double imponibile10 = 0.00,
    double imponibile5 = 0.00,
    double imponibile4 = 0.00,
    double imponibile0 = 0.00,
    double iva22 = 0.00,
    double iva10 = 0.00,
    double iva5 = 0.00,
    double iva4 = 0.00,
    double iva0 = 0.00,
    double totale22 = 0.00,
    double totale10 = 0.00,
    double totale5 = 0.00,
    double totale4 = 0.00,
    double totale0 = 0.00,
    int numeroScontrini22 = 0,
    int numeroScontrini10 = 0,
    int numeroScontrini5 = 0,
    int numeroScontrini4 = 0,
    int numeroScontrini0 = 0,
    int ingressi = 0,
    DateTime? createdAt,

  }) {
    return StoreReport._internal(
      id: id,
      fileUrl: fileUrl,
      storeId: storeId,
      note: note,
      store: store,
      reportDate: reportDate ?? DateTime.now(),
      imponibile22: imponibile22,
      imponibile10: imponibile10,
      imponibile5: imponibile5,
      imponibile4: imponibile4,
      imponibile0: imponibile0,
      iva22: iva22,
      iva10: iva10,
      iva5: iva5,
      iva4: iva4,
      iva0: iva0,
      totale22: totale22,
      totale10: totale10,
      totale5: totale5,
      totale4: totale4,
      totale0: totale0,
      numeroScontrini22: numeroScontrini22,
      numeroScontrini10: numeroScontrini10,
      numeroScontrini5: numeroScontrini5,
      numeroScontrini4: numeroScontrini4,
      numeroScontrini0: numeroScontrini0,
      ingressi: ingressi,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  String get reportDateFormat => DateFormat('MM-yyyy').format(reportDate);
  String get createdAtDate => DateFormat('dd-MM-yyyy HH:mm').format(createdAt);


  factory StoreReport.fromJson({
    required dynamic jsonObject,
  }) {
    return StoreReport(
      id: jsonObject["id"]?.toString() ?? "",
      fileUrl: jsonObject["fileUrl"] ?? "",
      storeId: jsonObject["storeId"] ?? "",
      note: jsonObject["note"] ?? "",
      reportDate: jsonObject["reportDate"] != null ? DateTime.parse(jsonObject["reportDate"]).toLocal() : DateTime.now(),
      store: jsonObject["store"] != null ? Store.fromJson(jsonObject: jsonObject["store"]) : Store(brand: Brand(), storeCategory: StoreCategory()),
      imponibile22: double.tryParse(jsonObject["imponibile22"].toString()) ?? 0.00,
      imponibile10: double.tryParse(jsonObject["imponibile10"].toString()) ?? 0.00,
      imponibile5: double.tryParse(jsonObject["imponibile5"].toString()) ?? 0.00,
      imponibile4: double.tryParse(jsonObject["imponibile4"].toString()) ?? 0.00,
      imponibile0: double.tryParse(jsonObject["imponibile0"].toString()) ?? 0.00,
      iva22: double.tryParse(jsonObject["iva22"].toString()) ?? 0.00,
      iva10: double.tryParse(jsonObject["iva10"].toString()) ?? 0.00,
      iva5: double.tryParse(jsonObject["iva5"].toString()) ?? 0.00,
      iva4: double.tryParse(jsonObject["iva4"].toString()) ?? 0.00,
      iva0: double.tryParse(jsonObject["iva0"].toString()) ?? 0.00,
      totale22: double.tryParse(jsonObject["totale22"].toString()) ?? 0.00,
      totale10: double.tryParse(jsonObject["totale10"].toString()) ?? 0.00,
      totale5: double.tryParse(jsonObject["totale5"].toString()) ?? 0.00,
      totale4: double.tryParse(jsonObject["totale4"].toString()) ?? 0.00,
      totale0: double.tryParse(jsonObject["totale0"].toString()) ?? 0.00,
      numeroScontrini22: jsonObject["numeroScontrini22"] ?? 0,
      numeroScontrini10: jsonObject["numeroScontrini10"] ?? 0,
      numeroScontrini5: jsonObject["numeroScontrini5"] ?? 0,
      numeroScontrini4: jsonObject["numeroScontrini4"] ?? 0,
      numeroScontrini0: jsonObject["numeroScontrini0"] ?? 0,
      ingressi: jsonObject["ingressi"] ?? 0,
      createdAt: jsonObject["createdAt"] != null ? DateTime.parse(jsonObject["createdAt"]).toLocal() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileUrl': fileUrl,
      'note': note,
      'storeId': storeId,
      'store': store.toMap(),
      'reportDate': reportDate.toUtc().toIso8601String(),
      'imponibile22': imponibile22,
      'imponibile10': imponibile10,
      'imponibile5': imponibile5,
      'imponibile4': imponibile4,
      'imponibile0': imponibile0,
      'iva22': iva22,
      'iva10': iva10,
      'iva5': iva5,
      'iva4': iva4,
      'iva0': iva0,
      'totale22': totale22,
      'totale10': totale10,
      'totale5': totale5,
      'totale4': totale4,
      'totale0': totale0,
      'numeroScontrini22': numeroScontrini22,
      'numeroScontrini10': numeroScontrini10,
      'numeroScontrini5': numeroScontrini5,
      'numeroScontrini4': numeroScontrini4,
      'numeroScontrini0': numeroScontrini0,
      'ingressi': ingressi,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }
}
