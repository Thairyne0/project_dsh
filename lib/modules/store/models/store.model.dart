import 'dart:convert';

import 'package:project_dsh/modules/store/models/opening_closing_store.model.dart';
import 'package:project_dsh/modules/store/modules/store_category/models/store_category.model.dart';
import 'package:project_dsh/modules/users/models/store_employee.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';
import '../modules/brand/models/brand.model.dart';
import '../modules/location/models/location.model.dart';
import '../modules/promo/models/promo.model.dart';

class Store extends BaseModel {
  String id;
  String name;
  String email;
  String pec;
  String phone;
  String legalAddress;
  String piva;
  Brand brand;
  String imageUrl;
  StoreCategory storeCategory;
  List<Promo> promos;
  List<Location> locations;
  List<StoreEmployee> storeEmployees;
  List<OpeningClosingStore> weeklySchedule;

  @override
  String get modelIdentifier => name;

  Store._internal({
    required this.id,
    required this.name,
    required this.email,
    required this.pec,
    required this.phone,
    required this.piva,
    required this.legalAddress,
    required this.brand,
    required this.locations,
    required this.promos,
    required this.storeEmployees,
    required this.imageUrl,
    required this.storeCategory,
    required this.weeklySchedule,
  });

  factory Store({
    String id = "",
    String name = "",
    String email = "",
    String pec = "",
    String phone = "",
    String piva = "",
    String legalAddress = "",
    required Brand brand,
    required StoreCategory storeCategory,
    String imageUrl = "",
    List<Promo> promos = const [],
    List<StoreEmployee> storeEmployees = const [],
    List<Location> locations = const [],
    List<OpeningClosingStore> weeklySchedule = const [],
  }) {
    return Store._internal(
      id: id,
      name: name,
      email: email,
      pec: pec,
      phone: phone,
      piva: piva,
      legalAddress: legalAddress,
      brand: brand,
      imageUrl: imageUrl,
      locations: locations,
      promos: promos,
      storeEmployees: storeEmployees,
      storeCategory: storeCategory,
      weeklySchedule: weeklySchedule,
    );
  }

  factory Store.fromJson({
    required dynamic jsonObject,
  }) {
    return Store(
        id: jsonObject["id"]?.toString() ?? "",
        name: jsonObject["name"]?.toString() ?? "",
        email: jsonObject["email"]?.toString() ?? "",
        pec: jsonObject["pec"]?.toString() ?? "",
        phone: jsonObject["phone"]?.toString() ?? "",
        piva: jsonObject["piva"]?.toString() ?? "",
        imageUrl: jsonObject["imageUrl"] ?? "",
        legalAddress: jsonObject["legalAddress"]?.toString() ?? "",
        brand: jsonObject["brand"] != null ? Brand.fromJson(jsonObject: jsonObject["brand"]) : Brand(id: "", name: "", description: "", stores: []),
        storeCategory: jsonObject["storeCategory"] != null ? StoreCategory.fromJson(jsonObject: jsonObject["storeCategory"]) : StoreCategory(),
        promos: (jsonObject["promos"] as List<dynamic>?)?.map((promos) => Promo.fromJson(jsonObject: promos)).toList() ?? [],
        locations: (jsonObject["locations"] as List<dynamic>?)?.map((locations) => Location.fromJson(jsonObject: locations)).toList() ?? [],
        storeEmployees: (jsonObject["storeEmployees"] as List<dynamic>?)?.map((storeEmployees) => StoreEmployee.fromJson(jsonObject: storeEmployees)).toList() ?? [],
        weeklySchedule: jsonObject["weeklySchedule"] != null ? jsonDecode(jsonObject["weeklySchedule"]).entries.map<OpeningClosingStore>((entry) {entry.value["id"] = entry.key.toString();return OpeningClosingStore.fromJson(jsonObject: entry.value);}).toList(): []);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'pec': pec,
      'phone': phone,
      'piva': piva,
      'legalAddress': legalAddress,
      'imageUrl': imageUrl,
      'brand': brand.toMap(),
      'storeCategory': storeCategory.toMap(),
      'promos': promos.map((promos) => promos.toMap()).toList(),
      'locations': locations.map((locations) => locations.toMap()).toList(),
      'storeEmployees': storeEmployees.map((storeEmployees) => storeEmployees.toMap()).toList(),
      'weeklySchedule': weeklySchedule.map((weeklySchedule) => weeklySchedule.toMap()).toList(),
    };
  }
}
