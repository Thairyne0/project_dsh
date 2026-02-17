import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_dsh/modules/users/models/store_employee.dart';
import 'package:project_dsh/ui/widgets/cl_media_viewer.widget.dart';
import '../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../utils/api_manager.util.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/models/pageaction.model.dart';
import '../../users/models/user.model.dart';
import '../../users/constants/users_api_calls.costant.dart';
import '../models/opening_closing_store.model.dart';
import '../models/store_category_pivot.model.dart';
import '../modules/brand/constants/brand_api_calls.costant.dart';
import '../modules/location/constants/location_api_calls.constant.dart';
import '../modules/location/models/location.model.dart';
import '../modules/promo/constants/promo_api_calls.constant.dart';
import '../modules/promo/models/promo.model.dart';
import '../modules/brand/models/brand.model.dart';
import '../constants/store_api_calls.constant.dart';
import '../models/store.model.dart';
import '../modules/store_category/constants/store_category_api_calls.constant.dart';
import '../modules/store_category/models/store_category.model.dart';
import '../modules/store_report/constants/store_report_api_calls.constant.dart';
import '../modules/store_report/models/store_report.model.dart';

class StoreViewModel extends CLBaseViewModel {
  late TextEditingController nameTEC = TextEditingController();
  late TextEditingController referentTEC = TextEditingController();
  late TextEditingController emailTEC = TextEditingController();
  late TextEditingController pecTEC = TextEditingController();
  late TextEditingController phoneTEC = TextEditingController();
  late TextEditingController pivaTEC = TextEditingController();
  late TextEditingController legalAddressTEC = TextEditingController();
  late Store store;
  late StoreEmployee storeEmployee;
  Brand? selectedBrand;
  StoreCategory? selectedStoreCategory;
  List<StoreCategory> selectedStoreCategories = [];
  List<User> selectedUser = [];
  CLMedia? imageFile;
  List<OpeningClosingStore> weeklySchedule = [];
  PagedDataTableController<String, String, Store> storeTableController = PagedDataTableController<String, String, Store>();
  PagedDataTableController<String, String, Location> locationTableController = PagedDataTableController<String, String, Location>();
  PagedDataTableController<String, String, Promo> promoTableController = PagedDataTableController<String, String, Promo>();
  PagedDataTableController<String, String, StoreCategory> storeCategoryTableController = PagedDataTableController<String, String, StoreCategory>();
  PagedDataTableController<String, String, StoreCategoryPivot> storeCategoryPivotTableController =
      PagedDataTableController<String, String, StoreCategoryPivot>();
  PagedDataTableController<String, String, StoreEmployee> storeEmployeeTableController = PagedDataTableController<String, String, StoreEmployee>();
  PagedDataTableController<String, String, StoreReport> storeReportTableController = PagedDataTableController<String, String, StoreReport>();

  StoreViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    await super.initialize(pageActions: pageActions);
    switch (viewModelType) {
      case VMType.list:
        break;
      case VMType.create:
        weeklySchedule = List.generate(7, (index) {
          return OpeningClosingStore();
        });
        break;
      case VMType.edit:
        String storeId = extraParams as String;
        store = await getStore(storeId);
        nameTEC.text = store.name;
        emailTEC.text = store.email;
        pecTEC.text = store.pec;
        phoneTEC.text = store.phone;
        pivaTEC.text = store.piva;
        legalAddressTEC.text = store.legalAddress;
        selectedBrand = store.brand;
        weeklySchedule = store.weeklySchedule.isNotEmpty
            ? store.weeklySchedule
            : List.generate(7, (index) {
                return OpeningClosingStore();
              });
        imageFile = CLMedia(fileUrl: store.imageUrl);
        break;
      case VMType.detail:
        String storeId = extraParams as String;
        store = await getStore(storeId);
        break;
      case VMType.other:
        String storeId = extraParams as String;
        store = await getStore(storeId);
        nameTEC.text = store.name;
        break;
      default:
        break;
    }
    setBusy(false);
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

