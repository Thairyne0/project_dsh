import 'package:intl/intl.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';
import '../../store/models/store.model.dart';
import '../../store/modules/location/models/location.model.dart';
import '../modules/event_category/models/event_category.model.dart';
import '../modules/event_product/models/event_product.model.dart';



class Event extends BaseModel {
  String id;
  String title;
  String description;
  DateTime startingAt;
  DateTime endingAt;
  String imageUrl;
  String ruleText;
  EventCategory eventCategory;
  Location location;
  List<EventProduct> eventProducts;
  bool isBothMoneyAndPoints;
  bool isHighlighted;
  bool isBuyable;
  bool additionalPurchase;
  String additionalPurchaseDescription;
  Store store;
  Store additionalPurchaseStore;
  EventStatus status;
  int pointsReward;
  int? participantPeak;
  int? totalParticipant;
  DateTime? participantPeakDate;


  @override
  String get modelIdentifier => title;

  Event._internal({
    required this.id,
    required this.description,
    required this.ruleText,
    required this.title,
    required this.startingAt,
    required this.endingAt,
    required this.imageUrl,
    required this.eventCategory,
    required this.location,
    required this.additionalPurchaseDescription,
    required this.store,
    required this.additionalPurchaseStore,
    required this.eventProducts,
    required this.isBothMoneyAndPoints,
    required this.isHighlighted,
    required this.status,
    required this.isBuyable,
    required this.additionalPurchase,
    required this.pointsReward,
    required this.participantPeak,
    required this.totalParticipant,
     this.participantPeakDate,
  });

  factory Event({
    String id = "",
    String description = "",
    String ruleText = "",
    String title = "",
    String additionalPurchaseDescription = "",
    DateTime? startingAt,
    DateTime? endingAt,
    DateTime? participantPeakDate,
    String imageUrl = "",
    required EventCategory eventCategory,
    bool isBothMoneyAndPoints = false,
    bool isHighlighted = false,
    bool isBuyable = false,
    bool additionalPurchase = false,
    List<EventProduct> eventProducts = const [],
    EventStatus status = EventStatus.pending,
    int pointsReward = 0,
    int participantPeak = 0,
    int totalParticipant = 0,
    required Location location,
    required Store store,
    required Store additionalPurchaseStore,

  }) {
    return Event._internal(
      id: id,
      description: description,
      ruleText: ruleText,
      title: title,
      startingAt: startingAt ?? DateTime.now(),
      endingAt: endingAt ?? DateTime.now(),
      participantPeakDate: participantPeakDate,
      imageUrl: imageUrl,
      eventCategory: eventCategory,
      additionalPurchase: additionalPurchase,
      eventProducts: eventProducts,
      isBothMoneyAndPoints: isBothMoneyAndPoints,
      isHighlighted: isHighlighted,
      additionalPurchaseDescription: additionalPurchaseDescription,
      isBuyable: isBuyable,
      status: status,
      pointsReward: pointsReward,
      participantPeak: participantPeak,
      totalParticipant: totalParticipant,
      location: location,
      store: store,
      additionalPurchaseStore: additionalPurchaseStore,
    );
  }

  String get startingAtDate => DateFormat('dd-MM-yyyy HH:mm').format(startingAt);

  String get endingAtDate => DateFormat('dd-MM-yyyy HH:mm').format(endingAt);

  String get participantPeakDateFormatted {
    return participantPeakDate != null ? DateFormat('dd-MM-yyyy HH:mm').format(participantPeakDate!) : '';
  }
  factory Event.fromJson({
    required dynamic jsonObject,
  }) {
    return Event(
      id: jsonObject["id"] ?? "",
      description: jsonObject["description"] ?? "",
      ruleText: jsonObject["ruleText"] ?? "",
      additionalPurchaseDescription: jsonObject["additionalPurchaseDescription"] ?? "",
      title: jsonObject["title"] ?? "",
      startingAt: jsonObject["startingAt"] != null ? DateTime.parse(jsonObject["startingAt"]).toLocal() : DateTime.now(),
      endingAt: jsonObject["endingAt"] != null ? DateTime.parse(jsonObject["endingAt"]).toLocal() : DateTime.now(),
      participantPeakDate: jsonObject["participantPeakDate"] != null ? DateTime.parse(jsonObject["participantPeakDate"]).toLocal() : null,
      imageUrl: jsonObject["imageUrl"] ?? "",
      isBothMoneyAndPoints: bool.tryParse(jsonObject["isBothMoneyAndPoints"].toString()) ?? false,
      isHighlighted: bool.tryParse(jsonObject["isHighlighted"].toString()) ?? false,
      isBuyable: bool.tryParse(jsonObject["isBuyable"].toString()) ?? false,
      additionalPurchase: bool.tryParse(jsonObject["additionalPurchase"].toString()) ?? false,
      eventCategory: jsonObject["eventCategory"] != null ? EventCategory.fromJson(jsonObject: jsonObject["eventCategory"]) : EventCategory(id: "", name: ""),
      eventProducts: (jsonObject["eventProducts"] as List<dynamic>?)?.map((eventProducts) => EventProduct.fromJson(jsonObject: eventProducts)).toList() ?? [],
      status: EventStatusExtension.fromValue(jsonObject["status"] ?? 0),
      pointsReward: jsonObject["pointsReward"] ?? 0,
      participantPeak: jsonObject["participantPeak"] ?? 0,
      totalParticipant: jsonObject["totalParticipant"] ?? 0,
      location: jsonObject["location"] ,
      store: jsonObject["store"],
      additionalPurchaseStore: jsonObject["additionalPurchaseStore"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ruleText': ruleText,
      'additionalPurchaseDescription': additionalPurchaseDescription,
      'startingAt': startingAt.toUtc().toIso8601String(),
      'endingAt': endingAt.toUtc().toIso8601String(),
      'participantPeakDate': participantPeakDate?.toUtc().toIso8601String(),
      'imageUrl': imageUrl,
      'eventCategory': eventCategory.toMap(),
      'eventProducts': eventProducts.map((eventProducts) => eventProducts.toMap()).toList(),
      'isBothMoneyAndPoints': isBothMoneyAndPoints,
      'isHighlighted': isHighlighted,
      'isBuyable': isBuyable,
      'additionalPurchase': additionalPurchase,
      'status': status.value,
      'pointsReward': pointsReward,
      'participantPeak': participantPeak,
      'totalParticipant': totalParticipant,
    };
  }
}
enum EventStatus {
  pending,    // 0  "In attesa"
  approved,   // 1 "Approvato"
  notApproved // 2 "Non approvato"
}

extension EventStatusExtension on EventStatus {
  int get value {
    switch (this) {
      case EventStatus.pending:
        return 0;
      case EventStatus.approved:
        return 1;
      case EventStatus.notApproved:
        return 2;
    }
  }

  static EventStatus fromValue(int value) {
    switch (value) {
      case 0:
        return EventStatus.pending;
      case 1:
        return EventStatus.approved;
      case 2:
        return EventStatus.notApproved;
      default:
        throw ArgumentError('Valore non valido per EventStatus: $value');
    }
  }
}
