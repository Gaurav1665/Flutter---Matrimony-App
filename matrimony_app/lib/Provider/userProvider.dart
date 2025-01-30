import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrimony_app/Model/userModel.dart';

class UserProvider with ChangeNotifier{
  List<UserModel> userList = [];
  int index = 0;

  Future<File> getImageFileFromDocuments(String fileName) async {
    final imageFile = File(fileName);
    return imageFile;
  }

  void addUser({required UserModel user}){
    userList.add(user);
    index++;
    notifyListeners();
  }

  void deleteUser({required int index}){
    userList.removeAt(index);
    notifyListeners();
  }

  void updateUser({required int index, required UserModel user}){
    int userIndex = userList.indexWhere((user) => user.userId == index);

    if(userIndex!=-1){
      userList[userIndex].userFirstName = user.userFirstName;
      userList[userIndex].userLastName = user.userLastName;
      userList[userIndex].userEmail = user.userEmail;
      userList[userIndex].userContact = user.userContact;
      userList[userIndex].userCity = user.userCity;
      userList[userIndex].userGender = user.userGender;
      userList[userIndex].userDOB = user.userDOB;
      userList[userIndex].userHobbies = user.userHobbies;
      userList[userIndex].userImage = user.userImage;
    }
    else{
      print("User not Found");
    }
  }

  List<UserModel> searchUser({String? searchText}){
    return userList.where((element) => (element.userFirstName.toLowerCase()==searchText!.toLowerCase()) || (element.userLastName.toLowerCase()==searchText.toLowerCase())).toList();
  }
}