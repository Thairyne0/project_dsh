import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:project_dsh/ui/widgets/alertmanager/alert_manager.dart';
import 'package:project_dsh/ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/api_manager.util.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/models/upload_file.model.dart';
import '../../../constants/store_api_calls.constant.dart';
import '../../../models/store.model.dart';
import '../constants/promo_api_calls.constant.dart';
import '../models/promo.model.dart';

class PromoViewModel extends CLBaseViewModel {
  late TextEditingController titleTEC = TextEditingController();
  QuillController descriptionTEC = QuillController.basic();
  quill.Document? _descriptionDoc;
  quill.Document? get descriptionDoc => _descriptionDoc;
  QuillController ruleTextTEC = QuillController.basic();
  quill.Document? _ruleTextDoc;
  quill.Document? get ruleTextDoc => _ruleTextDoc;
  late TextEditingController startingAtTEC = TextEditingController();
  late TextEditingController endingAtTEC = TextEditingController();
  late TextEditingController qtyTEC = TextEditingController();
  late TextEditingController qtyPerUserTEC = TextEditingController();
  DateTime? selectedStartingAt;
  bool isHighlighted = false;
  DateTime? selectedEndingAt;
  CLMedia? imageFile;
  late Promo promo;
  Store? selectedStore;
  PagedDataTableController<String, String, Promo> promoTableController = PagedDataTableController<String, String, Promo>();

  PromoViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
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
        if (storeId.isNotEmpty && storeId!="noShop") {
          selectedStore = await getStore(storeId);
        }
        break;
      case VMType.edit:
        String promoId = extraParams as String;
        promo = await getPromo(promoId);
        titleTEC.text = promo.title;
        descriptionTEC.document = Document.fromJson(jsonDecode(promo.description));
        ruleTextTEC.document = Document.fromJson(jsonDecode(promo.ruleText));
        qtyTEC.text = promo.qty.toString();
        qtyPerUserTEC.text = promo.qtyPerUser.toString();
        selectedStore = promo.store;
        startingAtTEC.text = promo.startingAtDate;
        endingAtTEC.text = promo.endingAtDate;
        selectedStartingAt = promo.startingAt;
        selectedEndingAt = promo.endingAt;
        isHighlighted = promo.isHighlighted;
        break;
      case VMType.detail:
        String promoId = extraParams as String;
        promo = await getPromo(promoId);
        _ruleTextDoc = parseQuillFromRaw(promo.ruleText);
        _descriptionDoc = parseQuillFromRaw(promo.description);
        break;
      default:
        break;
    }
    setBusy(false);
  }

  quill.Document parseQuillFromRaw(String? rawJson, {String fallbackText = 'Contenuto non disponibile'}) {
    if (rawJson == null || rawJson.trim().isEmpty) {
      return quill.Document()..insert(0, fallbackText);
    }
    try {
      final delta = jsonDecode(rawJson);
      return quill.Document.fromJson(delta);
    } catch (e) {
      print("Errore nel parsing Quill: $e");
      return quill.Document()..insert(0, fallbackText);
    }
  }

  Future<(List<Promo>, Pagination?)> getAllPromo({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<Promo> promoArray = [];
    ApiCallResponse apiCallResponse = await PromoCalls.getAllPromo(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final promosJsonObject = (apiCallResponse.jsonBody as List);
      promosJsonObject.asMap().forEach(
        (index, jsonObject) {
          promoArray.add(Promo.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (promoArray, apiCallResponse.pagination);
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

  Future<Promo> getPromo(promoId) async {
    late Promo downloadedPromo;
    ApiCallResponse apiCallResponse = await PromoCalls.getPromo(viewContext, promoId);
    if (apiCallResponse.succeeded) {
      downloadedPromo = Promo.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedPromo;
  }

  Future deletePromo(promoId) async {
    setBusy(true);
    await PromoCalls.deletePromo(viewContext, promoId);
    setBusy(false);
  }

  Future createPromo() async {
    setBusy(true);
    if (imageFile == null) {
      AlertManager.showDanger("Errore", "Non hai inserito l'immagine");
      return;
    }
    Map<String, dynamic> params = {
      "title": titleTEC.text,
      "description": jsonEncode(descriptionTEC.document.toDelta().toJson()) ,
      "ruleText": jsonEncode(ruleTextTEC.document.toDelta().toJson()) ,
      'startingAt': selectedStartingAt?.toUtc().toIso8601String(),
      "endingAt": selectedEndingAt?.toUtc().toIso8601String(),
      "qty": int.tryParse(qtyTEC.text) ?? 0,
      "qtyPerUser": int.tryParse(qtyPerUserTEC.text) ?? 0,
      "storeId": selectedStore?.id,
      "isHighlighted": isHighlighted,
    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    await PromoCalls.createPromo(viewContext, params);
    setBusy(false);
  }

  Future updatePromo(String promoId) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "title": titleTEC.text,
      "description": jsonEncode(descriptionTEC.document.toDelta().toJson()) ,
      "ruleText": jsonEncode(ruleTextTEC.document.toDelta().toJson()) ,
      'startingAt': selectedStartingAt?.toUtc().toIso8601String(),
      "endingAt": selectedEndingAt?.toUtc().toIso8601String(),
      "qty": int.tryParse(qtyTEC.text) ?? 0,
      "qtyPerUser": int.tryParse(qtyPerUserTEC.text) ?? 0,
      "storeId": selectedStore?.id,
      "isHighlighted": isHighlighted,
    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await PromoCalls.updatePromo(viewContext, params, promoId);
    setBusy(false);
  }

  Future<Store> getStore(storeId) async {
    late Store downloadedStore;
    ApiCallResponse apiCallResponse = await StoreCalls.getStore(viewContext, storeId);
    if (apiCallResponse.succeeded) {
      downloadedStore = Store.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedStore;
  }

  Future<void> updatePromoStatus(String eventId, int newStatus) async {
    setBusy(true);
    try {
      Map<String, dynamic> params = {
        "status": newStatus,
      };
      ApiCallResponse apiCallResponse = await PromoCalls.updatePromo(viewContext, params, eventId);
    } catch (e) {
      print("Errore durante l'aggiornamento dello stato: $e");
    } finally {
      setBusy(false);
    }
  }
  void setIsHighlighted(bool newValue) {
    isHighlighted = newValue;
    notifyListeners();
  }
}
