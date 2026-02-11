import 'package:project_dsh/utils/models/custom_model.model.dart';

import '../../../models/store.model.dart';


class StoreCategory extends BaseModel {
  @override
  String get modelIdentifier => "$name";

  String id;
  String name;
  List<Store> stores;
  String imageUrl;


  StoreCategory._internal({
    required this.id,
    required this.name,
    required this.stores,
    required this.imageUrl,
  });

  factory StoreCategory({
    String id = "",
    String name = "",
    List<Store> stores = const [],
    String imageUrl = "",

  }) {
    return StoreCategory._internal(
      id: id,
      name: name,
      stores: stores,
      imageUrl: imageUrl,
    );
  }

  factory StoreCategory.fromJson({
    required dynamic jsonObject,
  }) {
    return StoreCategory(
      id: jsonObject["id"]?.toString() ?? "",
      name: jsonObject["name"] ?? "",
      stores: (jsonObject["stores"] as List<dynamic>?)?.map((stores) => Store.fromJson(jsonObject: stores)).toList() ?? [],
      imageUrl: jsonObject["imageUrl"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'stores': stores.map((stores) => stores.toMap()).toList(),
    };
  }
}
