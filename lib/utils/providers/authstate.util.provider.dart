import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../app.constants.dart';

import '../../modules/users/models/user.model.dart';
import '../app_database.util.dart';

class AuthState extends ChangeNotifier {
  static final AuthState _instance = AuthState._internal();

  factory AuthState() {
    return _instance;
  }

  AuthState._internal() {
    _loadCurrentUser();
  }

  User? currentUser;

  bool get isAuthenticated => currentUser != null;

  User? get getCurrentUser => currentUser;

  void setCurrentUser(User? user) {
    currentUser = user;
    notifyListeners();
  }

  Future saveCurrentUser(User user) async {
    await AppDatabase.storeUser(user);
    currentUser = user;
    notifyListeners();
  }

  Future setUnauthenticated() async {
    await AppDatabase.deleteCurrentUser();
    currentUser = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    currentUser = await AppDatabase.getCurrentUser();
    notifyListeners();
  }
  bool hasPermission(String permissionName) {
    var flag = false;
    if (currentUser == null){
      flag = false;
      return flag;
    }
    //Controllo sui permessi associati al ruolo tramite rolePermissions
    for (var rolePermission in currentUser!.role.rolePermissions) {
      if (rolePermission.permission.slug == permissionName) {
        flag =  true;
      }
    }

    // Controllo sui permessi specifici dell'utente
    for (var userPermission in currentUser!.userPermissions) {
      if (userPermission.permission?.slug == permissionName) {
        flag = true;
      }
    }

    return flag;
  }
}
