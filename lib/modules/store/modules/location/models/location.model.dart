import 'package:intl/intl.dart';
import 'package:project_dsh/modules/store/modules/brand/models/brand.model.dart';
import 'package:project_dsh/modules/store/modules/store_category/models/store_category.model.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';

import '../../../../events/models/event.model.dart';
import '../../../models/store.model.dart';

class Location extends BaseModel {
  @override
  String get modelIdentifier => name;

  String id;
  String name;
  String civic;
  String poiId;
  Store store;
  DateTime startValidityAt;
  DateTime? endValidityAt;
  List<Event> events;
  double sq;

  Location._internal({
    required this.id,
    required this.name,
    required this.store,
    required this.civic,
    required this.events,
    required this.startValidityAt,
    this.endValidityAt,
    required this.poiId,
    required this.sq,

  });

  factory Location({
    String id = "",
    String poiId = "",
    String name = "",
    String civic = "",
    String description = "",
    DateTime? startValidityAt,
    DateTime? endValidityAt,
    double sq = 0.00,
    List<Event> events = const [],
    required Store store,

  }) {
    return Location._internal(
      id: id,
      poiId: poiId,
      sq: sq,
      name: name,
      civic: civic,
      events: [],
      store: store,
      startValidityAt: startValidityAt ?? DateTime.now(),
      endValidityAt: endValidityAt,

    );
  }
  String get startValidityAtDate => DateFormat('dd-MM-yyyy').format(startValidityAt);
  String get endValidityAtDate =>
      endValidityAt != null ? DateFormat('dd-MM-yyyy').format(endValidityAt!) : '-';
  factory Location.fromJson({
    required dynamic jsonObject,
  }) {
    return Location(
      id: jsonObject["id"]?.toString() ?? "",
      poiId: jsonObject["poiId"]?.toString() ?? "",
      name: jsonObject["name"] ?? "",
      civic: jsonObject["civic"] ?? "",
      events: (jsonObject["events"] as List<dynamic>?)?.map((jsonObject) => Event.fromJson(jsonObject: jsonObject)).toList() ?? [],
      store: jsonObject["store"] != null ? Store.fromJson(jsonObject: jsonObject["store"]) : Store(brand: Brand(), storeCategory: StoreCategory(),),
      startValidityAt: jsonObject["startValidityAt"] != null ? DateTime.parse(jsonObject["startValidityAt"]).toLocal() : DateTime.now(),
      endValidityAt: jsonObject["endValidityAt"] != null
          ? DateTime.parse(jsonObject["endValidityAt"]).toLocal()
          : null,
      sq: double.tryParse(jsonObject["sq"].toString()) ?? 0.00,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'poiId': poiId,
      'name': name,
      'civic': civic,
      'events': events.map((events) => events.toMap()).toList(),
      'startValidityAt': startValidityAt.toUtc().toIso8601String(),
      'endValidityAt': endValidityAt?.toUtc().toIso8601String(),
      'sq': sq,
    };
  }
}
