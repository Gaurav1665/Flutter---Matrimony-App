import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrimony_app/Model/userModel.dart';
import 'package:matrimony_app/Provider/userProvider.dart';
import 'package:slideable/slideable.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  TextEditingController search = TextEditingController();

  List<UserModel> searchedUser = [];

  int? resetSlideIndex = 0;

  UserProvider userProvider = UserProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Matrimony App"),),
      body: userProvider.userList.isEmpty 
      ? Center(child: Text("No User Found"))
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: search,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  
                },
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: "Search User",
              hintText: "Search User",
            ),
            onFieldSubmitted: (value) {
              setState(() {
                searchedUser = userProvider.searchUser(searchText: value);
              });
            },
          ),
          const SizedBox(height: 5),
          if(search.text.isNotEmpty && searchedUser.isEmpty)...[
            Center(child: Text("No User Found")),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: search.text.isNotEmpty ? searchedUser.length : userProvider.userList.length,
              itemBuilder: (context, index) {
                UserModel _user = search.text.isNotEmpty ? searchedUser[index] : userProvider.userList[index];
                  return GestureDetector(
                    onLongPressDown: (val) {
                      // This allows you the time taken for a user to slide upon the widget in the list.
                      // NB: Using the onTap or onHorizontalDragStart seemed to have caused a seizure in the widget, hence my resulting to onLongPressDown
                      setState(() {
                        // This updates the widget, and inturn rebuilds it, thereby notifying the Slidable widget to close an already slide item
                        resetSlideIndex = index;
                      });
                    },
                    child: _listItem(
                      context: context,
                      user: _user,
                      index: index,
                      resetSlide: index == resetSlideIndex ? false : true, 
                      // Reverse engineering the notion, meaning the Slidable widget will close all slid item, except one with false, i.e the currently slide item
                    ),
                  );
              },
            )
          )
        ],
      )
    );
  }
  Slideable _listItem({
    required BuildContext context,
    required UserModel user,
    required int index,
    required bool resetSlide,
  }) {
    return Slideable(
      resetSlide: resetSlide,
      items: <ActionItems>[
        ActionItems(
          icon: const Icon(
            Icons.thumb_up,
            color: Colors.blue,
          ),
          onPress: (){} ,
          backgroudColor: Colors.transparent,
        ),
        ActionItems(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPress: () {},
          backgroudColor: Colors.transparent,
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 214, 214, 214),
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(124, 158, 158, 158),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color: Colors.white,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.file(
                  userProvider.getImageFileFromDocuments(user.userImage) as File,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.userFirstName + " " + user.userLastName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}