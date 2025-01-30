import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrimony_app/Model/userModel.dart';
import 'package:path_provider/path_provider.dart';

class UserProvider with ChangeNotifier{
  List<UserModel> userList = [
    UserModel(
      userId: 1,
      userFirstName: "John",
      userLastName: "Doe",
      userImage: "assets/Images/User/demo.png",
      userEmail: "john.doe@gmail.com",
      userContact: "9876543210",
      userCity: "New York",
      userGender: "Male",
      userDOB: "1990-05-15 00:00:00.000",
      userHobbies: "[Reading, Traveling]",
      password: "john@123",
      confirmPassword: "john@123",
      isFavorite: 0
    ),
    UserModel(
      userId: 2,
      userFirstName: "Jane",
      userLastName: "Smith",
      userImage: "assets/Images/User/demo.png",
      userEmail: "jane.smith@gmail.com",
      userContact: "1234567890",
      userCity: "Los Angeles",
      userGender: "Female",
      userDOB: "1995-08-22 00:00:00.000",
      userHobbies: "[Music, Sports]",
      password: "jane@123",
      confirmPassword: "jane@123",
      isFavorite: 1
    ),
    UserModel(
      userId: 3,
      userFirstName: "Alex",
      userLastName: "Johnson",
      userImage: "assets/Images/User/demo.png",
      userEmail: "alex.johnson@gmail.com",
      userContact: "5647382910",
      userCity: "Chicago",
      userGender: "Male",
      userDOB: "1988-12-12 00:00:00.000",
      userHobbies: "[Gaming, Hiking]",
      password: "alex@123",
      confirmPassword: "alex@123",
      isFavorite: 1
    ),
    UserModel(
      userId: 4,
      userFirstName: "Emily",
      userLastName: "Williams",
      userImage: "assets/Images/User/demo.png",
      userEmail: "emily.williams@gmail.com",
      userContact: "3216549870",
      userCity: "San Francisco",
      userGender: "Female",
      userDOB: "1992-07-09 00:00:00.000",
      userHobbies: "[Cooking, Yoga]",
      password: "emily@123",
      confirmPassword: "emily@123",
      isFavorite: 0
    ),
    UserModel(
      userId: 5,
      userFirstName: "Michael",
      userLastName: "Brown",
      userImage: "assets/Images/User/demo.png",
      userEmail: "michael.brown@gmail.com",
      userContact: "8765432109",
      userCity: "Houston",
      userGender: "Male",
      userDOB: "1985-02-25 00:00:00.000",
      userHobbies: "[Photography, Reading]",
      password: "michael@123",
      confirmPassword: "michael@123",
      isFavorite: 1
    ),
  ];

  Future<File> getImageFileFromDocuments(String fileName) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final imageFile = File('${appDir.path}/SavedImages/User/$fileName');
    return imageFile;
  }

  List<UserModel> searchUser({String? searchText}){
    return userList.where((element) => (element.userFirstName.toLowerCase()==searchText!.toLowerCase()) || (element.userLastName.toLowerCase()==searchText.toLowerCase())).toList();
  }
}