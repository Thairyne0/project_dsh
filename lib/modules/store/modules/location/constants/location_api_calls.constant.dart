import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../../utils/api_manager.util.dart';
import 'location_api.constant.dart';

class LocationCalls {
  static Future<ApiCallResponse> getAllLocation(BuildContext context,
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
        apiUrl: LocationApi.locations,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getLocation(BuildContext context, String locationId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${LocationApi.locations}/$locationId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createLocation(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: LocationApi.locations,
      callType: ApiCallType.POST,
      returnBody: true,
      encodeBodyUtf8: false,
      showSuccessMessage: true,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> updateLocation(BuildContext context, Map<String, dynamic> params, String locationId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${LocationApi.locations}/$locationId",
      callType: ApiCallType.PATCH,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      showSuccessMessage: true,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> deleteLocation(BuildContext context, String locationId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${LocationApi.locations}/$locationId",
      callType: ApiCallType.DELETE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      showSuccessMessage: true,
      needAuth: true,
      context: context,
    );
  }
}
