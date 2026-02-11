import 'package:intl/intl.dart';
import 'package:project_dsh/modules/users/modules/role_permission/models/user_permission.model.dart';
import 'package:project_dsh/utils/models/state.model.dart';
import 'package:project_dsh/modules/users/models/user_data.model.dart';
import '../modules/role_permission/models/role.model.dart';
import '../../../utils/models/city.model.dart';
import '../../../utils/models/country.model.dart';
import '../../../utils/models/custom_model.model.dart';
import '../../../utils/models/province.model.dart';

class User extends BaseModel {
  @override
  String get modelIdentifier => "${userData.firstName} ${userData.lastName}";
  String get formattedCreatedAt => DateFormat('dd/MM/yyyy HH:mm').format(createdAt!);

  String id;
  String accessToken;
  String email;
  UserData userData;
  Role role;
  int pointsAmount;
  List<UserPermission> userPermissions;
  DateTime? createdAt;
  String? phone;
  bool? photoPolicyAcceptance;
  bool? marketingPolicyAcceptance;
  bool? newsletterPolicyAcceptance;
  bool? generalPolicyAcceptance;
  DateTime? photoPolicyAcceptedAt;
  DateTime? marketingPolicyAcceptedAt;
  DateTime? generalPolicyAcceptedAt;
  DateTime? newsPolicyAcceptedAt;

  User._internal(
      {required this.id,
      required this.accessToken,
      required this.email,
        required this.pointsAmount,
        required this.userData,
      required this.role,
      required this.userPermissions,
        this.phone,
      this.createdAt,
      this.photoPolicyAcceptance,
      this.marketingPolicyAcceptance,
      this.newsletterPolicyAcceptance,
      this.generalPolicyAcceptance,
      this.photoPolicyAcceptedAt,
      this.marketingPolicyAcceptedAt,
      this.newsPolicyAcceptedAt,
      this.generalPolicyAcceptedAt});

  factory User({
    String id = "",
    String accessToken = "",
    String email = "",
    int pointsAmount = 0,
    required UserData userData,
    required Role role,
    List<UserPermission> userPermissions = const [],
    DateTime? createdAt,
    String? phone,
    bool? photoPolicyAcceptance,
    bool? marketingPolicyAcceptance,
    bool? newsletterPolicyAcceptance,
    bool? generalPolicyAcceptance,
    DateTime? photoPolicyAcceptedAt,
    DateTime? newsPolicyAcceptedAt,
    DateTime? marketingPolicyAcceptedAt,
    DateTime? generalPolicyAcceptedAt,
  }) {
    return User._internal(
        id: id,
        accessToken: accessToken,
        email: email,
        pointsAmount: pointsAmount,
        userData: userData,
        role: role,
        userPermissions: userPermissions,
        phone: phone,
        createdAt: createdAt,
        photoPolicyAcceptance: photoPolicyAcceptance,
        marketingPolicyAcceptance: marketingPolicyAcceptance,
        newsletterPolicyAcceptance: newsletterPolicyAcceptance,
        generalPolicyAcceptance: generalPolicyAcceptance,
        photoPolicyAcceptedAt: photoPolicyAcceptedAt,
        newsPolicyAcceptedAt: newsPolicyAcceptedAt,
        marketingPolicyAcceptedAt: marketingPolicyAcceptedAt,
        generalPolicyAcceptedAt: generalPolicyAcceptedAt);
  }

  factory User.fromJson({
    required dynamic jsonObject,
  }) {
    return User(
      id: jsonObject["id"]?.toString() ?? "",
      accessToken: jsonObject["accessToken"] ?? "",
      email: jsonObject["email"] ?? "",
      phone: jsonObject["phone"] ?? "",
      pointsAmount: jsonObject['pointsAmount'] ?? 0,
      userData: jsonObject['userData'] != null ? UserData.fromJson(jsonObject: jsonObject['userData']) : UserData(id: "", firstName: "", lastName: "", gender: "", cityOfResidence: City(province: Province(state: State(country: Country())))),
      role: jsonObject['role'] != null ? Role.fromJson(jsonObject: jsonObject['role']) : Role(),
      userPermissions: (jsonObject["userPermissions"] as List<dynamic>?)?.map((jsonObject) => UserPermission.fromJson(jsonObject: jsonObject)).toList() ?? [],
      createdAt: jsonObject["createdAt"] != null ? DateTime.parse(jsonObject["createdAt"]) : null,
      photoPolicyAcceptance: jsonObject["photoPolicyAcceptance"],
      marketingPolicyAcceptance: jsonObject["marketingPolicyAcceptance"],
      newsletterPolicyAcceptance: jsonObject["newsletterPolicyAcceptance"],
      generalPolicyAcceptance: jsonObject["generalPolicyAcceptance"],
      photoPolicyAcceptedAt: jsonObject["photoPolicyAcceptedAt"] != null ? DateTime.parse(jsonObject["photoPolicyAcceptedAt"]) : null,
      newsPolicyAcceptedAt: jsonObject["newsPolicyAcceptedAt"] != null ? DateTime.parse(jsonObject["newsPolicyAcceptedAt"]) : null,
      marketingPolicyAcceptedAt: jsonObject["marketingPolicyAcceptedAt"] != null ? DateTime.parse(jsonObject["marketingPolicyAcceptedAt"]) : null,
      generalPolicyAcceptedAt: jsonObject["generalPolicyAcceptedAt"] != null ? DateTime.parse(jsonObject["generalPolicyAcceptedAt"]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accessToken': accessToken,
      'email': email,
      'phone': phone,
      'pointsAmount': pointsAmount,
      'userData': userData.toMap(),
      'role': role.toMap(),
      'userPermissions': userPermissions.map((userPermission) => userPermission.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'photoPolicyAcceptance': photoPolicyAcceptance,
      'marketingPolicyAcceptance': marketingPolicyAcceptance,
      'newsletterPolicyAcceptance': newsletterPolicyAcceptance,
      'generalPolicyAcceptance': generalPolicyAcceptance,
      'photoPolicyAcceptedAt': photoPolicyAcceptedAt?.toIso8601String(),
      'newsPolicyAcceptedAt': newsPolicyAcceptedAt?.toIso8601String(),
      'marketingPolicyAcceptedAt': marketingPolicyAcceptedAt?.toIso8601String(),
      'generalPolicyAcceptedAt': generalPolicyAcceptedAt?.toIso8601String(),
    };
  }
}
