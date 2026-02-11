import 'package:project_dsh/modules/events/modules/event_category/models/event_category.model.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';

import '../../../../store/models/store.model.dart';
import '../../../../store/modules/brand/models/brand.model.dart';
import '../../../../store/modules/location/models/location.model.dart';
import '../../../../store/modules/store_category/models/store_category.model.dart';
import '../../../models/event.model.dart';


class EventProduct extends BaseModel {
  String id;
  String name;
  String description;
  double zeroFourPrice;
  double under14Price;
  double defaultPrice;
  double over65Price;
  int zeroFourPointPrice;
  int under14PointPrice;
  int defaultPointPrice;
  int over65PointPrice;
  Event event;
  int qty;
  int qtyPerUser;


  @override
  String get modelIdentifier => "$name";

  EventProduct._internal({
    required this.id,
    required this.name,
    required this.description,
    required this.zeroFourPrice,
    required this.under14Price,
    required this.defaultPrice,
    required this.over65Price,
    required this.zeroFourPointPrice,
    required this.under14PointPrice,
    required this.defaultPointPrice,
    required this.over65PointPrice,
    required this.event,
    required this.qty,
    required this.qtyPerUser,
  });

  factory EventProduct({
    String id = "",
    String name = "",
    String description = "",
    double zeroFourPrice = 0.00,
    double under14Price = 0.00,
    double defaultPrice = 0.00,
    double over65Price = 0.00,
    int zeroFourPointPrice = 0,
    int under14PointPrice = 0,
    int defaultPointPrice = 0,
    int over65PointPrice = 0,
    int qty = 0,
    int qtyPerUser = 0,
    required Event event,

  }) {
    return EventProduct._internal(
      id: id,
      name: name,
      description: description,
      zeroFourPrice: zeroFourPrice,
      under14Price: under14Price,
      defaultPrice: defaultPrice,
      over65Price: over65Price,
      zeroFourPointPrice: zeroFourPointPrice,
      under14PointPrice: under14PointPrice,
      defaultPointPrice: defaultPointPrice,
      over65PointPrice: over65PointPrice,
      event: event,
      qty: qty,
      qtyPerUser: qtyPerUser,
    );
  }

  factory EventProduct.fromJson({
    required dynamic jsonObject,
  }) {
    return EventProduct(
      id: jsonObject["id"]?.toString() ?? "",
      name: jsonObject["name"]?.toString() ?? "",
      description: jsonObject["description"]?.toString() ?? "",
      zeroFourPrice: double.tryParse(jsonObject["zeroFourPrice"].toString()) ?? 0.00,
      under14Price: double.tryParse(jsonObject["under14Price"].toString()) ?? 0.00,
      defaultPrice: double.tryParse(jsonObject["defaultPrice"].toString()) ?? 0.00,
      over65Price: double.tryParse(jsonObject["over65Price"].toString()) ?? 0.00,
      zeroFourPointPrice: jsonObject["zeroFourPointPrice"] ?? 0,
      under14PointPrice: jsonObject["under14PointPrice"] ?? 0,
      defaultPointPrice: jsonObject["defaultPointPrice"] ?? 0,
      over65PointPrice: jsonObject["over65PointPrice"] ?? 0,
      qty: jsonObject["qty"] ?? 0,
      qtyPerUser: jsonObject["qtyPerUser"] ?? 0,
      event: jsonObject["event"] != null ? Event.fromJson(jsonObject: jsonObject["event"]) : Event(id: "", title: "", eventCategory: EventCategory(), store: Store(brand: Brand(), storeCategory: StoreCategory()), location: Location(store: Store(brand: Brand(), storeCategory: StoreCategory())), additionalPurchaseStore: Store(brand: Brand(), storeCategory: StoreCategory())),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'zeroFourPrice': zeroFourPrice,
      'under14Price': under14Price,
      'defaultPrice': defaultPrice,
      'over65Price': over65Price,
      'zeroFourPointPrice': zeroFourPointPrice,
      'under14PointPrice': under14PointPrice,
      'defaultPointPrice': defaultPointPrice,
      'over65PointPrice': over65PointPrice,
      'event': event.toMap(),
      'qty': qty,
      'qtyPerUser': qtyPerUser
    };
  }
}
