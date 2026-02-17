import 'package:flutter/cupertino.dart';
import 'package:project_dsh/ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/api_manager.util.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/models/upload_file.model.dart';
import '../../../constants/store_api_calls.constant.dart';
import '../../../models/store.model.dart';
import '../../../models/store_category_pivot.model.dart';
import '../constants/store_category_api_calls.constant.dart';
import '../models/store_category.model.dart';

class StoreCategoryViewModel extends CLBaseViewModel {
  late TextEditingController nameTEC = TextEditingController();
  late String storeCategoryId;
  late StoreCategory storeCategory;
  late Store store;
  CLMedia? imageFile;
  List<Store> selectedStores = [];


  PagedDataTableController<String, String, StoreCategory> storeCategoryTableController = PagedDataTableController<String, String, StoreCategory>();
  PagedDataTableController<String, String, StoreCategoryPivot> storeCategoryPivotTableController = PagedDataTableController<String, String, StoreCategoryPivot>();

  StoreCategoryViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    switch (viewModelType) {
      case VMType.list:
        break;
      case VMType.create:
        break;
      case VMType.edit:
        String storeCategoryId = extraParams;
        storeCategory = await getStoreCategory(storeCategoryId);
        nameTEC.text = storeCategory.name;
        break;
      case VMType.detail:
        String storeCategoryId = extraParams;
        storeCategory = await getStoreCategory(storeCategoryId);
        break;
      case VMType.other:
        String storeCategoryId = extraParams as String;
        storeCategory = await getStoreCategory(storeCategoryId);
        nameTEC.text = storeCategory.name;
        imageFile = CLMedia(fileUrl: storeCategory.imageUrl);
        break;
      default:
        break;
    }
    setBusy(false);
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

  Future<StoreCategory> getStoreCategory(storeCategoryId) async {
    late StoreCategory downloadedStoreCategory;
    ApiCallResponse apiCallResponse = await StoreCategoryCalls.getStoreCategory(viewContext, storeCategoryId);
    if (apiCallResponse.succeeded) {
      downloadedStoreCategory = StoreCategory.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedStoreCategory;
  }

  Future deleteStoreCategory(storeCategoryId) async {
    setBusy(true);
    await StoreCategoryCalls.deleteStoreCategory(viewContext, storeCategoryId);
    setBusy(false);
  }

  Future<(List<StoreCategoryPivot>, Pagination?)> getAllStoreCategoryPivot(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<StoreCategoryPivot> storeCategoryPivotArray = [];
    ApiCallResponse apiCallResponse = await StoreCategoryCalls.getAllStoreByStoreCategory(viewContext,storeCategory.id, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
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

  Future<(List<Store>, Pagination?)> getAllStoreByStoreCategory({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    searchBy.addAll({"storeCategoryPivots:none:storeCategoryId": storeCategory.id});
    late List<Store> storesByStoreCategoryArray = [];
    ApiCallResponse apiCallResponse =
    await StoreCalls.getAllStore(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final storesByStoreCategoryJsonArray = (apiCallResponse.jsonBody as List);
      for (var jsonObject in storesByStoreCategoryJsonArray) {
        storesByStoreCategoryArray.add(Store.fromJson(jsonObject: jsonObject));
      }
    }
    return (storesByStoreCategoryArray, apiCallResponse.pagination);
  }



  Future attachStoreToStoreCategory() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "storeCategoryId": storeCategory.id,
      "storeIds": selectedStores.map((store) => store.id).toList()
    };
    ApiCallResponse apiCallResponse = await StoreCategoryCalls.attachStoreToStoreCategory(viewContext, params);
    setBusy(false);
  }

  Future detachStoreFromStoreCategory(String storeCategoryPivotId) async {
    setBusy(true);
    ApiCallResponse apiCallResponse = await StoreCategoryCalls.detachStoreFromStoreCategory(viewContext, storeCategoryPivotId);
    setBusy(false);
  }

  Future createStoreCategory() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "name": nameTEC.text,
    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await StoreCategoryCalls.createStoreCategory(viewContext, params);
    setBusy(false);
  }

  Future updateStoreCategory(String storeCategoryId) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "name": nameTEC.text,
    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await StoreCategoryCalls.updateStoreCategory(viewContext, params, storeCategoryId);
    setBusy(false);
  }
}
