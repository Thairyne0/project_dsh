

import 'package:project_dsh/modules/users/modules/role_permission/models/permission.model.dart';

import '../../../../../utils/models/custom_model.model.dart';
import '../../../models/user.model.dart';

class UserPermission extends BaseModel {
  @override
  String get modelIdentifier => id;

  String id;
  User? user;
  String? userId;
  Permission? permission;
  String? permissionId;


  UserPermission._internal({
    required this.id,
    this.user,
    this.userId,
    this.permission,
    this.permissionId,

  });

  factory UserPermission({
    String id = "",
    User? user,
    String? userId,
    Permission? permission,
    String? permissionId,

  }) {
    return UserPermission._internal(
      id: id,
      user: user,
      userId: userId,
      permission: permission,
      permissionId: permissionId,

    );
  }

  factory UserPermission.fromJson({required dynamic jsonObject}) {
    return UserPermission(
      id: jsonObject["id"]?.toString() ?? "",
      userId: jsonObject["userId"]?.toString(),
      permissionId: jsonObject["permissionId"]?.toString(),
      user: jsonObject["user"] != null ? User.fromJson(jsonObject: jsonObject["user"]) : null,
      permission: jsonObject["permission"] != null ? Permission.fromJson(jsonObject: jsonObject["permission"]) : null,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'permissionId': permissionId,
      'user': user?.toMap(),
      'permission': permission?.toMap(),

    };
  }
}
