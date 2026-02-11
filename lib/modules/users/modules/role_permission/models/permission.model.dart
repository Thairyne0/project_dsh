import 'package:project_dsh/modules/users/modules/role_permission/models/role_permission.model.dart';
import 'package:project_dsh/modules/users/modules/role_permission/models/user_permission.model.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';

class Permission extends BaseModel {
  @override
  String get modelIdentifier => "$name";

  String id;
  String name;
  String slug;
  List<RolePermission> rolePermissions;
  List<UserPermission> userPermissions;

  Permission._internal({
    required this.id,
    required this.name,
    required this.slug,
    required this.rolePermissions,
    required this.userPermissions,
  });

  factory Permission({
    String id = "",
    String name = "",
    String slug = "",
    List<RolePermission> rolePermissions = const [],
    List<UserPermission> userPermissions = const [],
  }) {
    return Permission._internal(
      id: id,
      name: name,
      slug: slug,
      rolePermissions: rolePermissions,
      userPermissions: userPermissions,
    );
  }

  factory Permission.fromJson({required dynamic jsonObject}) {
    return Permission(
      id: jsonObject["id"]?.toString() ?? "",
      name: jsonObject["name"] ?? "",
      slug: jsonObject["slug"] ?? "",
      rolePermissions: (jsonObject["rolePermissions"] as List<dynamic>?)?.map((jsonObject) => RolePermission.fromJson(jsonObject: jsonObject)).toList() ?? [],
      userPermissions: (jsonObject["userPermissions"] as List<dynamic>?)?.map((jsonObject) => UserPermission.fromJson(jsonObject: jsonObject)).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'rolePermissions': rolePermissions.map((rolePermission) => rolePermission.toMap()).toList(),
      'userPermissions': userPermissions.map((userPermissions) => userPermissions.toMap()).toList(),
    };
  }
}
