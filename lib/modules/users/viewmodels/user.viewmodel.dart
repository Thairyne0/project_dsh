import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:project_dsh/modules/users/modules/role_permission/models/user_permission.model.dart';
import '../../../../ui/widgets/alertmanager/alert_manager.dart';
import '../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../utils/api_manager.util.dart';
import '../../../../utils/base.viewmodel.dart';
import '../../../../utils/models/pageaction.model.dart';
import '../../../utils/models/city.model.dart';
import '../constants/cities_api_calls.costant.dart';
import '../constants/users_api_calls.costant.dart';
import '../models/user.model.dart';
import '../modules/role_permission/constants/role_permission_api_calls.constant.dart';
import '../modules/role_permission/models/permission.model.dart';
import '../modules/role_permission/models/role.model.dart';

class UserViewModel extends CLBaseViewModel {
  static List<User> users = [];
  late TextEditingController firstNameTEC = TextEditingController();
  late TextEditingController lastNameTEC = TextEditingController();
  late TextEditingController emailTEC = TextEditingController();
  late TextEditingController passwordTEC = TextEditingController();
  late TextEditingController phoneTEC = TextEditingController();
  late TextEditingController genderTEC = TextEditingController();
  late TextEditingController birthDateTEC = TextEditingController();
  late TextEditingController cityOfResidenceTEC = TextEditingController();
  late TextEditingController capTEC = TextEditingController();
  String? selectedGender;
  City? selectedCity;
  List<String> zips = [];
  String? selectedZip;
  Role? selectedRole;
  DateTime? selectedDate;
  late User user;
  List<Permission> selectedPermissions = [];

  PagedDataTableController<String, String, User> userTableController = PagedDataTableController<String, String, User>();
  PagedDataTableController<String, String, UserPermission> userPermissionTableController = PagedDataTableController<String, String, UserPermission>();

  UserViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
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
        String userId = extraParams as String;
        user = await getUser(userId);
        firstNameTEC.text = user.userData.firstName;
        lastNameTEC.text = user.userData.lastName;
        selectedDate = user.userData.birthDate;
        birthDateTEC.text = user.userData.formattedDate;
        selectedCity = user.userData.cityOfResidence;
        selectedZip = user.userData.cap;
        selectedGender = user.userData.gender;
        emailTEC.text = user.email;
        capTEC.text = user.userData.cap;
        selectedRole = user.role;
        phoneTEC.text = user.phone ?? "";
        break;
      case VMType.detail:
        String userId = extraParams as String;
        user = await getUser(userId);
        break;
      case VMType.other:
        String userId = extraParams as String;
        user = await getUser(userId);
        firstNameTEC.text = user.userData.firstName;
        lastNameTEC.text = user.userData.lastName;
        break;
      default:
        break;
    }
    setBusy(false);
  }

  Future<(List<User>, Pagination?)> getAllUser({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<User> userArray = [];
    ApiCallResponse apiCallResponse = await UserCalls.getAllUser(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final usersJsonObject = (apiCallResponse.jsonBody as List);
      usersJsonObject.asMap().forEach(
        (index, jsonObject) {
          userArray.add(User.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (userArray, apiCallResponse.pagination);
  }

  Future<(List<UserPermission>, Pagination?)> getAllUserPermission(
      {int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    searchBy ??= {};
    searchBy.addAll({"userId": user.id});
    late List<UserPermission> userPermissionsArray = [];
    ApiCallResponse apiCallResponse =
        await UserCalls.getAllUserPermission(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final userPermissionsJsonObject = (apiCallResponse.jsonBody as List);
      userPermissionsJsonObject.asMap().forEach(
        (index, jsonObject) {
          userPermissionsArray.add(UserPermission.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (userPermissionsArray, apiCallResponse.pagination);
  }

  Future<(List<Role>, Pagination?)> getAllRole({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<Role> rolesArray = [];
    ApiCallResponse apiCallResponse = await RoleCalls.getAllRole(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final rolesJsonObject = (apiCallResponse.jsonBody as List);
      rolesJsonObject.asMap().forEach(
        (index, jsonObject) {
          rolesArray.add(Role.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (rolesArray, apiCallResponse.pagination);
  }

  Future<(List<City>, Pagination?)> getAllCity({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<City> citiesArray = [];
    ApiCallResponse apiCallResponse = await CityCalls.getAllCity(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final citiesJsonObject = (apiCallResponse.jsonBody as List);
      citiesJsonObject.asMap().forEach(
        (index, jsonObject) {
          citiesArray.add(City.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (citiesArray, apiCallResponse.pagination);
  }

  Future<User> getUser(userId) async {
    late User downloadedUser;
    ApiCallResponse apiCallResponse = await UserCalls.getUser(viewContext, userId);
    if (apiCallResponse.succeeded) {
      downloadedUser = User.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedUser;
  }

  Future deleteUser(userId) async {
    setBusy(true);
    ApiCallResponse apiCallResponse = await UserCalls.deleteUser(viewContext, userId);
    setBusy(false);
  }

  Future createUser() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "firstName": firstNameTEC.text,
      "lastName": lastNameTEC.text,
      "email": emailTEC.text,
      "password": passwordTEC.text,
      "phone": phoneTEC.text,
      "gender": selectedGender,
      "cityOfResidenceId": selectedCity?.id,
      'birthDate': selectedDate?.toUtc().toIso8601String(),
      'cap': selectedZip,
      "roleId": selectedRole?.id,
    };
    ApiCallResponse apiCallResponse = await UserCalls.createUser(viewContext, params);
    setBusy(false);
  }

  Future updateUser(String userId) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "firstName": firstNameTEC.text,
      "lastName": lastNameTEC.text,
      "email": emailTEC.text,
      "phone": phoneTEC.text,
      "gender": selectedGender,
      "cityOfResidenceId": selectedCity?.id,
      'birthDate': selectedDate?.toUtc().toIso8601String(),
      'cap': selectedZip,
      "roleId": selectedRole?.id,
    };
    ApiCallResponse apiCallResponse = await UserCalls.updateUser(viewContext, params, userId);
    setBusy(false);
  }

  Future attachPermissionToUser() async {
    setBusy(true);
    Map<String, dynamic> params = {"userId": user.id, "permissionIds": selectedPermissions.map((permission) => permission.id).toList()};
    ApiCallResponse apiCallResponse = await PermissionCalls.attachPermissionToUser(viewContext, params);
    setBusy(false);
  }

  Future detachPermissionToUser(String userId) async {
    setBusy(true);
    ApiCallResponse apiCallResponse = await PermissionCalls.detachPermissionFromUser(viewContext, userId);
    setBusy(false);
  }

  Future<(List<Permission>, Pagination?)> getAllPermissionByUser({
    int? page,
    int? perPage,
    Map<String, dynamic>? searchBy,
    Map<String, dynamic>? orderBy,
  }) async {
    searchBy ??= {};
    searchBy.addAll({"userPermissions:none:userId": user.id});
    late List<Permission> permissionsByUserArray = [];
    ApiCallResponse apiCallResponse =
        await PermissionCalls.getAllPermission(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final permissionsByUserJsonArray = (apiCallResponse.jsonBody as List);
      permissionsByUserJsonArray.forEach((jsonObject) {
        permissionsByUserArray.add(Permission.fromJson(jsonObject: jsonObject));
      });
    }
    return (permissionsByUserArray, apiCallResponse.pagination);
  }

  Future<void> downloadUsersExcel({
    required bool photoFilter,
    required bool marketingFilter,
    required bool newsletterFilter,
    DateTimeRange? dateRange,
  }) async {
    try {
      final params = <String, dynamic>{
        "photoPolicyAcceptance": photoFilter,
        "marketingPolicyAcceptance": marketingFilter,
        "newsletterPolicyAcceptance": newsletterFilter,
      };

      if (dateRange != null) {
        params["startDate"] = dateRange.start.toIso8601String();
        params["endDate"] = dateRange.end.toIso8601String();
      }

      ApiCallResponse apiCallResponse = await UserCalls.downloadUsersExcel(viewContext, params);

      if (apiCallResponse.succeeded) {
        if (apiCallResponse.jsonBody == null) {
          if (viewContext.mounted) {
            AlertManager.showDanger('Errore!', 'Risposta del server non valida.');
          }
          return;
        }

        if (apiCallResponse.jsonBody["file"] == null || apiCallResponse.jsonBody["fileName"] == null) {
          if (viewContext.mounted) {
            AlertManager.showDanger('Errore!', 'Dati del file mancanti nella risposta.');
          }
          return;
        }

        Uint8List bytes = base64Decode(apiCallResponse.jsonBody["file"]);

        if (!kIsWeb) {
          String? filePath = await FilePicker.platform.saveFile(
            dialogTitle: 'Seleziona il percorso per salvare il file',
            fileName: apiCallResponse.jsonBody["fileName"],
          );
          if (filePath != null) {
            File file = File(filePath);
            await file.writeAsBytes(bytes);
            if (viewContext.mounted) {
              AlertManager.showSuccess('Completato!', 'File scaricato con successo.');
            }
          } else {
            if (viewContext.mounted) {
              AlertManager.showDanger('Errore!', 'Il download del file è stato annullato.');
            }
          }
        } else {
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.AnchorElement(href: url)
            ..setAttribute("download", apiCallResponse.jsonBody["fileName"].toString())
            ..click();
          html.Url.revokeObjectUrl(url);
          if (viewContext.mounted) {
            AlertManager.showSuccess('Completato!', 'File scaricato con successo.');
          }
        }
      } else {
        if (viewContext.mounted) {
          String errorMessage = apiCallResponse.error?.message ?? 'Impossibile scaricare gli utenti.';
          if (apiCallResponse.error?.details != null) {
            errorMessage += '\nDettagli: ${apiCallResponse.error!.details}';
          }
          AlertManager.showDanger('Errore!', errorMessage);
        }
      }
    } catch (e) {
      if (viewContext.mounted) {
        AlertManager.showDanger('Errore!', 'Si è verificato un errore: ${e.toString()}');
      }
    }
  }
}
