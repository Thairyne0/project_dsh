import 'package:flutter/cupertino.dart';
import 'package:project_dsh/modules/profile/constants/profile_api.costant.dart';
import '../../../../utils/api_manager.util.dart';

class ProfileCalls {


  static Future<ApiCallResponse> getUser(BuildContext context, String userId) {
    return ApiManager.instance.makeApiCall(
      apiUrl: "${ProfileApi.users}/$userId",
      callType: ApiCallType.GET,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      bodyType: BodyType.MULTIPART,
      needAuth: true,
      context: context,
    );
  }


  static Future<ApiCallResponse> updateUser(BuildContext context, Map<String, dynamic> params, String userId) {
    return ApiManager.instance.makeApiCall(
        apiUrl: "${ProfileApi.users}/$userId",
        callType: ApiCallType.PATCH,
        returnBody: true,
        encodeBodyUtf8: false,
        params: params,
        bodyType: BodyType.MULTIPART,
        decodeUtf8: false,
        needAuth: true,
        context: context,
        showSuccessMessage: true
    );
  }

}
