import 'package:project_dsh/utils/models/custom_model.model.dart';
import '../../../models/event.model.dart';

class EventCategory extends BaseModel {
  @override
  String get modelIdentifier => "$name";

  String id;
  String name;
  List<Event> events;
  String imageUrl;


  EventCategory._internal({
    required this.id,
    required this.name,
    required this.events,
    required this.imageUrl,
  });

  factory EventCategory({
    String id = "",
    String name = "",
    List<Event> events = const [],
    String imageUrl = "",

  }) {
    return EventCategory._internal(
      id: id,
      name: name,
      events: events,
      imageUrl: imageUrl,
    );
  }

  factory EventCategory.fromJson({
    required dynamic jsonObject,
  }) {
    return EventCategory(
      id: jsonObject["id"]?.toString() ?? "",
      name: jsonObject["name"] ?? "",
      events: (jsonObject["events"] as List<dynamic>?)?.map((events) => Event.fromJson(jsonObject: events)).toList() ?? [],
      imageUrl: jsonObject["imageUrl"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'events': events.map((events) => events.toMap()).toList(),
    };
  }
}
