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
import '../constants/news_api_calls.costant.dart';
import '../models/news.model.dart';

class NewsViewModel extends CLBaseViewModel {
  late TextEditingController titleTEC = TextEditingController();
  QuillController descriptionTEC = QuillController.basic();
  quill.Document? _descriptionDoc;
  quill.Document? get descriptionDoc => _descriptionDoc;
  late TextEditingController startingAtTEC = TextEditingController();
  late TextEditingController endingAtTEC = TextEditingController();
  CLMedia? imageFile;
  late News news;
  DateTime? selectedStartingAtDate;
  DateTime? selectedEndingAtDate;
  bool isHighlighted = false;

  PagedDataTableController<String, String, News> newsTableController = PagedDataTableController<String, String, News>();

  NewsViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
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
        String newsId = extraParams as String;
        news = await getNews(newsId);
        titleTEC.text = news.title;
        descriptionTEC.document = Document.fromJson(jsonDecode(news.description));
        startingAtTEC.text = news.startingAtDate;
        endingAtTEC.text = news.endingAtDate;
        selectedStartingAtDate = news.startingAt;
        selectedEndingAtDate = news.endingAt;
        imageFile = CLMedia(fileUrl: news.imageUrl);
        isHighlighted = news.isHighlighted;
        break;
      case VMType.detail:
        String newsId = extraParams as String;
        news = await getNews(newsId);
        _descriptionDoc = parseQuillFromRaw(news.description);
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

  Future<(List<News>, Pagination?)> getAllNews({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<News> newsArray = [];
    ApiCallResponse apiCallResponse = await NewsCalls.getAllNews(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final newsJsonObject = (apiCallResponse.jsonBody as List);
      newsJsonObject.asMap().forEach(
        (index, jsonObject) {
          newsArray.add(News.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (newsArray, apiCallResponse.pagination);
  }

  Future<News> getNews(newsId) async {
    late News downloadedNews;
    ApiCallResponse apiCallResponse = await NewsCalls.getNews(viewContext, newsId);
    if (apiCallResponse.succeeded) {
      downloadedNews = News.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedNews;
  }

  Future deleteNews(newsId) async {
    setBusy(true);
    ApiCallResponse apiCallResponse = await NewsCalls.deleteNews(viewContext, newsId);
    setBusy(false);
  }

  Future createNews() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "title": titleTEC.text,
      "description": jsonEncode(descriptionTEC.document.toDelta().toJson()) ,
      'startingAt': selectedStartingAtDate?.toUtc().toIso8601String(),
      'endingAt': selectedEndingAtDate?.toUtc().toIso8601String(),
      "isHighlighted": isHighlighted,

    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await NewsCalls.createNews(viewContext, params);
    setBusy(false);
  }

  Future updateNews(String newsId) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "title": titleTEC.text,
      "description": jsonEncode(descriptionTEC.document.toDelta().toJson()) ,
      'startingAt': selectedStartingAtDate?.toUtc().toIso8601String(),
      'endingAt': selectedEndingAtDate?.toUtc().toIso8601String(),
      "isHighlighted": isHighlighted,

    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await NewsCalls.updateNews(viewContext, params, newsId);
    setBusy(false);
  }

  void setIsHighlighted(bool newValue) {
    isHighlighted = newValue;
    notifyListeners();
  }
}
