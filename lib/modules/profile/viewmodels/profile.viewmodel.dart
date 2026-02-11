import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_dsh/ui/widgets/cl_media_viewer.widget.dart';
import '../../../../utils/base.viewmodel.dart';
import '../../../../utils/models/pageaction.model.dart';
import '../../../utils/api_manager.util.dart';
import '../../../utils/models/city.model.dart';
import '../../../utils/models/upload_file.model.dart';
import '../../users/models/user.model.dart';
import '../constants/profile_api_calls.costant.dart';

class ProfileViewModel extends CLBaseViewModel {
  late String userId;
  late User user;
  City? selectedCity;
  DateTime? selectedDate;
  String? selectedGender;
  CLMedia? imageFile;
  late TextEditingController firstNameTEC = TextEditingController();
  late TextEditingController lastNameTEC = TextEditingController();
  late TextEditingController emailTEC = TextEditingController();
  late TextEditingController phoneTEC = TextEditingController();
  late TextEditingController birthDateTEC = TextEditingController();
  late TextEditingController passwordTEC = TextEditingController();
  late TextEditingController genderTEC = TextEditingController();
  late TextEditingController capTEC = TextEditingController();

  ProfileViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  Future<(List<City>, Object?)> Function({Map<String, dynamic>? orderBy, int? page, int? perPage, Map<String, dynamic>? searchBy})? get getAllCity => null;

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    switch (viewModelType) {
      case VMType.list:
        //String userId = extraParams as String;
        //user = await getProfile(userId);
        break;
      case VMType.create:
        break;
      case VMType.edit:
        String userId = extraParams as String;
        user = await getProfile(userId);
        firstNameTEC.text = user.userData.firstName;
        lastNameTEC.text = user.userData.lastName;
        selectedDate = user.userData.birthDate;
        birthDateTEC.text = user.userData.formattedDate;
        selectedCity = user.userData.cityOfResidence;
        selectedGender = user.userData.gender;
        emailTEC.text = user.email;
        capTEC.text = user.userData.cap;
        phoneTEC.text = user.phone ?? "";
        imageFile = CLMedia(fileUrl: user.userData.imageUrl);
        break;
      case VMType.detail:
        String userId = extraParams as String;
        break;
      default:
        break;
    }
    setBusy(false);
  }

  Future updateProfile(String userId) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "firstName": firstNameTEC.text,
      "lastName": lastNameTEC.text,
      "email": emailTEC.text,
      "phone": phoneTEC.text,
      "gender": selectedGender,
      "cityOfResidenceId": selectedCity?.id,
      'birthDate': selectedDate?.toUtc().toIso8601String(),
      "cap": capTEC.text,
    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await ProfileCalls.updateUser(viewContext, params, userId);
    setBusy(false);
  }

  Future<User> getProfile(userId) async {
    late User downloadedProfile;
    ApiCallResponse apiCallResponse = await ProfileCalls.getUser(viewContext, userId);
    if (apiCallResponse.succeeded) {
      downloadedProfile = User.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedProfile;
  }

}
