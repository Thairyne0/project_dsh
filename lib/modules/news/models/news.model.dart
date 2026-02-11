import 'package:intl/intl.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';

class News extends BaseModel {
  @override
  String get modelIdentifier => "$title";

  String id;
  String title;
  String description;
  String imageUrl;
  DateTime startingAt;
  DateTime endingAt;
  bool isHighlighted;


  News._internal({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startingAt,
    required this.endingAt,
    required this.isHighlighted,

  });

  factory News({
    String id = "",
    String title = "",
    String description = "",
    String imageUrl = "",
    DateTime? startingAt,
    DateTime? endingAt,
    bool isHighlighted = false,

  }) {
    return News._internal(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      startingAt: startingAt ?? DateTime.now(),
      endingAt: endingAt ?? DateTime.now(),
      isHighlighted: isHighlighted,

    );
  }

  String get startingAtDate => DateFormat('dd-MM-yyyy').format(startingAt);

  String get endingAtDate => DateFormat('dd-MM-yyyy').format(endingAt);

  factory News.fromJson({
    required dynamic jsonObject,
  }) {
    return News(
      id: jsonObject["id"]?.toString() ?? "",
      title: jsonObject["title"] ?? "",
      description: jsonObject["description"] ?? "",
      imageUrl: jsonObject["imageUrl"] ?? "",
      startingAt: jsonObject["startingAt"] != null ? DateTime.parse(jsonObject["startingAt"]).toLocal() : DateTime.now(),
      endingAt: jsonObject["endingAt"] != null ? DateTime.parse(jsonObject["endingAt"]).toLocal() : DateTime.now(),
      isHighlighted: bool.tryParse(jsonObject["isHighlighted"].toString()) ?? false,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'startingAt': startingAt.toUtc().toIso8601String(),
      'endingAt': endingAt.toUtc().toIso8601String(),
      'isHighlighted': isHighlighted,
    };
  }
}
