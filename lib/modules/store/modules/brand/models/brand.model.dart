import 'package:project_dsh/utils/models/custom_model.model.dart';
import '../../../models/store.model.dart';

class Brand extends BaseModel {
  @override
  String get modelIdentifier => "$name";

  String id;
  String name;
  String description;
  String imageUrl;
  List<Store> stores;

  Brand._internal({
    required this.id,
    required this.name,
    required this.description,
    required this.stores,
    required this.imageUrl,
  });

  factory Brand({
    String id = "",
    String name = "",
    String description = "",
    String imageUrl = "",
    List<Store> stores = const [],
  }) {
    return Brand._internal(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      stores: stores,
    );
  }

  factory Brand.fromJson({
    required dynamic jsonObject,
  }) {
    return Brand(
      id: jsonObject["id"]?.toString() ?? "",
      name: jsonObject["name"] ?? "",
      description: jsonObject["description"] ?? "",
      imageUrl: jsonObject["imageUrl"] ?? "",
      stores: (jsonObject["stores"] as List<dynamic>?)?.map((jsonObject) => Store.fromJson(jsonObject: jsonObject)).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'stores': stores.map((stores) => stores.toMap()).toList(),
    };
  }
}
