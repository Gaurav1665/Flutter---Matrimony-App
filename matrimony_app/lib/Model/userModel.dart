import 'package:flutter/material.dart';

class UserModel with ChangeNotifier{

  int userId, isFavorite;

  String userFirstName, userLastName, userImage, userEmail, userContact, userCity, userGender, userDOB, userHobbies, password;

  UserModel({
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.userImage,
    required this.userEmail,
    required this.userContact,
    required this.userCity,
    required this.userGender,
    required this.userDOB,
    required this.userHobbies,
    required this.password,
    required this.isFavorite
  });

}