import 'package:project_dsh/utils/models/custom_model.model.dart';

class Device extends BaseModel {
  String id;
  String name;
  bool isEnabled;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  @override
  String get modelIdentifier => name;

  Device._internal({
    required this.id,
    required this.name,
    required this.isEnabled,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Device({
    String id = "",
    String name = "",
    bool isEnabled = false,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Device._internal(
      id: id,
      name: name,
      isEnabled: isEnabled,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory Device.fromJson({
    required dynamic jsonObject,
  }) {
    return Device(
      id: jsonObject["id"]?.toString() ?? "",
      name: jsonObject["name"]?.toString() ?? "",
      isEnabled: jsonObject["isEnabled"] ?? false,
      description: jsonObject["description"]?.toString(),
      createdAt: jsonObject["createdAt"] != null
          ? DateTime.parse(jsonObject["createdAt"])
          : null,
      updatedAt: jsonObject["updatedAt"] != null
          ? DateTime.parse(jsonObject["updatedAt"])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isEnabled': isEnabled,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

