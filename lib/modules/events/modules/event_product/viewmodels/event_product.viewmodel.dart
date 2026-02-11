import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/api_manager.util.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../constants/event_api_calls.constant.dart';
import '../../../models/event.model.dart';
import '../costants/event_product_api_calls.costant.dart';
import '../models/event_product.model.dart';

class EventProductViewModel extends CLBaseViewModel {
  late TextEditingController nameTEC = TextEditingController();
  QuillController descriptionTEC = QuillController.basic();
  quill.Document? _descriptionDoc;
  quill.Document? get descriptionDoc => _descriptionDoc;
  late TextEditingController zeroFourPriceTEC = TextEditingController();
  late TextEditingController under14PriceTEC = TextEditingController();
  late TextEditingController defaultPriceTEC = TextEditingController();
  late TextEditingController over65PriceTEC = TextEditingController();
  late TextEditingController zeroFourPointPriceTEC = TextEditingController();
  late TextEditingController under14PointPriceTEC = TextEditingController();
  late TextEditingController defaultPointPriceTEC = TextEditingController();
  late TextEditingController over65PointPriceTEC = TextEditingController();
  late TextEditingController qtyTEC = TextEditingController();
  late TextEditingController qtyPerUserTEC = TextEditingController();
  late String eventProductId;
  Event? selectedEvent;
  late EventProduct eventProduct;
  PagedDataTableController<String, String, EventProduct> eventProductTableController = PagedDataTableController<String, String, EventProduct>();

  EventProductViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    switch (viewModelType) {
      case VMType.list:
        break;
      case VMType.create:
        String eventId = extraParams;
        if (eventId.isNotEmpty) {
          selectedEvent = await getEvent(eventId);
        }
        break;
      case VMType.edit:
        String eventProductId = extraParams;
        eventProduct = await getEventProduct(eventProductId);
        nameTEC.text = eventProduct.name;
        descriptionTEC.document = Document.fromJson(jsonDecode(eventProduct.description));
        under14PriceTEC.text = eventProduct.under14Price.toString();
        zeroFourPriceTEC.text = eventProduct.zeroFourPrice.toString();
        defaultPriceTEC.text = eventProduct.defaultPrice.toString();
        over65PriceTEC.text = eventProduct.over65Price.toString();
        under14PointPriceTEC.text = eventProduct.under14PointPrice.toString();
        zeroFourPointPriceTEC.text = eventProduct.zeroFourPointPrice.toString();
        defaultPointPriceTEC.text = eventProduct.defaultPointPrice.toString();
        over65PointPriceTEC.text = eventProduct.over65PointPrice.toString();
        qtyTEC.text = eventProduct.qty.toString();
        qtyPerUserTEC.text = eventProduct.qtyPerUser.toString();
        selectedEvent = eventProduct.event;
        break;
      case VMType.detail:
        String eventProductId = extraParams;
        eventProduct = await getEventProduct(eventProductId);
        _descriptionDoc = parseQuillFromRaw(eventProduct.description);
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

  Future<(List<EventProduct>, Pagination?)> getEventProductByEvent(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<EventProduct> eventProductArray = [];
    ApiCallResponse apiCallResponse =
        await EventProductCalls.getEventProductByEvent(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final eventProductJsonObject = (apiCallResponse.jsonBody as List);
      eventProductJsonObject.asMap().forEach(
        (index, jsonObject) {
          eventProductArray.add(EventProduct.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (eventProductArray, apiCallResponse.pagination);
  }

  Future<(List<Event>, Pagination?)> getAllEvent({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<Event> eventArray = [];
    ApiCallResponse apiCallResponse = await EventCalls.getAllEvent(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final eventsJsonObject = (apiCallResponse.jsonBody as List);
      eventsJsonObject.asMap().forEach(
        (index, jsonObject) {
          eventArray.add(Event.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (eventArray, apiCallResponse.pagination);
  }

  Future<Event?> getEvent(eventId) async {
    Event? downloadEvent;
    ApiCallResponse apiCallResponse = await EventCalls.getEvent(viewContext, eventId);
    if (apiCallResponse.succeeded) {
      downloadEvent = Event.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadEvent;
  }

  Future<EventProduct> getEventProduct(eventProductId) async {
    late EventProduct downloadedEventProduct;
    ApiCallResponse apiCallResponse = await EventProductCalls.getEventProduct(viewContext, eventProductId);
    if (apiCallResponse.succeeded) {
      downloadedEventProduct = EventProduct.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedEventProduct;
  }

  Future deleteEventProduct(eventProductId) async {
    setBusy(true);
    await EventProductCalls.deleteEventProduct(viewContext, eventProductId);
    setBusy(false);
  }

  Future createEventProduct() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "name": nameTEC.text,
      "description": jsonEncode(descriptionTEC.document.toDelta().toJson()) ,
      "zeroFourPrice": double.tryParse(zeroFourPriceTEC.text) ?? 0.00,
      "under14Price": double.tryParse(under14PriceTEC.text) ?? 0.00,
      "defaultPrice": double.tryParse(defaultPriceTEC.text) ?? 0.00,
      "over65Price": double.tryParse(over65PriceTEC.text) ?? 0.00,
      "zeroFourPointPrice": int.tryParse(zeroFourPointPriceTEC.text) ?? 0,
      "under14PointPrice": int.tryParse(under14PointPriceTEC.text) ?? 0,
      "defaultPointPrice": int.tryParse(defaultPointPriceTEC.text) ?? 0,
      "over65PointPrice": int.tryParse(over65PointPriceTEC.text) ?? 0,
      "qty": int.tryParse(qtyTEC.text) ?? 0,
      "qtyPerUser": int.tryParse(qtyPerUserTEC.text) ?? 0,
      "eventId": selectedEvent?.id,
    };
    ApiCallResponse apiCallResponse = await EventProductCalls.createEventProduct(viewContext, params);
    setBusy(false);
  }

  Future updateEventProduct(String eventProductId) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "name": nameTEC.text,
      "description": jsonEncode(descriptionTEC.document.toDelta().toJson()) ,
      "zeroFourPrice": double.tryParse(zeroFourPriceTEC.text) ?? 0.00,
      "under14Price": double.tryParse(under14PriceTEC.text) ?? 0.00,
      "defaultPrice": double.tryParse(defaultPriceTEC.text) ?? 0.00,
      "over65Price": double.tryParse(over65PriceTEC.text) ?? 0.00,
      "zeroFourPointPrice": int.tryParse(zeroFourPointPriceTEC.text) ?? 0,
      "under14PointPrice": int.tryParse(under14PointPriceTEC.text) ?? 0,
      "defaultPointPrice": int.tryParse(defaultPointPriceTEC.text) ?? 0,
      "over65PointPrice": int.tryParse(over65PointPriceTEC.text) ?? 0,
      "qty": int.tryParse(qtyTEC.text) ?? 0,
      "qtyPerUser": int.tryParse(qtyPerUserTEC.text) ?? 0,
      "eventId": selectedEvent?.id,
    };
    ApiCallResponse apiCallResponse = await EventProductCalls.updateEventProduct(viewContext, params, eventProductId);
    setBusy(false);
  }
}
