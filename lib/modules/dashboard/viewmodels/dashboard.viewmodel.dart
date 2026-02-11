import 'dart:async';
import 'package:project_dsh/modules/dashboard/models/user_graph_data.model.dart';
import 'package:project_dsh/utils/models/pageaction.model.dart';
import 'package:flutter/material.dart';
import '../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../utils/api_manager.util.dart';
import '../../../utils/base.viewmodel.dart';
import '../../announcement/models/announcement.model.dart';
import '../../events/models/event.model.dart';
import '../constants/dashboard_api_calls.costant.dart';
import '../models/dashboard.model.dart';

class DashboardViewModel extends CLBaseViewModel {
  late List<Announcement> announcementList = [];
  late List<UserGraphData> userGraphData = [];
  late Dashboard dashboard;
  DateTime selectedDate = DateTime.now();
  List<DateTime> years = [];

  DashboardViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);
  PagedDataTableController<String, String, Event> eventDashboardTableController = PagedDataTableController<String, String, Event>();

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);

    switch (viewModelType) {
      case VMType.list:
        years = calculateYears();
        selectedDate = years.where((e) => e.year == DateTime.now().year).first;
        dashboard = await fillDashboard();
        userGraphData = await fillGraph();
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

  List<DateTime> calculateYears() {
    final int currentYear = DateTime.now().year;
    return List.generate(
      11,
      (index) => DateTime(currentYear - 5 + index),
    );
  }

  Future<Dashboard> fillDashboard() async {
    late Dashboard downloadedDashboard;
    ApiCallResponse apiCallResponse = await DashboardCalls.getDashboard(viewContext);
    if (apiCallResponse.succeeded) {
      downloadedDashboard = Dashboard.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedDashboard;
  }


  Future<void> restartDevice(deviceId) async {
    setBusy(true);
    setBusy(false);
  }


  Future<List<UserGraphData>> fillGraph() async {
    List<UserGraphData> downloadedGraphData = [];
    ApiCallResponse apiCallResponse = await DashboardCalls.fillGraph(viewContext, year: selectedDate);
    if (apiCallResponse.succeeded) {
      final graphJsonObject = apiCallResponse.jsonBody["signupGraphData"];
      if (graphJsonObject is List) {
        for (var jsonObject in graphJsonObject) {
          downloadedGraphData.add(UserGraphData.fromJson(jsonObject: jsonObject));
        }
      }
    }
    return downloadedGraphData;
  }

  Future<(List<Event>, Pagination?)> getAllEventDashboard({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    searchBy.addAll({"status": 1, "endingAt": {"gte": "${DateTime.now().toUtc().toIso8601String()}"}});
    ApiCallResponse apiCallResponse = await DashboardCalls.getAllEventDashboard(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy,);
    List<Event> eventArray = [];
    if (apiCallResponse.succeeded) {
      final eventsJsonObject = (apiCallResponse.jsonBody as List);
      eventArray = eventsJsonObject.map((jsonObject) => Event.fromJson(jsonObject: jsonObject)).take(5).toList();
    }
    return (eventArray, apiCallResponse.pagination);
  }

}
