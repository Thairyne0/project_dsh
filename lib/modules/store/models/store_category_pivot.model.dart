import 'package:project_dsh/modules/store/models/store.model.dart';
import 'package:project_dsh/modules/store/modules/brand/models/brand.model.dart';
import 'package:project_dsh/modules/store/modules/store_category/models/store_category.model.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';

class StoreCategoryPivot extends BaseModel {
  @override
  String get modelIdentifier => "$id";

  String id;
  String storeCategoryId;
  String storeId;
  Store store;
  StoreCategory storeCategory;




  StoreCategoryPivot._internal({
    required this.id,
    required this.storeCategoryId,
    required this.storeId,
    required this.store,
    required this.storeCategory,
  });

  factory StoreCategoryPivot({
    String id = "",
    String storeCategoryId = "",
    String storeId = "",
    required Store store,
    required StoreCategory storeCategory,
  }) {
    return StoreCategoryPivot._internal(
      id: id,
      storeCategoryId: storeCategoryId,
      storeId: storeId,
      store: store,
      storeCategory: storeCategory,
    );
  }

  factory StoreCategoryPivot.fromJson({
    required dynamic jsonObject,
  }) {
    return StoreCategoryPivot(
      id: jsonObject["id"]?.toString() ?? "",
      storeCategoryId: jsonObject["storeCategoryId"] ?? "",
      storeId: jsonObject["storeId"] ?? "",
      store: jsonObject["store"] != null ? Store.fromJson(jsonObject: jsonObject["store"]) : Store(brand: Brand(), storeCategory: StoreCategory()),
      storeCategory: jsonObject["storeCategory"] != null ? StoreCategory.fromJson(jsonObject: jsonObject["storeCategory"]) : StoreCategory(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeCategoryId': storeCategoryId,
      'storeId': storeId,
      'store': store.toMap(),
      'storeCategory': storeCategory.toMap(),
    };
  }
}
