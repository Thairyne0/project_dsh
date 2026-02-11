import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../../../../utils/api_manager.util.dart';
import 'event_api.constant.dart';

class EventCalls {
  static Future<ApiCallResponse> getAllEvent(BuildContext context,
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
        apiUrl: EventApi.events,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> bulkUploadUserEventProductMedia(BuildContext context, Map<String, dynamic> params,String eventId,) {
    log(params.toString());
    return ApiManager.instance.makeApiCall(
      apiUrl: "${EventApi.events}/bulkUploadUserEventProductMedia/$eventId",
      callType: ApiCallType.POST,
      returnBody: true,
      bodyType: BodyType.MULTIPART,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> getEvent(BuildContext context, String eventId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${EventApi.events}/$eventId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createEvent(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: EventApi.events,
      callType: ApiCallType.POST,
      returnBody: true,
      bodyType: BodyType.MULTIPART,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> updateEvent(BuildContext context, Map<String, dynamic> params, String eventId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${EventApi.events}/$eventId",
      callType: ApiCallType.PATCH,
      returnBody: true,
      bodyType: BodyType.MULTIPART,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> deleteEvent(BuildContext context, String eventId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${EventApi.events}/$eventId",
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
