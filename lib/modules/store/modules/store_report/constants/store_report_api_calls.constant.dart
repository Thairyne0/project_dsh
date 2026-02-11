import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:project_dsh/modules/store/modules/store_report/constants/store_report_api.constant.dart';
import '../../../../../utils/api_manager.util.dart';

class StoreReportCalls {
  static Future<ApiCallResponse> getAllStoreReportByStore(BuildContext context,
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
        apiUrl: StoreReportApi.storeReports,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getAllStoreReport(BuildContext context,
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
        apiUrl: StoreReportApi.storeReports,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getStoreReport(BuildContext context, String storeReportId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${StoreReportApi.storeReports}/$storeReportId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createStoreReport(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: StoreReportApi.storeReports,
      callType: ApiCallType.POST,
      returnBody: true,
      encodeBodyUtf8: false,
      bodyType: BodyType.MULTIPART,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> updateStoreReport(BuildContext context, Map<String, dynamic> params, String storeReportId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${StoreReportApi.storeReports}/$storeReportId",
      callType: ApiCallType.PATCH,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      bodyType: BodyType.MULTIPART,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> deleteStoreReport(BuildContext context, String storeReportId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${StoreReportApi.storeReports}/$storeReportId",
      callType: ApiCallType.DELETE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> downloadReport(BuildContext context, {List<String>? ids}) {
    Map<String, dynamic> params = {'storeReportIds': ids != null && ids.isNotEmpty ? jsonEncode(ids) : []};
    return ApiManager.instance.makeApiCall(
      apiUrl: StoreReportApi.downloadReport,
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      params: params,
      context: context,
    );
  }


  static Future<ApiCallResponse> downloadReportExcel(
      BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: StoreReportApi.downloadReport,
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: false,
      showErrorMessage: true,
      context: context,
    );
  }
}
