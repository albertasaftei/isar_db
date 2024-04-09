import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_db/models/user.dart';
import 'package:path_provider/path_provider.dart';

class UserDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<User> users = [];

  static Future<void> initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [UserSchema],
      directory: dir.path,
    );
  }

  Future<void> loadUsers() async {
    users.clear();
    users.addAll(await isar.users.where().findAll());
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    log(user.createdAt.toString());
    await isar.writeTxn(
      () async {
        await isar.users.put(user);
      },
    );
    await loadUsers();
  }

  Future<void> deleteUser(Id id) async {
    await isar.writeTxn(
      () async {
        await isar.users.delete(id);
      },
    );
    await loadUsers();
  }

  Future<void> updateUser(Id id, String name, int age) async {
    final existingUser = users.firstWhere((u) => u.id == id);
    existingUser.name = name;
    existingUser.age = age;
    await isar.writeTxn(
      () async {
        await isar.users.put(existingUser);
      },
    );
    await loadUsers();
  }
}
