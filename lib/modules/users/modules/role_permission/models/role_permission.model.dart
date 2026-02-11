
import 'package:project_dsh/modules/users/modules/role_permission/models/permission.model.dart';
import 'package:project_dsh/modules/users/modules/role_permission/models/role.model.dart';

import '../../../../../utils/models/custom_model.model.dart';

class RolePermission extends BaseModel {
  @override
  String get modelIdentifier => "$id";

  String id;
  Role role;
  String roleId;
  Permission permission;
  String permissionId;


  RolePermission._internal({
    required this.id,
    required this.role,
    required this.roleId,
    required this.permission,
    required this.permissionId,

  });

  factory RolePermission({
    String id = "",
    String roleId = "",
    String permissionId = "",
    required Permission permission,
    required Role role,
  }) {
    return RolePermission._internal(
      id: id,
      role: role,
      roleId: roleId,
      permission: permission,
      permissionId: permissionId,

    );
  }

  factory RolePermission.fromJson({required dynamic jsonObject}) {
    return RolePermission(
      id: jsonObject["id"]?.toString() ?? "",
      roleId: jsonObject["roleId"] ?? "",
      permissionId: jsonObject["permissionId"] ?? "",
      role: jsonObject["role"] != null ? Role.fromJson(jsonObject: jsonObject["role"]) : Role(),
      permission: jsonObject["permission"] != null ? Permission.fromJson(jsonObject: jsonObject["permission"]) : Permission(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roleId': roleId,
      'permissionId': permissionId,
      'role': role.toMap(),
      'permission': permission.toMap(),
    };
  }
}
