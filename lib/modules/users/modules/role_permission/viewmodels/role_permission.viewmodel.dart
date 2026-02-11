import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/api_manager.util.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../constants/role_permission_api_calls.constant.dart';
import '../models/permission.model.dart';
import '../models/role.model.dart';
import '../models/role_permission.model.dart';

class RoleViewModel extends CLBaseViewModel {
  late TextEditingController nameTEC = TextEditingController();
  late Role role;
  late Permission permission;
  List<Permission> selectedPermission = [];
  PagedDataTableController<String, String, Role> roleTableController = PagedDataTableController<String, String, Role>();
  PagedDataTableController<String, String, RolePermission> rolePermissionTableController = PagedDataTableController<String, String, RolePermission>();

  RoleViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    switch (viewModelType) {
      case VMType.list:
        break;
      case VMType.create:
        break;
      case VMType.edit:
        String roleId = extraParams as String;
        role = await getRole(roleId);
        nameTEC.text = role.name;
        break;
      case VMType.detail:
        String roleId = extraParams as String;
        role = await getRole(roleId);
        break;
      case VMType.other:
        String roleId = extraParams as String;
        role = await getRole(roleId);
        nameTEC.text = role.name;
        break;
      default:
        break;
    }
    setBusy(false);
  }

  Future<(List<Role>, Pagination?)> getAllRole({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<Role> rolesArray = [];
    ApiCallResponse apiCallResponse = await RoleCalls.getAllRole(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final rolesJsonObject = (apiCallResponse.jsonBody as List);
      rolesJsonObject.asMap().forEach(
        (index, jsonObject) {
          rolesArray.add(Role.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (rolesArray, apiCallResponse.pagination);
  }

  Future<(List<Permission>, Pagination?)> getAllPermission({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    searchBy.addAll({"rolePermissions:some:roleId": role.id});
    late List<Permission> permissionsArray = [];
    ApiCallResponse apiCallResponse =
        await PermissionCalls.getAllPermission(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final permissionsJsonObject = (apiCallResponse.jsonBody as List);
      permissionsJsonObject.asMap().forEach(
        (index, jsonObject) {
          permissionsArray.add(Permission.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (permissionsArray, apiCallResponse.pagination);
  }

  Future<(List<RolePermission>, Pagination?)> getAllRolePermission({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    searchBy.addAll({"roleId": role.id});
    late List<RolePermission> rolePermissionsArray = [];
    ApiCallResponse apiCallResponse =
    await PermissionCalls.getAllRolePermission(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final rolePermissionsJsonObject = (apiCallResponse.jsonBody as List);
      rolePermissionsJsonObject.asMap().forEach(
            (index, jsonObject) {
              rolePermissionsArray.add(RolePermission.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (rolePermissionsArray, apiCallResponse.pagination);
  }

  Future<(List<Permission>, Pagination?)> getAllPermissionByRole({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy,}) async {
    searchBy ??= {};
    searchBy.addAll({"rolePermissions:none:roleId": role.id});
    late List<Permission> permissionsByRoleArray = [];
    ApiCallResponse apiCallResponse = await PermissionCalls.getAllPermission(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final permissionsByRoleJsonArray = (apiCallResponse.jsonBody as List);
      permissionsByRoleJsonArray.forEach((jsonObject) {
        permissionsByRoleArray.add(Permission.fromJson(jsonObject: jsonObject));
      });
    }
    return (permissionsByRoleArray, apiCallResponse.pagination);
  }

  Future<Role> getRole(roleId) async {
    late Role downloadedRole;
    ApiCallResponse apiCallResponse = await RoleCalls.getRole(viewContext, roleId);
    if (apiCallResponse.succeeded) {
      downloadedRole = Role.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedRole;
  }

  Future deleteRole(roleId) async {
    setBusy(true);
    await RoleCalls.deleteRole(viewContext, roleId);
    setBusy(false);
  }

  Future createRole() async {
    setBusy(true);
    Map<String, dynamic> params = {"name": nameTEC.text};
    await RoleCalls.createRole(viewContext, params);
    setBusy(false);
  }

  Future updateRole(String roleId) async {
    setBusy(true);
    Map<String, dynamic> params = {"name": nameTEC.text};
    ApiCallResponse apiCallResponse = await RoleCalls.updateRole(viewContext, params, roleId);
    setBusy(false);
  }

  Future attachPermissionToRole() async {
    setBusy(true);
    Map<String, dynamic> params = {"roleId": role.id, "permissionIds": selectedPermission.map((permission) => permission.id).toList()};
    ApiCallResponse apiCallResponse = await PermissionCalls.attachPermissionToRole(viewContext, params);
    setBusy(false);
  }

  Future detachPermissionToRole(String roleId) async {
    setBusy(true);
    ApiCallResponse apiCallResponse = await PermissionCalls.detachPermissionFromRole(viewContext, roleId);
    setBusy(false);
  }
}
