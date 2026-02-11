import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:project_dsh/modules/store/modules/store_category/constants/store_category_api.constant.dart';
import '../../../../../utils/api_manager.util.dart';

class StoreCategoryCalls {
  static Future<ApiCallResponse> getAllStoreCategory(BuildContext context,
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
        apiUrl: StoreCategoryApi.storeCategories,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getStoreCategory(BuildContext context, String storeCategoryId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${StoreCategoryApi.storeCategories}/$storeCategoryId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createStoreCategory(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: StoreCategoryApi.storeCategories,
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

  static Future<ApiCallResponse> updateStoreCategory(BuildContext context, Map<String, dynamic> params, String storeCategoryId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${StoreCategoryApi.storeCategories}/$storeCategoryId",
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

  static Future<ApiCallResponse> deleteStoreCategory(BuildContext context, String storeCategoryId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${StoreCategoryApi.storeCategories}/$storeCategoryId",
      callType: ApiCallType.DELETE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }


  static Future<ApiCallResponse> attachStoreToStoreCategory(BuildContext context,Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
        apiUrl: StoreCategoryApi.attachStoreToStoreCategory,
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

  static Future<ApiCallResponse> detachStoreFromStoreCategory(BuildContext context,String storeCategoryPivotId) {
    return ApiManager.instance.makeApiCall(
        apiUrl: "${StoreCategoryApi.detachStoreFromStoreCategory}/$storeCategoryPivotId",
        callType: ApiCallType.DELETE,
        returnBody: true,
        encodeBodyUtf8: false,
        showSuccessMessage: true,
        decodeUtf8: false,
        needAuth: true,
        context: context
    );
  }


  static Future<ApiCallResponse> getAllStoreByStoreCategory(BuildContext context,String id,
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
        apiUrl: "${StoreCategoryApi.storeCategories}/$id/getAllStoreByStoreCategory",
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }




}
