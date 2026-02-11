import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/api_manager.util.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../events/constants/event_api_calls.constant.dart';
import '../../../../events/models/event.model.dart';
import '../../../constants/store_api_calls.constant.dart';
import '../../../models/store.model.dart';
import '../constants/location_api_calls.constant.dart';
import '../models/location.model.dart';

class LocationViewModel extends CLBaseViewModel {
  late TextEditingController nameTEC = TextEditingController();
  late TextEditingController storeNameTEC = TextEditingController();
  late TextEditingController civicTEC = TextEditingController();
  late TextEditingController poiIdTEC = TextEditingController();
  late TextEditingController startValidityAtTEC = TextEditingController();
  late TextEditingController endValidityAtTEC = TextEditingController();
  late TextEditingController sqTEC = TextEditingController();
  DateTime? selectedStartValidityAt;
  DateTime? selectedEndValidityAt;
  late String locationId;
  late Location location;
  late Store selectedStore;
  late Store store;
  PagedDataTableController<String, String, Location> locationTableController = PagedDataTableController<String, String, Location>();
  PagedDataTableController<String, String, Event> eventTableController = PagedDataTableController<String, String, Event>();

  LocationViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    switch (viewModelType) {
      case VMType.list:
        break;
      case VMType.create:
        String storeId = extraParams as String;
        store = await getStore(storeId);
        storeNameTEC.text = store.name;
        break;
      case VMType.edit:
        String locationId = extraParams as String;
        location = await getLocation(locationId);
        store = await getStore(location.store.id);
        storeNameTEC.text = store.name;
        nameTEC.text = location.name;
        civicTEC.text = location.civic;
        poiIdTEC.text = location.poiId;
        selectedStore = location.store;
        selectedStartValidityAt = location.startValidityAt;
        selectedEndValidityAt = location.endValidityAt;
        sqTEC.text = location.sq.toString();
        break;
      case VMType.detail:
        String locationId = extraParams as String;
        location = await getLocation(locationId);
        store = await getStore(location.store.id);
        break;
      case VMType.other:
        String storeId = extraParams as String;
        store = await getStore(storeId);
        storeNameTEC.text = store.name;
        break;
      default:
        break;
    }
    setBusy(false);
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
  Future<Store> getStore(storeId) async {
    late Store downloadedStore;
    ApiCallResponse apiCallResponse = await StoreCalls.getStore(viewContext, storeId);
    if (apiCallResponse.succeeded) {
      downloadedStore = Store.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedStore;
  }

  Future<(List<Store>, Pagination?)> getAllStore({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy, String? searchLetter,}) async {searchBy ??= {};
  late List<Store> storeArray = [];
  ApiCallResponse apiCallResponse = await StoreCalls.getAllStore(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy,);
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

  Future<(List<Event>, Pagination?)> getAllEventByLocation({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    searchBy.addAll({"locationId": location.id});
    late List<Event> eventsArray = [];
    ApiCallResponse apiCallResponse = await EventCalls.getAllEvent(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final eventsJsonObject = (apiCallResponse.jsonBody as List);
      eventsJsonObject.asMap().forEach(
        (index, jsonObject) {
          eventsArray.add(Event.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (eventsArray, apiCallResponse.pagination);
  }

  Future<Location> getLocation(locationId) async {
    late Location downloadedLocation;
    ApiCallResponse apiCallResponse = await LocationCalls.getLocation(viewContext, locationId);
    if (apiCallResponse.succeeded) {
      downloadedLocation = Location.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedLocation;
  }

  Future deleteLocation(locationId) async {
    setBusy(true);
    await LocationCalls.deleteLocation(viewContext, locationId);
    setBusy(false);
  }

  Future createLocation() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "name": nameTEC.text,
      "civic": civicTEC.text,
      "poiId": poiIdTEC.text,
      "storeId": store.id,
      'startValidityAt': selectedStartValidityAt?.toUtc().toIso8601String(),
      'endValidityAt': selectedEndValidityAt?.toUtc().toIso8601String(),
      "sq": double.tryParse(sqTEC.text) ?? 0.00,

    };
    ApiCallResponse apiCallResponse = await LocationCalls.createLocation(viewContext, params);
    setBusy(false);
  }

  Future updateLocation(String locationId) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "name": nameTEC.text,
      "civic": civicTEC.text,
      "poiId": poiIdTEC.text,
      "storeId": store.id,
      'startValidityAt': selectedStartValidityAt?.toUtc().toIso8601String(),
      'endValidityAt': selectedEndValidityAt?.toUtc().toIso8601String(),
      "sq": double.tryParse(sqTEC.text) ?? 0.00
    };
    ApiCallResponse apiCallResponse = await LocationCalls.updateLocation(viewContext, params, locationId);
    setBusy(false);
  }
}
