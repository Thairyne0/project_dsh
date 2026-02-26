import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_dsh/modules/auth/constants/auth_routes.constants.dart';
import 'package:project_dsh/modules/dashboard/constants/dashboard_routes.constants.dart';
import 'package:project_dsh/modules/production/constants/production_routes.constants.dart';
import 'package:project_dsh/modules/service_selector/constants/service_selector_routes.constants.dart';
import 'package:project_dsh/utils/extension.util.dart';
import 'package:project_dsh/utils/providers/authstate.util.provider.dart';
import 'package:project_dsh/utils/providers/service_state.util.provider.dart';
import 'package:provider/provider.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/models/pageaction.model.dart';

class WelcomeViewModel extends CLBaseViewModel {
  WelcomeViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    AuthState authState = Provider.of<AuthState>(viewContext, listen: false);
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    Future.delayed(const Duration(seconds: 1), () {
      if (authState.isAuthenticated) {
        final serviceState = ServiceState();
        if (serviceState.hasSelection) {
          _navigateToServiceHome(serviceState.selected!);
        } else {
          viewContext.customGoNamed(ServiceSelectorRoutes.selector.name);
        }
      } else {
        viewContext.customGoNamed(AuthRoutes.login.name);
      }
    });
    setBusy(false);
  }

  void _navigateToServiceHome(ServiceType service) {
    switch (service) {
      case ServiceType.macchinari:
        viewContext.customGoNamed(ProductionRoutes.production.name);
        break;
      case ServiceType.vulcanobuono:
      case ServiceType.finanza:
      default:
        viewContext.customGoNamed(DashboardRoutes.dashboard.name);
        break;
    }
  }
}