  Future<(List<Location>, Pagination?)> getAllLocationByStore({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    searchBy.addAll({"storeId": store.id});
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

  Future<(List<StoreCategory>, Pagination?)> getAllStoreCategory(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<StoreCategory> storeCategoryArray = [];
    ApiCallResponse apiCallResponse =
        await StoreCategoryCalls.getAllStoreCategory(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final storeCategoriesJsonObject = (apiCallResponse.jsonBody as List);
      storeCategoriesJsonObject.asMap().forEach(
        (index, jsonObject) {
          storeCategoryArray.add(StoreCategory.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (storeCategoryArray, apiCallResponse.pagination);
  }

  Future<(List<StoreCategoryPivot>, Pagination?)> getAllStoreCategoryPivot(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<StoreCategoryPivot> storeCategoryPivotArray = [];
    ApiCallResponse apiCallResponse =
        await StoreCalls.getAllStoreCategoryByStore(viewContext, store.id, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final storeCategoryPivotsJsonObject = (apiCallResponse.jsonBody as List);
      storeCategoryPivotsJsonObject.asMap().forEach(
        (index, jsonObject) {
          storeCategoryPivotArray.add(StoreCategoryPivot.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (storeCategoryPivotArray, apiCallResponse.pagination);
  }

  Future<(List<StoreCategory>, Pagination?)> getAllStoreCategoryByStore(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    searchBy.addAll({"storeCategoryPivots:none:storeId": store.id});
    late List<StoreCategory> storeCategoriesByStoreArray = [];
    ApiCallResponse apiCallResponse =
        await StoreCategoryCalls.getAllStoreCategory(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final storeCategoriesByStoreJsonArray = (apiCallResponse.jsonBody as List);
      for (var jsonObject in storeCategoriesByStoreJsonArray) {
        storeCategoriesByStoreArray.add(StoreCategory.fromJson(jsonObject: jsonObject));
      }
    }
    return (storeCategoriesByStoreArray, apiCallResponse.pagination);
  }

  Future attachStoreToStoreCategory() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "storeId": store.id, "storeCategoryIds": selectedStoreCategories.map((storeCategory) => storeCategory.id).toList()
    };
    ApiCallResponse apiCallResponse = await StoreCalls.attachStoreToStoreCategory(viewContext, params);
    setBusy(false);
  }

  Future detachStoreFromStoreCategory(String storeCategoryPivotId) async {
    setBusy(true);
    ApiCallResponse apiCallResponse = await StoreCalls.detachStoreFromStoreCategory(viewContext, storeCategoryPivotId);
    setBusy(false);
  }

  Future<(List<StoreReport>, Pagination?)> getAllStoreReportByStore(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    searchBy.addAll({"storeId": store.id});
    late List<StoreReport> storeReportArray = [];
    ApiCallResponse apiCallResponse =
    await StoreReportCalls.getAllStoreReportByStore(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
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

  Future<(List<StoreEmployee>, Pagination?)> getAllStoreEmployeesByStore({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<StoreEmployee> storeEmployeesArray = [];
    searchBy ??= {};
    searchBy.addAll({"storeId": store.id});
    ApiCallResponse apiCallResponse =
        await StoreCalls.getAllStoreEmployeesByStore(viewContext,store.id, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final storeEmployeesJsonObject = (apiCallResponse.jsonBody as List);
      storeEmployeesJsonObject.asMap().forEach(
        (index, jsonObject) {
          storeEmployeesArray.add(StoreEmployee.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (storeEmployeesArray, apiCallResponse.pagination);
  }

  Future<(List<Promo>, Pagination?)> getAllPromoByStore({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    searchBy.addAll({"storeId": store.id});
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

  Future<(List<Brand>, Pagination?)> getAllBrand({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<Brand> brandArray = [];
    ApiCallResponse apiCallResponse = await BrandCalls.getAllBrands(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final brandsJsonObject = (apiCallResponse.jsonBody as List);
      brandsJsonObject.asMap().forEach(
        (index, jsonObject) {
          brandArray.add(Brand.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (brandArray, apiCallResponse.pagination);
  }

  Future<(List<User>, Pagination?)> getAllUser({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<User> userArray = [];
    ApiCallResponse apiCallResponse = await UserCalls.getAllUser(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final usersJsonObject = (apiCallResponse.jsonBody as List);
      usersJsonObject.asMap().forEach(
        (index, jsonObject) {
          userArray.add(User.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (userArray, apiCallResponse.pagination);
  }

  Future<Store> getStore(storeId) async {
    late Store downloadedStore;
    ApiCallResponse apiCallResponse = await StoreCalls.getStore(viewContext, storeId);
    if (apiCallResponse.succeeded) {
      downloadedStore = Store.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedStore;
  }

  Future deleteStore(storeId) async {
    setBusy(true);
    await StoreCalls.deleteStore(viewContext, storeId);
    setBusy(false);
  }

  Future deleteLocation(locationId) async {
    setBusy(true);
    await LocationCalls.deleteLocation(viewContext, locationId);
    setBusy(false);
  }

  Future createStore() async {
    setBusy(true);
    Map<String, Map<String, String>> scheduleData = {};
    for (int i = 0; i < weeklySchedule.length; i++) {
      scheduleData[i.toString()] = {
        "morningOpening": weeklySchedule[i].morningOpeningTEC.text,
        "morningClosing": weeklySchedule[i].morningClosingTEC.text,
        "eveningOpening": weeklySchedule[i].eveningOpeningTEC.text,
        "eveningClosing": weeklySchedule[i].eveningClosingTEC.text,
      };
    }
    Map<String, dynamic> params = {
      "name": nameTEC.text,
      "email": emailTEC.text.isEmpty ? " " : emailTEC.text,
      "pec": pecTEC.text.isEmpty ? " " : pecTEC.text,
      "legalAddress": legalAddressTEC.text,
      "phone": phoneTEC.text.isEmpty ? " " : phoneTEC.text,
      "piva": pivaTEC.text,
      "brandId": selectedBrand?.id,
      "weeklySchedule": jsonEncode(scheduleData),
    };
    /*if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }*/
    ApiCallResponse apiCallResponse = await StoreCalls.createStore(viewContext, params);
    setBusy(false);
  }

  Future updateStore(String storeId) async {
    setBusy(true);
    Map<String, Map<String, String>> scheduleData = {};
    for (int i = 0; i < weeklySchedule.length; i++) {
      scheduleData[i.toString()] = {
        "morningOpening": weeklySchedule[i].morningOpeningTEC.text,
        "morningClosing": weeklySchedule[i].morningClosingTEC.text,
        "eveningOpening": weeklySchedule[i].eveningOpeningTEC.text,
        "eveningClosing": weeklySchedule[i].eveningClosingTEC.text,
      };
    }
    Map<String, dynamic> params = {
      "name": nameTEC.text,
      "email": emailTEC.text,
      "pec": pecTEC.text,
      "legalAddress": legalAddressTEC.text,
      "phone": phoneTEC.text,
      "piva": pivaTEC.text,
      "brandId": selectedBrand?.id,
      "weeklySchedule": jsonEncode(scheduleData),
    };
    /* if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }*/
    ApiCallResponse apiCallResponse = await StoreCalls.updateStore(viewContext, params, storeId);
    setBusy(false);
  }

  Future attachUserStore() async {
    setBusy(true);
    Map<String, dynamic> params = {'userIds': selectedUser.map((user) => user.id).toList(), 'storeId': store.id};
    ApiCallResponse apiCallResponse = await StoreCalls.attachStoreEmployee(viewContext, params);
    setBusy(false);
  }

  Future detachUserStore(String storeEmployeeId) async {
    setBusy(true);
    ApiCallResponse apiCallResponse = await StoreCalls.detachStoreEmployee(viewContext, storeEmployeeId);
    setBusy(false);
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
}
