import 'dart:async';
import 'package:project_dsh/utils/extension.util.dart';
import 'package:flutter/material.dart';
import '../../../utils/api_manager.util.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/constants/routes.constants.dart';
import '../../../utils/models/pageaction.model.dart';
import '../constants/auth_api_calls.costant.dart';
import '../constants/auth_routes.constants.dart';

class PasswordViewModel extends CLBaseViewModel {
  PasswordViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  TextEditingController newPasswordTEC = TextEditingController();
  TextEditingController confirmNewPasswordTEC = TextEditingController();
  String token = '';
  String errorMessage = '';

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    switch (viewModelType) {
      case VMType.list:
        break;
      case VMType.create:
        break;
      case VMType.edit:
        break;
      case VMType.detail:
        break;
      case VMType.other:
        token = extraParams as String;
        await verifyToken();
    }
    setBusy(false);
  }

  Future verifyToken() async {
    setBusy(true);
    Map<String, dynamic> params = {
      'token': token,
    };
    ApiCallResponse apiCallResponse = await AuthCalls.verifyToken(viewContext, params);
    if (apiCallResponse.succeeded) {
      setBusy(false);
    } else {
      setBusy(false);
      viewContext.customGoNamed(AppRoutes.error.name);
    }
  }

  Future resetPassword() async {
    setBusy(true);
    Map<String, dynamic> params = {
      'token': token,
      'newPassword': newPasswordTEC.text,
    };
    ApiCallResponse apiCallResponse = await AuthCalls.resetPassword(viewContext, params);
    if (apiCallResponse.succeeded) {
      setBusy(false);
      viewContext.customGoNamed(AuthRoutes.confirmNewPassword.name);
    } else {
      setBusy(false);
      viewContext.customGoNamed(AppRoutes.error.name);
    }
  }
}
