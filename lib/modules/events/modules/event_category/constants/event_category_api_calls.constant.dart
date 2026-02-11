import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../../utils/api_manager.util.dart';
import 'event_category_api.constant.dart';

class EventCategoryCalls {
  static Future<ApiCallResponse> getAllEventCategory(BuildContext context,
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
        apiUrl: EventCategoryApi.eventCategories,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getEventCategory(BuildContext context, String eventCategoryId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${EventCategoryApi.eventCategories}/$eventCategoryId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createEventCategory(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: EventCategoryApi.eventCategories,
      callType: ApiCallType.POST,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
      bodyType: BodyType.MULTIPART
    );
  }

  static Future<ApiCallResponse> updateEventCategory(BuildContext context, Map<String, dynamic> params, String eventCategoryId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${EventCategoryApi.eventCategories}/$eventCategoryId",
      callType: ApiCallType.PATCH,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
        bodyType: BodyType.MULTIPART
    );
  }

  static Future<ApiCallResponse> deleteEventCategory(BuildContext context, String eventCategoryId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${EventCategoryApi.eventCategories}/$eventCategoryId",
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
