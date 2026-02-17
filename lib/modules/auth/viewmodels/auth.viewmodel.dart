import 'dart:async';
import 'package:project_dsh/utils/extension.util.dart';
import 'package:project_dsh/utils/models/city.model.dart';
import 'package:project_dsh/utils/models/country.model.dart';
import 'package:project_dsh/utils/models/pageaction.model.dart';
import 'package:flutter/material.dart';
import 'package:project_dsh/utils/models/province.model.dart';
import 'package:project_dsh/utils/models/state.model.dart' as state;
import 'package:project_dsh/modules/users/models/user_data.model.dart';
import 'package:project_dsh/utils/shared_manager.util.dart';
import '../../../utils/api_manager.util.dart';
import '../../../utils/app_database.util.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/constants/strings.constant.dart';
import '../../users/models/user.model.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../../../utils/providers/navigation.util.provider.dart';
import '../../dashboard/constants/dashboard_routes.constants.dart';
import '../../users/modules/role_permission/models/role.model.dart';
import '../constants/auth_api_calls.costant.dart';

class AuthViewModel extends CLBaseViewModel {
  late TextEditingController emailTEC = TextEditingController();
  late TextEditingController passwordTEC = TextEditingController();

  AuthViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
    : super(
        viewContext: context,
        viewModelType: viewModelType,
        extraParams: extraParams,
      );

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
      default:
        break;
    }
    setBusy(false);
  }

  Future saveUserDataAtLogin(
    AuthState authState,
    Map<String, dynamic> body,
  ) async {
    User user = User(
      userData: UserData(
        cityOfResidence: City(
          province: Province(state: state.State(country: Country())),
        ),
      ),
      role: Role(),
    );
    user.accessToken = body["access_token"];
    await AppDatabase.deleteCurrentUser();
    await AppDatabase.storeUser(user);
    print("chiamo me");
    ApiCallResponse response = await AuthCalls.getMe(viewContext);
    print(response.bodyText);
    if (response.succeeded) {
      user = User.fromJson(jsonObject: response.jsonBody);
      user.accessToken = body["access_token"];
    }
    await AppDatabase.deleteCurrentUser();
    await AppDatabase.storeUser(user);
    SharedManager.setBool(Strings.authenticated, true);
    await authState.saveCurrentUser(user);
    NavigationState();
    viewContext.customGoNamed(DashboardRoutes.dashboard.name);
  }

  Future doLogin(AuthState authState) async {
    setBusy(true);
    Map<String, dynamic> params = {
      'email': emailTEC.text,
      'password': passwordTEC.text,
    };
    late ApiCallResponse response;
    response = await AuthCalls.login(viewContext, params);
    if (response.succeeded) {
      print(response.bodyText);
      await saveUserDataAtLogin(authState, response.jsonBody);
    }
    setBusy(false);
  }

  Future recoverPassword(String email) async {
    setBusy(true);
    Map<String, dynamic> params = {'email': email, 'source': 0};
    ApiCallResponse response;
    response = await AuthCalls.recoverPassword(viewContext, params);
    setBusy(false);
  }
}
