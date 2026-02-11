

import 'package:project_dsh/modules/users/modules/role_permission/models/role_permission.model.dart';

import '../../../../../utils/models/custom_model.model.dart';
import '../../../models/user.model.dart';

class Role extends BaseModel {
  @override
  String get modelIdentifier => "$name";

  String id;
  String name;
  String slug;
  List<User> users;
  List<RolePermission> rolePermissions;


  Role._internal({
    required this.id,
    required this.name,
    required this.slug,
    required this.users,
    required this.rolePermissions,

  });

  factory Role({
    String id = "",
    String name = "",
    String slug = "",
    List<User> users = const [],
    List<RolePermission> rolePermissions = const [],

  }) {
    return Role._internal(
      id: id,
      name: name,
      slug: slug,
      users: users,
      rolePermissions: rolePermissions,

    );
  }

  factory Role.fromJson({required dynamic jsonObject}) {
    return Role(
      id: jsonObject["id"]?.toString() ?? "",
      name: jsonObject["name"] ?? "",
      slug: jsonObject["slug"] ?? "",
      users: (jsonObject["users"] as List<dynamic>?)?.map((json) => User.fromJson(jsonObject: json)).toList() ?? [],
      rolePermissions: (jsonObject["rolePermissions"] as List<dynamic>?)?.map((jsonObject) => RolePermission.fromJson(jsonObject: jsonObject)).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'users': users.map((user) => user.toMap()).toList(),
      'rolePermissions': rolePermissions.map((rolePermissions) => rolePermissions.toMap()).toList(),

    };
  }
}
