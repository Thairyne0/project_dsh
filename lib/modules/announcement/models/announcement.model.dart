import 'package:intl/intl.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';
import '../../../ui/widgets/cl_announcement/cl_announcemet.model.dart';

class Announcement extends BaseModel {
  @override
  String get modelIdentifier => title;

  String id;
  String title;
  String description;
  List<String> mediaUrls;
  CLAnnouncementPriority announcementPriority;
  DateTime createdAt;
  DateTime updatedAt;

  Announcement._internal({
    required this.id,
    required this.title,
    required this.description,
    required this.mediaUrls,
    required this.announcementPriority,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Announcement({
    String id = "",
    String name = "",
    String description = "",
    List<String> mediaUrls = const [],
    CLAnnouncementPriority announcementPriority = CLAnnouncementPriority.normal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Announcement._internal(
      id: id,
      title: name,
      description: description,
      mediaUrls: mediaUrls,
      announcementPriority: announcementPriority,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  String get createdAtDate => DateFormat('dd-MM-yyyy HH:mm').format(createdAt);

  factory Announcement.fromJson({
    required dynamic jsonObject,
  }) {
    return Announcement(
      id: jsonObject["id"]?.toString() ?? "",
      name: jsonObject["title"] ?? "",
      description: jsonObject["description"] ?? "",
      mediaUrls: List<String>.from(jsonObject["mediaUrls"] ?? []),
      announcementPriority: jsonObject["announcementPriority"] != null
          ? switch (jsonObject["announcementPriority"]) {
              0 => CLAnnouncementPriority.normal,
              1 => CLAnnouncementPriority.warning,
              2 => CLAnnouncementPriority.urgent,
              _ => CLAnnouncementPriority.normal, // Fallback per valori sconosciuti
            }
          : CLAnnouncementPriority.normal,
      // Default se nullo
      createdAt: jsonObject["createdAt"] != null ? DateTime.parse(jsonObject["createdAt"]).toLocal() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      //'mediaUrls': mediaUrls.map(()),
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }
}
