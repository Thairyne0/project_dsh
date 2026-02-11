import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:project_dsh/modules/store/constants/store_api.constant.dart';
import '../../../utils/api_manager.util.dart';

class StoreCalls {
  static Future<ApiCallResponse> getAllStore(BuildContext context,
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
        apiUrl: StoreApi.stores,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getStore(BuildContext context, String storeId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${StoreApi.stores}/$storeId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createStore(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: StoreApi.stores,
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

  static Future<ApiCallResponse> updateStore(BuildContext context, Map<String, dynamic> params, String storeId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${StoreApi.stores}/$storeId",
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

  static Future<ApiCallResponse> deleteStore(BuildContext context, String storeId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${StoreApi.stores}/$storeId",
      callType: ApiCallType.DELETE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      context: context,
    );
  }
  static Future<ApiCallResponse> attachStoreEmployee(BuildContext context,Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: StoreApi.attachEmployee,
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

  static Future<ApiCallResponse> detachStoreEmployee(BuildContext context,String storeEmployeeId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${StoreApi.detachEmployee}/$storeEmployeeId",
      callType: ApiCallType.DELETE,
      returnBody: true,
      encodeBodyUtf8: false,
      showSuccessMessage: true,
      decodeUtf8: false,
      needAuth: true,
      context: context
    );
  }

  static Future<ApiCallResponse> attachStoreToStoreCategory(BuildContext context,Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
        apiUrl: StoreApi.attachStoreToStoreCategory,
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
        apiUrl: "${StoreApi.detachStoreFromStoreCategory}/$storeCategoryPivotId",
        callType: ApiCallType.DELETE,
        returnBody: true,
        encodeBodyUtf8: false,
        showSuccessMessage: true,
        decodeUtf8: false,
        needAuth: true,
        context: context
    );
  }






  static Future<ApiCallResponse> getAllStoreCategoryByStore(BuildContext context,String id,
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
        apiUrl: "${StoreApi.stores}/$id/getAllStoreCategoriesByStore",
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getAllStoreEmployeesByStore(BuildContext context,String id,
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
        apiUrl: "${StoreApi.stores}/$id/getAllStoreEmployeesByStore",
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }




}



