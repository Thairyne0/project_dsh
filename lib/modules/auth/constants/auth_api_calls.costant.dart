import 'package:flutter/cupertino.dart';
import 'package:project_dsh/modules/auth/constants/auth_api.constant.dart';
import '../../../utils/api_manager.util.dart';

class AuthCalls {
  static Future<ApiCallResponse> login(BuildContext context,Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
      apiUrl: AuthApi.login,
      callType: ApiCallType.POST,
      params: params,
      returnBody: true,
      showErrorMessage: true,
      showSuccessMessage: false,
      encodeBodyUtf8: true,
      decodeUtf8: false,
      context: context
    );
  }
  static Future<ApiCallResponse> getMe(BuildContext context) {
    print("chiamo get me");
    return ApiManager.instance.makeApiCall(
        apiUrl: AuthApi.me,
        callType: ApiCallType.GET,
        returnBody: true,
        showErrorMessage: true,
        showSuccessMessage: false,
        encodeBodyUtf8: true,
        decodeUtf8: false,
        needAuth: true,
        context: context
    );
  }
  static Future<ApiCallResponse> recoverPassword(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
        apiUrl: AuthApi.recoverPassword,
        callType: ApiCallType.POST,
        params: params,
        returnBody: true,
        showErrorMessage: false,
        showSuccessMessage: false,
        encodeBodyUtf8: true,
        decodeUtf8: false,
        context: context);
  }

  static Future<ApiCallResponse> verifyToken(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
        apiUrl: AuthApi.verifyToken,
        callType: ApiCallType.POST,
        params: params,
        returnBody: true,
        showErrorMessage: false,
        showSuccessMessage: false,
        encodeBodyUtf8: true,
        decodeUtf8: false,
        context: context);
  }


  static Future<ApiCallResponse> resetPassword(BuildContext context, Map<String, dynamic> params) {
    return ApiManager.instance.makeApiCall(
        apiUrl: AuthApi.resetPassword,
        callType: ApiCallType.POST,
        params: params,
        returnBody: true,
        showErrorMessage: false,
        showSuccessMessage: false,
        encodeBodyUtf8: true,
        decodeUtf8: false,
        context: context);
  }
}
