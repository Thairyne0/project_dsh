import 'package:intl/intl.dart';

import '../../../utils/models/city.model.dart';
import '../../../utils/models/country.model.dart';
import '../../../utils/models/custom_model.model.dart';
import '../../../utils/models/province.model.dart';
import '../../../utils/models/state.model.dart';

class UserData extends BaseModel {
  @override
  String get modelIdentifier => firstName;

  String id;
  String firstName;
  String fiscalCode;
  String lastName;
  String gender;
  String cap;
  DateTime birthDate;
  City cityOfResidence;
  String? imageUrl;

  UserData._internal(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.fiscalCode,
      required this.gender,
      required this.birthDate,
      required this.cityOfResidence,
      required this.cap,
      this.imageUrl});

  factory UserData({
    String id = "",
    String firstName = "",
    String lastName = "",
    String fiscalCode = "",
    String gender = "",
    String cap = "",
    String imageUrl = "",
    required City cityOfResidence,
    DateTime? birthDate,
  }) {
    return UserData._internal(
        id: id,
        firstName: firstName,
        lastName: lastName,
        fiscalCode: fiscalCode,
        gender: gender,
        cap: cap,
        cityOfResidence: cityOfResidence,
        birthDate: birthDate ?? DateTime.now(),
        imageUrl: imageUrl);
  }

  String get formattedDate => DateFormat('dd-MM-yyyy', 'it').format(birthDate);

  factory UserData.fromJson({
    required dynamic jsonObject,
  }) {
    return UserData(
        id: jsonObject["id"]?.toString() ?? "",
        firstName: jsonObject["firstName"] ?? "",
        lastName: jsonObject["lastName"] ?? "",
        fiscalCode: jsonObject["fiscalCode"] ?? "",
        cap: jsonObject["cap"] ?? "",
        gender: jsonObject["gender"] ?? "",
        cityOfResidence: jsonObject["cityOfResidence"] != null ? City.fromJson(jsonObject: jsonObject["cityOfResidence"]) : City(province: Province(state: State(country: Country()))),
        birthDate: jsonObject["birthDate"] != null ? DateTime.parse(jsonObject["birthDate"]).toLocal() : DateTime.now(),
        imageUrl: jsonObject["imageUrl"]?.toString() ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fiscalCode': fiscalCode,
      'gender': gender,
      'cap': cap,
      'cityOfResidence': cityOfResidence.toMap(),
      'birthDate': birthDate.toIso8601String(),
      'imageUrl': imageUrl
    };
  }
}
