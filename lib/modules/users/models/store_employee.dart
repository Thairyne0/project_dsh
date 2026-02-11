import 'package:project_dsh/modules/store/models/store.model.dart';
import 'package:project_dsh/modules/store/modules/brand/models/brand.model.dart';
import 'package:project_dsh/modules/store/modules/store_category/models/store_category.model.dart';
import 'package:project_dsh/modules/users/models/user.model.dart';
import 'package:project_dsh/modules/users/models/user_data.model.dart';
import 'package:project_dsh/modules/users/modules/role_permission/models/role.model.dart';
import 'package:project_dsh/utils/models/city.model.dart';
import 'package:project_dsh/utils/models/country.model.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';
import 'package:project_dsh/utils/models/province.model.dart';
import 'package:project_dsh/utils/models/state.model.dart';

import '../../../utils/models/custom_model.model.dart';

class StoreEmployee extends BaseModel {
  @override
  String get modelIdentifier => "$id";

  String id;
  String userId;
  String storeId;
  User user;
  Store store;


  StoreEmployee._internal({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.user,
    required this.store,
  });

  factory StoreEmployee({
    String id = "",
    String userId = "",
    String storeId = "",
    required User user,
    required Store store,
  }) {
    return StoreEmployee._internal(
      id: id,
      userId: userId,
      storeId: storeId,
      user: user,
      store: store,
    );
  }

  factory StoreEmployee.fromJson({
    required dynamic jsonObject,
  }) {
    return StoreEmployee(
      id: jsonObject["id"]?.toString() ?? "",
      userId: jsonObject["userId"] ?? "",
      storeId: jsonObject["storeId"] ?? "",
      user: jsonObject["user"] != null ? User.fromJson(jsonObject: jsonObject["user"]) : User(userData: UserData(cityOfResidence: City(province: Province(state: State(country: Country())))), role: Role()),
      store: jsonObject["store"] != null ? Store.fromJson(jsonObject: jsonObject["store"]) : Store(brand: Brand(), storeCategory: StoreCategory(), locations: []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'storeId': storeId,
      'user': user.toMap(),
      'store': store.toMap(),
    };
  }
}
