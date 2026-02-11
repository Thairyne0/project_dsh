import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:project_dsh/ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/api_manager.util.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/models/upload_file.model.dart';
import '../constants/announcement_api_calls.costant.dart';
import '../models/announcement.model.dart';

class AnnouncementViewModel extends CLBaseViewModel {
  late TextEditingController titleTEC = TextEditingController();
  QuillController descriptionTEC = QuillController.basic();
  quill.Document? _descriptionDoc;
  quill.Document? get descriptionDoc => _descriptionDoc;
  late Announcement announcement;
  late List<Announcement> announcementList = [];
  List<CLMedia> mediaFiles = [];
  PagedDataTableController<String, String, Announcement> announcementTableController = PagedDataTableController<String, String, Announcement>();

  AnnouncementViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

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
        String announcementId = extraParams as String;
        announcement = await getAnnouncement(announcementId);
        titleTEC.text = announcement.title;
        descriptionTEC.document = Document.fromJson(jsonDecode(announcement.description));
        mediaFiles = announcement.mediaUrls.map((mediaUrls) => CLMedia(fileUrl: mediaUrls)).toList();
        break;
      case VMType.detail:
        String announcementId = extraParams as String;
        announcement = await getAnnouncement(announcementId);
        _descriptionDoc = parseQuillFromRaw(announcement.description);
        break;
      default:
        break;
    }
    setBusy(false);
  }

  quill.Document parseQuillFromRaw(String? rawJson, {String fallbackText = 'Contenuto non disponibile'}) {
    if (rawJson == null || rawJson.trim().isEmpty) {
      return quill.Document()..insert(0, fallbackText);
    }
    try {
      final delta = jsonDecode(rawJson);
      return quill.Document.fromJson(delta);
    } catch (e) {
      print("Errore nel parsing Quill: $e");
      return quill.Document()..insert(0, fallbackText);
    }
  }

  Future<(List<Announcement>, Pagination?)> getAllAnnouncement({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<Announcement> announcementArray = [];
    ApiCallResponse apiCallResponse =
        await AnnouncementCalls.getAllAnnouncements(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final announcementsJsonObject = (apiCallResponse.jsonBody as List);
      announcementsJsonObject.asMap().forEach(
        (index, jsonObject) {
          announcementArray.add(Announcement.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (announcementArray, apiCallResponse.pagination);
  }

  Future<Announcement> getAnnouncement(announcementId) async {
    late Announcement downloadedAnnouncement;
    ApiCallResponse apiCallResponse = await AnnouncementCalls.getAnnouncement(viewContext, announcementId);
    if (apiCallResponse.succeeded) {
      downloadedAnnouncement = Announcement.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedAnnouncement;
  }

  Future deleteAnnouncement(announcementId) async {
    setBusy(true);
    ApiCallResponse apiCallResponse = await AnnouncementCalls.deleteAnnouncement(viewContext, announcementId);
    setBusy(false);
  }

  Future createAnnouncement() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "title": titleTEC.text,
      "description": jsonEncode(descriptionTEC.document.toDelta().toJson()),
    };

    if (mediaFiles.isNotEmpty) {
      params.addAll({"medias": mediaFiles.map((media) => FFUploadedFile(clMedia: media)).toList()});
    }
    print(params);
    ApiCallResponse apiCallResponse = await AnnouncementCalls.createAnnouncement(viewContext, params);
    print("aaaaa");
    print(apiCallResponse.bodyText);
    setBusy(false);
  }

  Future updateAnnouncement(String announcementId) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "title": titleTEC.text,
      "description": jsonEncode(descriptionTEC.document.toDelta().toJson()),
    };
    if (mediaFiles.isNotEmpty) {
      params.addAll({"medias": mediaFiles.map((media) => FFUploadedFile(clMedia: media)).toList()});
    }
    print(params);
    ApiCallResponse apiCallResponse = await AnnouncementCalls.updateAnnouncement(viewContext, params, announcementId);
    print("aaaaa");
    print(apiCallResponse.bodyText);
    setBusy(false);
  }
}
