import 'package:flutter/material.dart';

class UserModel with ChangeNotifier{

  final int userId, isFavorite;

  final String userFirstName, userLastName, userImage, userEmail, userContact, userCity, userGender, userDOB, userHobbies, password, confirmPassword;

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
    required this.confirmPassword,
    required this.isFavorite
  });

}