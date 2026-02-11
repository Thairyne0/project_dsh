import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:project_dsh/modules/profile/constants/users_api.constant.dart';
import '../../../../utils/api_manager.util.dart';

class UserCalls {
  static Future<ApiCallResponse> getAllUser(BuildContext context,
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
        apiUrl: UserApi.users,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        showSuccessMessage: false,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getUser(BuildContext context, String userId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${UserApi.users}/$userId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createUser(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: UserApi.register,
      callType: ApiCallType.POST,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      context: context,
      showSuccessMessage: true
    );
  }

  static Future<ApiCallResponse> updateUser(BuildContext context, Map<String, dynamic> params, String userId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${UserApi.users}/$userId",
      callType: ApiCallType.PATCH,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      context: context,
      showSuccessMessage: true
    );
  }

  static Future<ApiCallResponse> deleteUser(BuildContext context, String userId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${UserApi.users}/$userId",
      callType: ApiCallType.DELETE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
      showSuccessMessage: true
    );
  }
}
