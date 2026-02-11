import '../../../utils/models/custom_model.model.dart';
import '../../users/models/user.model.dart';
import '../modules/event_product/models/event_product.model.dart';

class UserEventProduct extends BaseModel {
  String id;
  User user;
  String userId;
  String? firstName;
  String? lastName;
  EventProduct eventProduct;
  String eventProductId;
  AgeRange ageRange;
  bool policyAcceptance;
  String code;
  bool isPierluigi;
  int? progressive;
  List<String> mediaUrls;

  String get modelIdentifier => id;

  UserEventProduct({
    required this.id,
    required this.user,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.eventProduct,
    required this.eventProductId,
    required this.ageRange,
    required this.policyAcceptance,
    required this.code,
    required this.isPierluigi,
    required this.progressive,
    required this.mediaUrls,
  });

  factory UserEventProduct.fromJson({
    required dynamic jsonObject,
  }) {
    return UserEventProduct(
      id: jsonObject['id'],
      user: User.fromJson(jsonObject: jsonObject['user']),
      userId: jsonObject['userId'],
      firstName: jsonObject['firstName'] ?? '',
      progressive: jsonObject["progressive"],
      lastName: jsonObject['lastName'] ?? '',
      eventProduct: EventProduct.fromJson(jsonObject: jsonObject['eventProduct']),
      eventProductId: jsonObject['eventProductId'],
      ageRange: AgeRange.fromValue(jsonObject['ageRange']),
      policyAcceptance: jsonObject['policyAcceptance'],
      isPierluigi: jsonObject['isPierluigi'],
      code: jsonObject['code'],
      mediaUrls: List<String>.from(jsonObject["mediaUrls"] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> useMap = <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'eventProduct': eventProduct.toMap(),
      'eventProductId': eventProductId,
      'ageRange': ageRange,
      'progressive': progressive,
      'policyAcceptance': policyAcceptance,
      'isPierluigi': isPierluigi,
      'code': code,
      'mediaUrls': mediaUrls,
    };
    return useMap;
  }
}

enum AgeRange {
  range0_4(0, "0-4 anni"),
  under14(1, "Under 14"),
  normal(2, "Default"),
  over65(3, "Over 65");

  final int value;
  final String label;

  const AgeRange(this.value, this.label);

  static AgeRange fromValue(int value) {
    return AgeRange.values.firstWhere(
      (ageRange) => ageRange.value == value,
      orElse: () => throw ArgumentError("N/A: $value"),
    );
  }
}
