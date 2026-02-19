import 'package:flutter/cupertino.dart';
import '../../../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/api_manager.util.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/models/upload_file.model.dart';
import '../constants/event_category_api_calls.constant.dart';
import '../models/event_category.model.dart';

class EventCategoryViewModel extends CLBaseViewModel {
  late TextEditingController nameTEC = TextEditingController();
  late String eventCategoryId;
  late EventCategory eventCategory;
  CLMedia? imageFile;

  PagedDataTableController<String, String, EventCategory> eventCategoryTableController = PagedDataTableController<String, String, EventCategory>();

  EventCategoryViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
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
        String eventCategoryId = extraParams;
        eventCategory = await getEventCategory(eventCategoryId);
        nameTEC.text = eventCategory.name;
        imageFile = CLMedia(fileUrl: eventCategory.imageUrl);
        break;
      case VMType.detail:
        String eventCategoryId = extraParams;
        eventCategory = await getEventCategory(eventCategoryId);
        break;
      default:
        break;
    }
    setBusy(false);
  }

  Future<(List<EventCategory>, Pagination?)> getAllEventCategory(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<EventCategory> eventCategoryArray = [];
    ApiCallResponse apiCallResponse =
        await EventCategoryCalls.getAllEventCategory(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final eventCategoriesJsonObject = (apiCallResponse.jsonBody as List);
      eventCategoriesJsonObject.asMap().forEach(
        (index, jsonObject) {
          eventCategoryArray.add(EventCategory.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (eventCategoryArray, apiCallResponse.pagination);
  }

  Future<EventCategory> getEventCategory(eventCategoryId) async {
    late EventCategory downloadedEventCategory;
    ApiCallResponse apiCallResponse = await EventCategoryCalls.getEventCategory(viewContext, eventCategoryId);
    if (apiCallResponse.succeeded) {
      downloadedEventCategory = EventCategory.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedEventCategory;
  }

  Future deleteEventCategory(eventCategoryId) async {
    setBusy(true);
    await EventCategoryCalls.deleteEventCategory(viewContext, eventCategoryId);
    setBusy(false);
  }

  Future createEventCategory() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "name": nameTEC.text,
    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await EventCategoryCalls.createEventCategory(viewContext, params);
    setBusy(false);
  }

  Future updateEventCategory(String eventCategoryId) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "name": nameTEC.text,
    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await EventCategoryCalls.updateEventCategory(viewContext, params, eventCategoryId);
    setBusy(false);
  }
}
