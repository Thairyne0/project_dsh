import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import 'package:project_dsh/modules/events/models/user_eventProduct.model.dart';
import 'package:project_dsh/ui/widgets/cl_media_viewer.widget.dart';
import '../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../utils/api_manager.util.dart';
import '../../../../utils/base.viewmodel.dart';
import '../../../../utils/models/pageaction.model.dart';
import '../../../ui/widgets/alertmanager/alert_manager.dart';
import '../../../utils/models/upload_file.model.dart';
import '../../store/constants/store_api_calls.constant.dart';
import '../../store/modules/brand/models/brand.model.dart';
import '../../store/modules/location/constants/location_api_calls.constant.dart';
import '../../store/modules/location/models/location.model.dart';
import '../../store/modules/store_category/models/store_category.model.dart';
import '../../users/models/user.model.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../constants/event_api_calls.constant.dart';
import '../models/event.model.dart';
import '../modules/event_category/constants/event_category_api_calls.constant.dart';
import '../modules/event_category/models/event_category.model.dart';
import '../modules/event_product/costants/event_product_api_calls.costant.dart';
import '../modules/event_product/models/event_product.model.dart';
import '../../store/models/store.model.dart';

class EventViewModel extends CLBaseViewModel {
  late TextEditingController titleTEC = TextEditingController();
  late TextEditingController additionalPurchaseDescriptionTEC = TextEditingController();
  QuillController ruleTextTEC = QuillController.basic();
  quill.Document? _ruleTextDoc;

  quill.Document? get ruleTextDoc => _ruleTextDoc;
  QuillController descriptionTEC = QuillController.basic();
  quill.Document? _descriptionDoc;

  quill.Document? get descriptionDoc => _descriptionDoc;
  late TextEditingController startingAtTEC = TextEditingController();
  late TextEditingController endingAtTEC = TextEditingController();
  late TextEditingController pointsRewardTEC = TextEditingController();
  late EventCategory selectedEventCategory;
  late Location selectedLocation;
  late Store selectedStore;
  late Store selectedAdditionalPurchaseStore = Store(brand: Brand(), storeCategory: StoreCategory());
  late String eventId;
  late Event event;
  late EventProduct eventProduct;
  late User user;
  CLMedia? imageFile;
  DateTime? selectedStartingAtDate;
  DateTime? selectedEndingAtDate;
  bool isBothMoneyAndPoints = false;
  bool isBuyable = false;
  bool isHighlighted = false;
  bool additionalPurchase = false;
  late AuthState authState;
  CLMedia? bulkMediaFile;
  PagedDataTableController<String, String, Event> eventTableController = PagedDataTableController<String, String, Event>();
  PagedDataTableController<String, String, EventProduct> eventProductTableController = PagedDataTableController<String, String, EventProduct>();
  PagedDataTableController<String, String, UserEventProduct> userEventProductTableController = PagedDataTableController<String, String, UserEventProduct>();

  EventViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    authState = Provider.of<AuthState>(viewContext, listen: false);
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    switch (viewModelType) {
      case VMType.list:
        break;
      case VMType.create:
        break;
      case VMType.edit:
        String eventId = extraParams as String;
        event = await getEvent(eventId);
        titleTEC.text = event.title;
        descriptionTEC.document = Document.fromJson(jsonDecode(event.description));
        ruleTextTEC.document = Document.fromJson(jsonDecode(event.ruleText));
        additionalPurchaseDescriptionTEC.text = event.additionalPurchaseDescription;
        startingAtTEC.text = event.startingAtDate;
        endingAtTEC.text = event.endingAtDate;
        selectedStartingAtDate = event.startingAt;
        selectedEndingAtDate = event.endingAt;
        selectedEventCategory = event.eventCategory;
        selectedLocation = event.location;
        selectedStore = event.store;
        selectedAdditionalPurchaseStore = event.additionalPurchaseStore;
        isBothMoneyAndPoints = event.isBothMoneyAndPoints;
        additionalPurchase = event.additionalPurchase;
        isBuyable = event.isBuyable;
        imageFile = CLMedia(fileUrl: event.imageUrl);
        pointsRewardTEC.text = event.pointsReward.toString();
        isHighlighted = event.isHighlighted;
        break;
      case VMType.detail:
        String eventId = extraParams as String;
        event = await getEvent(eventId);
        _ruleTextDoc = parseQuillFromRaw(event.ruleText);
        _descriptionDoc = parseQuillFromRaw(event.description);
        break;
      case VMType.other:
        String eventId = extraParams as String;
        event = await getEvent(eventId);
        titleTEC.text = event.title;
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

  Future<(List<Store>, Pagination?)> getAllStore({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    late List<Store> storeArray = [];
    ApiCallResponse apiCallResponse = await StoreCalls.getAllStore(
      viewContext,
      page: page,
      perPage: perPage,
      searchParams: searchBy,
      orderByParams: orderBy,
    );
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

  Future<(List<EventCategory>, Pagination?)> getAllEventCategory(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<EventCategory> eventCategoryArray = [];
    ApiCallResponse apiCallResponse =
    await EventCategoryCalls.getAllEventCategory(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final eventCategoriesJsonObject = (apiCallResponse.jsonBody as List);
      eventCategoriesJsonObject.asMap().forEach(
            (index, jsonObject) {
          eventCategoryArray.add(EventCategory.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (eventCategoryArray, apiCallResponse.pagination);
  }

  Future<(List<Location>, Pagination?)> getAllLocation({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<Location> locationArray = [];
    ApiCallResponse apiCallResponse =
    await LocationCalls.getAllLocation(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final locationsJsonObject = (apiCallResponse.jsonBody as List);
      locationsJsonObject.asMap().forEach(
            (index, jsonObject) {
          locationArray.add(Location.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (locationArray, apiCallResponse.pagination);
  }

  Future<(List<EventProduct>, Pagination?)> getEventProductByEvent({
    int? page,
    int? perPage,
    Map<String, dynamic>? searchBy,
    Map<String, dynamic>? orderBy,
  }) async {
    searchBy ??= {};
    searchBy.addAll({"eventId": event.id});
    late List<EventProduct> eventProductArray = [];
    ApiCallResponse apiCallResponse = await EventProductCalls.getEventProductByEvent(
      viewContext,
      page: page,
      perPage: perPage,
      searchParams: searchBy,
      orderByParams: orderBy,
    );
    if (apiCallResponse.succeeded) {
      final eventProductsJsonObject = (apiCallResponse.jsonBody as List);
      eventProductsJsonObject.asMap().forEach((index, jsonObject) {
        eventProductArray.add(EventProduct.fromJson(jsonObject: jsonObject));
      });
    }
    return (eventProductArray, apiCallResponse.pagination);
  }

  Future<(List<UserEventProduct>, Pagination?)> getAllUserEventProducts(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<UserEventProduct> array = [];
    ApiCallResponse apiCallResponse =
    await EventProductCalls.getAllUserEventProducts(viewContext, event.id, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final jsonObject = (apiCallResponse.jsonBody as List);
      jsonObject.asMap().forEach(
            (index, jsonObject) {
          array.add(UserEventProduct.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (array, apiCallResponse.pagination);
  }

  Future<Event> getEvent(eventId) async {
    late Event downloadEvent;
    ApiCallResponse apiCallResponse = await EventCalls.getEvent(viewContext, eventId);
    if (apiCallResponse.succeeded) {
      downloadEvent = Event.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadEvent;
  }

  Future deleteEvent(eventId) async {
    setBusy(true);
    await EventCalls.deleteEvent(viewContext, eventId);
    setBusy(false);
  }

  Future createEvent() async {
    setBusy(true);
    if (imageFile == null) {
      AlertManager.showDanger("Errore", "Non hai inserito l'immagine");
      return;
    }
    Map<String, dynamic> params = {
      "title": titleTEC.text,
      "description": jsonEncode(descriptionTEC.document.toDelta().toJson()),
      "ruleText": jsonEncode(ruleTextTEC.document.toDelta().toJson()),
      "eventCategoryId": selectedEventCategory.id,
      "locationId": selectedLocation.id,
      "storeId": selectedStore.id,
      'startingAt': selectedStartingAtDate?.toUtc().toIso8601String(),
      'endingAt': selectedEndingAtDate?.toUtc().toIso8601String(),
      "isBothMoneyAndPoints": isBothMoneyAndPoints,
      "isBuyable": isBuyable,
      "additionalPurchase": additionalPurchase,
      "additionalPurchaseDescription": additionalPurchaseDescriptionTEC.text,
      "pointsReward": int.tryParse(pointsRewardTEC.text) ?? 0,
      "isHighlighted": isHighlighted,
    };
    if (selectedAdditionalPurchaseStore.id.isNotEmpty) {
      params.addAll({"additionalPurchaseStoreId": selectedAdditionalPurchaseStore.id});
    }
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await EventCalls.createEvent(viewContext, params);
    setBusy(false);
  }

  Future updateEvent(String eventId, {int? newStatus}) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "title": titleTEC.text,
      "description": jsonEncode(descriptionTEC.document.toDelta().toJson()),
      "ruleText": jsonEncode(ruleTextTEC.document.toDelta().toJson()),
      "eventCategoryId": selectedEventCategory.id,
      "locationId": selectedLocation.id,
      "storeId": selectedStore.id,
      'startingAt': selectedStartingAtDate?.toUtc().toIso8601String(),
      'endingAt': selectedEndingAtDate?.toUtc().toIso8601String(),
      "isBothMoneyAndPoints": isBothMoneyAndPoints,
      "isBuyable": isBuyable,
      "additionalPurchase": additionalPurchase,
      "additionalPurchaseDescription": additionalPurchaseDescriptionTEC.text,
      "pointsReward": int.tryParse(pointsRewardTEC.text) ?? 0,
      "isHighlighted": isHighlighted,
    };
    if (selectedAdditionalPurchaseStore.id.isNotEmpty) {
      params.addAll({"additionalPurchaseStoreId": selectedAdditionalPurchaseStore.id});
    }
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await EventCalls.updateEvent(viewContext, params, eventId);
    setBusy(false);
  }

  void setIsBothMoneyAndPoints(bool newValue) {
    isBothMoneyAndPoints = newValue;
    notifyListeners();
  }

  Future<void> updateEventStatus(String eventId, int newStatus) async {
    setBusy(true);
    try {
      Map<String, dynamic> params = {
        "status": newStatus,
      };
      ApiCallResponse apiCallResponse = await EventCalls.updateEvent(viewContext, params, eventId);
    } catch (e) {
      print("Errore durante l'aggiornamento dello stato: $e");
    } finally {
      setBusy(false);
    }
  }

  Future bulkUploadUserEventProductMedia(String eventId) async {
    if (bulkMediaFile != null) {
      Map<String, dynamic> params = {"archive": FFUploadedFile(clMedia: bulkMediaFile!)};
      await EventCalls.bulkUploadUserEventProductMedia(viewContext, params, eventId);
      bulkMediaFile = null;
    } else {
      AlertManager.showDanger("Errore", "Nessun file caricato");
    }
  }

  void setIsHighlighted(bool newValue) {
    isHighlighted = newValue;
    notifyListeners();
  }
}
