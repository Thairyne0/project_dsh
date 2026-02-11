import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:project_dsh/modules/users/modules/role_permission/constants/role_permission_api.constant.dart';

import '../../../../../utils/api_manager.util.dart';

class RoleCalls {
  static Future<ApiCallResponse> getAllRole(BuildContext context,
      {int? page, int? perPage, Map<String, dynamic>? searchParams, Map<String, dynamic>? orderByParams}) {
    Map<String, dynamic> params = {};
    if (page != null) {
      params["page"] = page;
      params["perPage"] = perPage;
    }
    if (searchParams != null && searchParams.isNotEmpty) {
      params["searchBy"] = jsonEncode(ApiManager.instance.convertSearchBy(searchParams));
    }
    if (orderByParams != null && orderByParams.isNotEmpty) {
      params["orderBy"] = jsonEncode(ApiManager.instance.convertOrderBy(orderByParams));
    }
    return ApiManager.instance.makeApiCall(
        apiUrl: RolePermissionApi.role,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getRole(BuildContext context, String roleId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${RolePermissionApi.role}/$roleId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createRole(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: RolePermissionApi.role,
      callType: ApiCallType.POST,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> updateRole(BuildContext context, Map<String, dynamic> params, String roleId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${RolePermissionApi.role}/$roleId",
      callType: ApiCallType.PUT,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> deleteRole(BuildContext context, String roleId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${RolePermissionApi.role}/$roleId",
      callType: ApiCallType.DELETE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }
}


class PermissionCalls {
  static Future<ApiCallResponse> getAllPermission(BuildContext context,
      {int? page, int? perPage, Map<String, dynamic>? searchParams, Map<String, dynamic>? orderByParams}) {
    Map<String, dynamic> params = {};
    if (page != null) {
      params["page"] = page;
      params["perPage"] = perPage;
    }
    if (searchParams != null && searchParams.isNotEmpty) {
      params["searchBy"] = jsonEncode(ApiManager.instance.convertSearchBy(searchParams));
    }
    if (orderByParams != null && orderByParams.isNotEmpty) {
      params["orderBy"] = jsonEncode(ApiManager.instance.convertOrderBy(orderByParams));
    }
    return ApiManager.instance.makeApiCall(
        apiUrl: RolePermissionApi.permissions,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getAllPermissionByRole(BuildContext context,
      {int? page, int? perPage, Map<String, dynamic>? searchParams, Map<String, dynamic>? orderByParams,required String roleId}) {
    Map<String, dynamic> params = {};
    if (page != null) {
      params["page"] = page;
      params["perPage"] = perPage;
    }
    if (searchParams != null && searchParams.isNotEmpty) {
      params["searchBy"] = jsonEncode(ApiManager.instance.convertSearchBy(searchParams));
    }
    if (orderByParams != null && orderByParams.isNotEmpty) {
      params["orderBy"] = jsonEncode(ApiManager.instance.convertOrderBy(orderByParams));
    }
    return ApiManager.instance.makeApiCall(
        apiUrl: "${RolePermissionApi.permissionsByRole}/$roleId",
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getAllRolePermission(BuildContext context,
      {int? page, int? perPage, Map<String, dynamic>? searchParams, Map<String, dynamic>? orderByParams}) {
    Map<String, dynamic> params = {};
    if (page != null) {
      params["page"] = page;
      params["perPage"] = perPage;
    }
    if (searchParams != null && searchParams.isNotEmpty) {
      params["searchBy"] = jsonEncode(ApiManager.instance.convertSearchBy(searchParams));
    }
    if (orderByParams != null && orderByParams.isNotEmpty) {
      params["orderBy"] = jsonEncode(ApiManager.instance.convertOrderBy(orderByParams));
    }
    return ApiManager.instance.makeApiCall(
        apiUrl: RolePermissionApi.rolePermission,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getPermission(BuildContext context, String permissionId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${RolePermissionApi.permissions}/$permissionId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createPermission(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: RolePermissionApi.permissions,
      callType: ApiCallType.POST,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> updatePermission(BuildContext context, Map<String, dynamic> params, String permissionId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${RolePermissionApi.permissions}/$permissionId",
      callType: ApiCallType.PUT,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> deletePermission(BuildContext context, String permissionId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${RolePermissionApi.permissions}/$permissionId",
      callType: ApiCallType.DELETE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }


  static Future<ApiCallResponse> attachPermissionToRole(BuildContext context,Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
        apiUrl: RolePermissionApi.attachPermissionToRole,
        callType: ApiCallType.POST,
        returnBody: true,
        showSuccessMessage: true,
        encodeBodyUtf8: false,
        params: params,
        decodeUtf8: false,
        needAuth: true,
        context: context
    );
  }
  static Future<ApiCallResponse> attachPermissionToUser(BuildContext context,Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
        apiUrl: RolePermissionApi.attachPermissionToUser,
        callType: ApiCallType.POST,
        returnBody: true,
        showSuccessMessage: true,
        encodeBodyUtf8: false,
        params: params,
        decodeUtf8: false,
        needAuth: true,
        context: context
    );
  }

  static Future<ApiCallResponse> detachPermissionFromRole(BuildContext context,String rolePermissionId) {
    return ApiManager.instance.makeApiCall(
        apiUrl: "${RolePermissionApi.detachPermissionFromRole}/$rolePermissionId",
        callType: ApiCallType.DELETE,
        returnBody: true,
        encodeBodyUtf8: false,
        showSuccessMessage: true,
        decodeUtf8: false,
        needAuth: true,
        context: context
    );
  }
  static Future<ApiCallResponse> detachPermissionFromUser(BuildContext context,String userId) {
    return ApiManager.instance.makeApiCall(
        apiUrl: "${RolePermissionApi.detachPermissionFromUser}/$userId",
        callType: ApiCallType.DELETE,
        returnBody: true,
        encodeBodyUtf8: false,
        showSuccessMessage: true,
        decodeUtf8: false,
        needAuth: true,
        context: context
    );
  }


}
