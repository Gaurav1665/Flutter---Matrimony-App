import 'package:flutter/material.dart';
import 'package:matrimony_app/Model/userModel.dart';
import 'package:sqflite/sqflite.dart';

class UserProvider with ChangeNotifier {
  Future<Database> initDatabase() async {
    String path = 'asset/database/matrimony.db';
    return await openDatabase(path, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE User (
          userId INTEGER PRIMARY KEY AUTOINCREMENT,
          userFullName TEXT NOT NULL,
          userImage TEXT NOT NULL,
          userEmail TEXT NOT NULL UNIQUE,
          userContact TEXT NOT NULL,
          userCity TEXT NOT NULL,
          userGender TEXT NOT NULL,
          userDOB TEXT NOT NULL,
          userHobbies TEXT,
          password TEXT NOT NULL,
          isFavorite INTEGER NOT NULL DEFAULT 0
        );''');
    }, version: 1);
  }

  Future<List<UserModel>> fetchUser () async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> userMaps = await db.rawQuery("SELECT * FROM User");
    return userMaps.map((userMap) => UserModel(
      userId: userMap['userId'],
      userFullName: userMap['userFullName'],
      userImage: userMap['userImage'],
      userEmail: userMap['userEmail'],
      userContact: userMap['userContact'],
      userCity: userMap['userCity'],
      userGender: userMap['userGender'],
      userDOB: userMap['userDOB'],
      userHobbies: userMap['userHobbies'],
      password: userMap['password'],
      isFavorite: userMap['isFavorite'] == 1,
    )).toList();
  }

  Future<void> addUser ({required UserModel user}) async {
    Database db = await initDatabase();
    await db.insert('User ', {
      'userFullName': user.userFullName,
      'userImage': user.userImage,
      'userEmail': user.userEmail,
      'userContact': user.userContact,
      'userCity': user.userCity,
      'userGender': user.userGender,
      'userDOB': user.userDOB,
      'userHobbies': user.userHobbies,
      'password': user.password,
      'isFavorite': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteUser (int userId) async {
    Database db = await initDatabase();
    await db.delete('User ', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<bool> likebutton({required int userId, required bool isFavorite}) async {
    Database db = await initDatabase();
    await db.update('User ', {'isFavorite': isFavorite ? 1 : 0}, where: 'userId = ?', whereArgs: [userId]);
    return isFavorite;
  }

  Future<void> updateUser ({required UserModel user}) async {
    Database db = await initDatabase();
    await db.update('User ', {
      'userFullName': user.userFullName,
      'userImage': user.userImage,
      'userEmail': user.userEmail,
      'userContact': user.userContact,
      'userCity': user.userCity,
      'userGender': user.userGender,
      'userDOB': user.userDOB,
      'userHobbies': user.userHobbies,
      'password': user.password,
      'isFavorite': user.isFavorite,
    }, where: 'userId = ?', whereArgs: [user.userId]);
  }

  Future<UserModel> fetchUserById(int userId) async {
    try {
      Database db = await initDatabase();
      List<Map<String, dynamic>> userMaps = await db.query('User', where: 'userId = ?', whereArgs: [userId]);

      // Debugging logs
      print('Fetched User for ID $userId: $userMaps');

      if (userMaps.isNotEmpty) {
        return UserModel(
          userFullName: userMaps.first["userFullName"], 
          userImage: userMaps.first["userImage"], 
          userEmail: userMaps.first["userEmail"], 
          userContact: userMaps.first["userContact"], 
          userCity: userMaps.first["userCity"], 
          userGender: userMaps.first["userGender"], 
          userDOB: userMaps.first["userDOB"], 
          userHobbies: userMaps.first["userHobbies"], 
          password: userMaps.first["password"], 
          isFavorite: userMaps.first["isFavorite"]==1 ? true : false
        );
      } else {
        print('No user found for ID $userId');
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
      throw Exception('Error fetching user: $e');
    }
  }
}