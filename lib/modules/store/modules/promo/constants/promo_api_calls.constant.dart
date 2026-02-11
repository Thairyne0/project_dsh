import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../../utils/api_manager.util.dart';
import 'promo_api.constant.dart';

class PromoCalls {
  static Future<ApiCallResponse> getAllPromo(BuildContext context,
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
        apiUrl: PromoApi.promos,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getPromo(BuildContext context, String promoId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${PromoApi.promos}/$promoId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createPromo(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: PromoApi.promos,
      callType: ApiCallType.POST,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      bodyType: BodyType.MULTIPART,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> updatePromo(BuildContext context, Map<String, dynamic> params, String promoId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${PromoApi.promos}/$promoId",
      callType: ApiCallType.PATCH,
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

  static Future<ApiCallResponse> deletePromo(BuildContext context, String promoId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${PromoApi.promos}/$promoId",
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
