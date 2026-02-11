import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../utils/api_manager.util.dart';
import '../../events/constants/event_api.constant.dart';
import 'dashboard_api.constant.dart';

class DashboardCalls {
  static Future<ApiCallResponse> getDashboard(BuildContext context) {
    return ApiManager.instance.makeApiCall(
        apiUrl: DashboardApi.fillDashboard,
        callType: ApiCallType.GET,
        returnBody: true,
        showErrorMessage: true,
        showSuccessMessage: false,
        encodeBodyUtf8: true,
        decodeUtf8: false,
        needAuth: true,
        context: context);
  }

  static Future<ApiCallResponse> fillGraph(BuildContext context, {Map<String, dynamic>? searchParams,required DateTime year}) {
    Map<String, dynamic> params = {
      "year":year.toUtc().toIso8601String()
    };
    return ApiManager.instance.makeApiCall(
        apiUrl: DashboardApi.fillGraph,
        callType: ApiCallType.GET,
        returnBody: true,
        showErrorMessage: true,
        showSuccessMessage: false,
        encodeBodyUtf8: true,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getAllEventDashboard(BuildContext context,
      {int? page, int? perPage, Map<String, dynamic>? searchParams, Map<String, dynamic>? orderByParams}) {
    Map<String, dynamic> params = {};
    if (page != null) {
      params["page"] = page;
      params["perPage"] = perPage;
    }
    if (searchParams != null && searchParams.isNotEmpty) {
      params["searchBy"] = jsonEncode(searchParams);
    }
    if (orderByParams != null && orderByParams.isNotEmpty) {
      params["orderBy"] = jsonEncode(ApiManager.instance.convertOrderBy(orderByParams));
    }
    return ApiManager.instance.makeApiCall(
        apiUrl: EventApi.events,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

}
