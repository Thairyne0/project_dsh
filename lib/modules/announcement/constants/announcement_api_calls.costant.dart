import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../../../utils/api_manager.util.dart';
import 'announcement_api.costant.dart';

class AnnouncementCalls {
  static Future<ApiCallResponse> getAllAnnouncements(BuildContext context,
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
        apiUrl: AnnouncementApi.announcements,
        callType: ApiCallType.GET,
        returnBody: true,
        encodeBodyUtf8: false,
        decodeUtf8: false,
        needAuth: true,
        params: params,
        context: context);
  }

  static Future<ApiCallResponse> getAnnouncement(BuildContext context, String announcementId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${AnnouncementApi.announcements}/$announcementId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> createAnnouncement(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: AnnouncementApi.announcements,
      callType: ApiCallType.POST,
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      showErrorMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> updateAnnouncement(BuildContext context, Map<String, dynamic> params, String announcementId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${AnnouncementApi.announcements}/$announcementId",
      callType: ApiCallType.PATCH,
      returnBody: true,
      encodeBodyUtf8: false,
      params: params,
      bodyType: BodyType.MULTIPART,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      showErrorMessage: true,
      context: context,
    );
  }

  static Future<ApiCallResponse> deleteAnnouncement(BuildContext context, String announcementId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${AnnouncementApi.announcements}/$announcementId",
      callType: ApiCallType.DELETE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      needAuth: true,
      showSuccessMessage: true,
      showErrorMessage: true,
      context: context,
    );
  }
}
