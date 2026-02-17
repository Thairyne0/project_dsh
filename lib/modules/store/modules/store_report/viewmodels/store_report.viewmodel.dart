import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import '../../../../../ui/widgets/alertmanager/alert_manager.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/api_manager.util.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../constants/store_api_calls.constant.dart';
import '../../../models/store.model.dart';
import '../constants/store_report_api_calls.constant.dart';
import '../models/store_report.model.dart';


class StoreReportViewModel extends CLBaseViewModel {
  late TextEditingController nameTEC = TextEditingController();
  late TextEditingController imponibile22TEC = TextEditingController();
  late TextEditingController imponibile10TEC = TextEditingController();
  late TextEditingController imponibile5TEC = TextEditingController();
  late TextEditingController imponibile4TEC = TextEditingController();
  late TextEditingController imponibile0TEC = TextEditingController();
  late TextEditingController iva22TEC = TextEditingController();
  late TextEditingController iva10TEC = TextEditingController();
  late TextEditingController iva5TEC = TextEditingController();
  late TextEditingController iva4TEC = TextEditingController();
  late TextEditingController iva0TEC = TextEditingController();
  late TextEditingController totale22TEC = TextEditingController();
  late TextEditingController totale10TEC = TextEditingController();
  late TextEditingController totale5TEC = TextEditingController();
  late TextEditingController totale4TEC = TextEditingController();
  late TextEditingController totale0TEC = TextEditingController();
  late TextEditingController numeroScontrini22TEC = TextEditingController();
  late TextEditingController numeroScontrini10TEC = TextEditingController();
  late TextEditingController numeroScontrini5TEC = TextEditingController();
  late TextEditingController numeroScontrini4TEC = TextEditingController();
  late TextEditingController numeroScontrini0TEC = TextEditingController();
  late TextEditingController ingressiTEC = TextEditingController();
  late TextEditingController reportDateTEC = TextEditingController();
  late TextEditingController noteTEC = TextEditingController();
  DateTime? selectedReportDateFormat;
  late String storeReportId;
  late String storeId;
  late StoreReport storeReport;
  Store? selectedStore;



  PagedDataTableController<String, String, StoreReport> storeReportTableController = PagedDataTableController<String, String, StoreReport>();

  StoreReportViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    switch (viewModelType) {
      case VMType.list:
        break;
      case VMType.create:
        String storeId = extraParams;
        if (storeId.isNotEmpty) {
          selectedStore = await getStore(storeId);
        }
        break;
      case VMType.edit:
        String storeReportId = extraParams;
        storeReport = await getStoreReport(storeReportId);
        break;
      case VMType.detail:
        String storeReportId = extraParams;
        storeReport = await getStoreReport(storeReportId);
        break;
      case VMType.other:
        break;
    }
    setBusy(false);
  }

  Future<(List<StoreReport>, Pagination?)> getAllStoreReport(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<StoreReport> storeReportArray = [];
    ApiCallResponse apiCallResponse =
        await StoreReportCalls.getAllStoreReport(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final storeCategoriesJsonObject = (apiCallResponse.jsonBody as List);
      storeCategoriesJsonObject.asMap().forEach(
        (index, jsonObject) {
          storeReportArray.add(StoreReport.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (storeReportArray, apiCallResponse.pagination);
  }

  Future<StoreReport> getStoreReport(storeReportId) async {
    late StoreReport downloadedStoreReport;
    ApiCallResponse apiCallResponse = await StoreReportCalls.getStoreReport(viewContext, storeReportId);
    if (apiCallResponse.succeeded) {
      downloadedStoreReport = StoreReport.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedStoreReport;
  }

  Future<Store> getStore(storeId) async {
    late Store downloadedStore;
    ApiCallResponse apiCallResponse = await StoreCalls.getStore(viewContext, storeId);
    if (apiCallResponse.succeeded) {
      downloadedStore = Store.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedStore;
  }

  Future<(List<Store>, Pagination?)> getAllStore({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<Store> storeArray = [];
    ApiCallResponse apiCallResponse = await StoreCalls.getAllStore(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final storesJsonObject = (apiCallResponse.jsonBody as List);
      storesJsonObject.asMap().forEach(
            (index, jsonObject) {
          storeArray.add(Store.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (storeArray, apiCallResponse.pagination);
  }

  Future deleteStoreReport(storeReportId) async {
    setBusy(true);
    await StoreReportCalls.deleteStoreReport(viewContext, storeReportId);
    setBusy(false);
  }


  Future createStoreReport() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "storeId": selectedStore?.id.toString(),
      "imponibile22": double.tryParse(imponibile22TEC.text) ?? 0.00,
      "imponibile10": double.tryParse(imponibile10TEC.text) ?? 0.00,
      "imponibile5": double.tryParse(imponibile5TEC.text) ?? 0.00,
      "imponibile4": double.tryParse(imponibile4TEC.text) ?? 0.00,
      "imponibile0": double.tryParse(imponibile0TEC.text) ?? 0.00,
      "iva22": double.tryParse(iva22TEC.text) ?? 0.00,
      "iva10": double.tryParse(iva10TEC.text) ?? 0.00,
      "iva5": double.tryParse(iva5TEC.text) ?? 0.00,
      "iva4": double.tryParse(iva4TEC.text) ?? 0.00,
      "iva0": double.tryParse(iva0TEC.text) ?? 0.00,
      "totale22": double.tryParse(totale22TEC.text) ?? 0.00,
      "totale10": double.tryParse(totale10TEC.text) ?? 0.00,
      "totale5": double.tryParse(totale5TEC.text) ?? 0.00,
      "totale4": double.tryParse(totale4TEC.text) ?? 0.00,
      "totale0": double.tryParse(totale0TEC.text) ?? 0.00,
      "numeroScontrini22": int.tryParse(numeroScontrini22TEC.text) ?? 0,
      "numeroScontrini10": int.tryParse(numeroScontrini10TEC.text) ?? 0,
      "numeroScontrini5": int.tryParse(numeroScontrini5TEC.text) ?? 0,
      "numeroScontrini4": int.tryParse(numeroScontrini4TEC.text) ?? 0,
      "numeroScontrini0": int.tryParse(numeroScontrini0TEC.text) ?? 0,
      "ingressi": int.tryParse(ingressiTEC.text) ?? 0,
      "reportDate": selectedReportDateFormat!.toUtc().toIso8601String(),
      "note": noteTEC.text
    };
    ApiCallResponse apiCallResponse = await StoreReportCalls.createStoreReport(viewContext, params);

    setBusy(false);
  }

  Future updateStoreReport(String storeReportId) async {
    setBusy(true);
    Map<String, dynamic> params = {
    };
    ApiCallResponse apiCallResponse = await StoreReportCalls.updateStoreReport(viewContext, params, storeReportId);
    setBusy(false);
  }


  Future<void> downloadExcelReport() async {
    setBusy(true);
    final params = {
      "reportDate": selectedReportDateFormat!.toUtc().toIso8601String(),
    };

    ApiCallResponse apiCallResponse = await StoreReportCalls.downloadReportExcel(viewContext, params);
    if (apiCallResponse.succeeded) {
      Uint8List bytes = base64Decode(apiCallResponse.jsonBody["file"]);
      if (!kIsWeb) {
        String? filePath = await FilePicker.platform.saveFile(
          dialogTitle: 'Seleziona il percorso per salvare il file',
          fileName: apiCallResponse.jsonBody["fileName"],
        );
        if (filePath != null) {
          File file = File(filePath);
          await file.writeAsBytes(bytes);
          AlertManager.showSuccess('Completato!', 'File scaricato con successo.');
        } else {
          AlertManager.showDanger('Errore!', 'Il download del file è stato annullato.');
        }
      } else {
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", apiCallResponse.jsonBody["fileName"].toString())
          ..click();
        html.Url.revokeObjectUrl(url);
        AlertManager.showSuccess('Completato!', 'File scaricato con successo.');
      }
    }
    setBusy(false);
  }
}
