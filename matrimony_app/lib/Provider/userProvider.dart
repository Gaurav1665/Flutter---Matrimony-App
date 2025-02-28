import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrimony_app/Model/userModel.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {

  //#region SQLDatabase

  // Future<Database> initDatabase() async {
  //   String path = 'asset/database/matrimony.db';
  //   return await openDatabase(path, onCreate: (db, version) async {
  //     await db.execute('''
  //       CREATE TABLE User (
  //         userId INTEGER PRIMARY KEY AUTOINCREMENT,
  //         userFullName TEXT NOT NULL,
  //         userImage TEXT NOT NULL,
  //         userEmail TEXT NOT NULL UNIQUE,
  //         userContact TEXT NOT NULL,
  //         userCity TEXT NOT NULL,
  //         userGender TEXT NOT NULL,
  //         userDOB TEXT NOT NULL,
  //         userHobbies TEXT,
  //         password TEXT NOT NULL,
  //         isFavorite INTEGER NOT NULL DEFAULT 0
  //       );''');
  //   }, version: 1);
  // }

  // Future<List<UserModel>> fetchUser () async {
  //   Database db = await initDatabase();
  //   List<Map<String, dynamic>> userMaps = await db.rawQuery("SELECT * FROM User");
  //   return userMaps.map((userMap) => UserModel(
  //     userId: userMap['userId'],
  //     userFullName: userMap['userFullName'],
  //     userImage: userMap['userImage'],
  //     userEmail: userMap['userEmail'],
  //     userContact: userMap['userContact'],
  //     userCity: userMap['userCity'],
  //     userGender: userMap['userGender'],
  //     userDOB: userMap['userDOB'],
  //     userHobbies: userMap['userHobbies'],
  //     password: userMap['password'],
  //     isFavorite: userMap['isFavorite'] == 1,
  //   )).toList();
  // }

  // Future<void> addUser ({required UserModel user}) async {
  //   Database db = await initDatabase();
  //   await db.insert('User ', {
  //     'userFullName': user.userFullName,
  //     'userImage': user.userImage,
  //     'userEmail': user.userEmail,
  //     'userContact': user.userContact,
  //     'userCity': user.userCity,
  //     'userGender': user.userGender,
  //     'userDOB': user.userDOB,
  //     'userHobbies': user.userHobbies,
  //     'password': user.password,
  //     'isFavorite': 0,
  //   }, conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  // Future<void> deleteUser (int userId) async {
  //   Database db = await initDatabase();
  //   await db.delete('User ', where: 'userId = ?', whereArgs: [userId]);
  // }

  // Future<bool> likebutton({required int userId, required bool isFavorite}) async {
  //   Database db = await initDatabase();
  //   await db.update('User ', {'isFavorite': isFavorite ? 1 : 0}, where: 'userId = ?', whereArgs: [userId]);
  //   return isFavorite;
  // }

  // Future<void> updateUser ({required UserModel user}) async {
  //   Database db = await initDatabase();
  //   await db.update('User ', {
  //     'userFullName': user.userFullName,
  //     'userImage': user.userImage,
  //     'userEmail': user.userEmail,
  //     'userContact': user.userContact,
  //     'userCity': user.userCity,
  //     'userGender': user.userGender,
  //     'userDOB': user.userDOB,
  //     'userHobbies': user.userHobbies,
  //     'password': user.password,
  //     'isFavorite': user.isFavorite,
  //   }, where: 'userId = ?', whereArgs: [user.userId]);
  // }

  // Future<UserModel> fetchUserById(int userId) async {
  //   try {
  //     Database db = await initDatabase();
  //     List<Map<String, dynamic>> userMaps = await db.query('User', where: 'userId = ?', whereArgs: [userId]);
  //     Debugging logs
  //     print('Fetched User for ID $userId: $userMaps');
  //     if (userMaps.isNotEmpty) {
  //       return UserModel(
  //         userFullName: userMaps.first["userFullName"], 
  //         userImage: userMaps.first["userImage"], 
  //         userEmail: userMaps.first["userEmail"], 
  //         userContact: userMaps.first["userContact"], 
  //         userCity: userMaps.first["userCity"], 
  //         userGender: userMaps.first["userGender"], 
  //         userDOB: userMaps.first["userDOB"], 
  //         userHobbies: userMaps.first["userHobbies"], 
  //         password: userMaps.first["password"], 
  //         isFavorite: userMaps.first["isFavorite"]==1 ? true : false
  //       );
  //     } else {
  //       print('No user found for ID $userId');
  //       throw Exception('User not found');
  //     }
  //   } catch (e) {
  //     print('Error fetching user: $e');
  //     throw Exception('Error fetching user: $e');
  //   }
  // }

  //#endregion

  //#region MockAPI

  Future<List<UserModel>> fetchUser() async {
    final response = await http.get(Uri.parse("https://67c1d88661d8935867e47956.mockapi.io/user/users"));
    
    if (response.statusCode == 200) {
      List<dynamic> userMaps = jsonDecode(response.body);
      return userMaps.map((userMap) => UserModel(
        userId: int.parse(userMap['userId']),
        userFullName: userMap['userFullName'],
        userImage: userMap['userImage'],
        userEmail: userMap['userEmail'],
        userContact: userMap['userContact'],
        userCity: userMap['userCity'],
        userGender: userMap['userGender'],
        userDOB: userMap['userDOB'],
        userHobbies: userMap['userHobbies'],
        password: userMap['password'],
        isFavorite: userMap['isFavorite'],
      )).toList();
    } else {
      return [];
    }
  }

  Future<UserModel> fetchUserById(int userId) async {
    
    final response = await http.get(Uri.parse('https://67c1d88661d8935867e47956.mockapi.io/user/users/$userId'));

    if (response.statusCode == 200) {
      final userMap = jsonDecode(response.body);
      return UserModel(
        userId: int.parse(userMap['userId']),
        userFullName: userMap['userFullName'],
        userImage: userMap['userImage'],
        userEmail: userMap['userEmail'],
        userContact: userMap['userContact'],
        userCity: userMap['userCity'],
        userGender: userMap['userGender'],
        userDOB: userMap['userDOB'],
        userHobbies: userMap['userHobbies'],
        password: userMap['password'],
        isFavorite: userMap["isFavorite"],
      );
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> addUser({required UserModel user}) async {
    final response = await http.post(
      Uri.parse("https://67c1d88661d8935867e47956.mockapi.io/user/users"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
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
      }),
    );
    Fluttertoast.showToast(msg: "User Added Successfully", backgroundColor: Colors.greenAccent);

    if (response.statusCode != 201) {
      throw Exception('Failed to add user');
    }
  }

  Future<void> updateUser({required UserModel user}) async {
    final response = await http.put(
      Uri.parse('https://67c1d88661d8935867e47956.mockapi.io/user/users/${user.userId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
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
      }),
    );
    Fluttertoast.showToast(msg: "User Updated Successfully", backgroundColor: Colors.greenAccent);

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int userId) async {
    final response = await http.delete(Uri.parse('https://67c1d88661d8935867e47956.mockapi.io/user/users/$userId'),);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

    Future<bool> likebutton({required int userId, required bool isFavorite}) async {
    final response = await http.patch(
      Uri.parse('https://67c1d88661d8935867e47956.mockapi.io/user/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'isFavorite': isFavorite,
      }),
    );

    if (response.statusCode == 200) {
      return isFavorite;
    } else {
      throw Exception(response.statusCode);
    }
  }
  //#endregion
}