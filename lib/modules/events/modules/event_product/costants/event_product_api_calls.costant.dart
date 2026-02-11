import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../../utils/api_manager.util.dart';
import 'event_product_api.costant.dart';

class EventProductCalls {
  static Future<ApiCallResponse> getEventProductByEvent(BuildContext context,
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
        apiUrl: EventProductApi.eventProducts,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }
  static Future<ApiCallResponse> getAllUserEventProducts(BuildContext context, String id,
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
        apiUrl: "${EventProductApi.events}/$id/partecipants",
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }


  static Future<ApiCallResponse> getEventProduct(BuildContext context, String eventProductId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${EventProductApi.eventProducts}/$eventProductId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createEventProduct(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: EventProductApi.eventProducts,
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

  static Future<ApiCallResponse> updateEventProduct(BuildContext context, Map<String, dynamic> params, String eventProductId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${EventProductApi.eventProducts}/$eventProductId",
      callType: ApiCallType.PATCH,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> deleteEventProduct(BuildContext context, String eventProductId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${EventProductApi.eventProducts}/$eventProductId",
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
