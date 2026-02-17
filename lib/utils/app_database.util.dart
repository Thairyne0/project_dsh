import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

import '../modules/users/models/user.model.dart';

class AppDatabase {
  static late DatabaseClient db;

  static Future<DatabaseClient?> prepareDatabase() async {
    String dbPath = 'webautomotive.db';
    if (kIsWeb) {
      db = await databaseFactoryWeb.openDatabase(dbPath);
    } else {
      Directory appDocDir = await getApplicationSupportDirectory();
      db = await databaseFactoryIo.openDatabase(appDocDir.path + dbPath);
    }
    return db;
  }

  static Future storeUser(User user) async {
    var storeUser = intMapStoreFactory.store('users');
    await storeUser.add(AppDatabase.db, user.toMap());
  }

  static Future<User?> getCurrentUser() async {
    var storeUser = intMapStoreFactory.store('users');
    List<RecordSnapshot<int, Map<String, Object?>>> userMap =
    await storeUser.find(db);

    User? user;
    if (userMap.isNotEmpty) {
      user = User.fromJson(jsonObject: userMap.first.value);
    }
    return user;
  }

  static Future<void> deleteCurrentUser() async {
    var storeUser = intMapStoreFactory.store('users');
    await storeUser.delete(db);
  }

  static Future deleteCurrentUserModel() async {
    var storeUser = intMapStoreFactory.store('usermodel');
    await storeUser.delete(db);
  }
}