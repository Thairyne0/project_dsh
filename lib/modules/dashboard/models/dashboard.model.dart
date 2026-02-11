import 'package:project_dsh/utils/models/custom_model.model.dart';
import 'city_graph_data.model.dart';

class Dashboard extends BaseModel {
  String id;
  int totalUsers;
  int totalEvents;
  int totalPromos;
  int totalOpenTickets;
  List<CityGraphData> cityGraphData;

  @override
  String get modelIdentifier => "$id";

  Dashboard._internal({
    required this.id,
    required this.totalUsers,
    required this.totalEvents,
    required this.totalPromos,
    required this.totalOpenTickets,
    required this.cityGraphData,
  });

  factory Dashboard({
    String id = "",
    int totalUsers = 0,
    int totalEvents = 0,
    int totalPromos = 0,
    int totalOpenTickets = 0,
    List<CityGraphData> cityGraphData = const [],
  }) {
    return Dashboard._internal(
        id: id, totalEvents: totalEvents, totalUsers: totalUsers, cityGraphData: cityGraphData, totalPromos: totalPromos, totalOpenTickets: totalOpenTickets);
  }

  factory Dashboard.fromJson({
    required dynamic jsonObject,
  }) {
    return Dashboard(
      id: jsonObject["id"]?.toString() ?? "",
      totalEvents: int.tryParse(jsonObject["totalEvents"].toString()) ?? 0,
      totalUsers: int.tryParse(jsonObject["totalUsers"].toString()) ?? 0,
      totalPromos: int.tryParse(jsonObject["totalPromos"].toString()) ?? 0,
      totalOpenTickets: int.tryParse(jsonObject["totalOpenTickets"].toString()) ?? 0,
      cityGraphData: (jsonObject["cityGraphData"] as List<dynamic>?)?.map((cityGraphData) => CityGraphData.fromJson(jsonObject: cityGraphData)).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalEvents': totalEvents,
      'totalUsers': totalUsers,
      'totalPromos': totalPromos,
      'totalOpenTickets': totalOpenTickets,
      'cityGraphData': cityGraphData.map((cityGraphData) => cityGraphData.toMap()).toList(),
    };
  }
}
