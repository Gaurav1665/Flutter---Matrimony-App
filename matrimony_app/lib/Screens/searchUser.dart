import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrimony_app/Model/userModel.dart';
import 'package:matrimony_app/Provider/userProvider.dart';
import 'package:matrimony_app/Screens/addUser.dart';
import 'package:matrimony_app/Screens/bottomNavigator.dart';
import 'package:provider/provider.dart';
import 'package:slideable/slideable.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  TextEditingController search = TextEditingController();

  List<UserModel> searchedUser = [];

  int? resetSlideIndex = 0;

  @override
  Widget build(BuildContext context) {
  UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
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
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: GestureDetector(
                      onLongPressDown: (val) {
                        setState(() {
                          resetSlideIndex = index;
                        });
                      },
                      child: _listItem(
                        context: context,
                        user: _user,
                        index: index,
                        resetSlide: index == resetSlideIndex ? false : true, 
                      ),
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
  UserProvider userProvider = Provider.of<UserProvider>(context);
    return Slideable(
      resetSlide: resetSlide,
      items: <ActionItems>[
        ActionItems(
          icon: Icon(
            user.isFavorite ? Icons.thumb_up : Icons.thumb_up_outlined,
            color: Colors.blue,
          ),
          onPress: (){
            setState(() {
              user.isFavorite = !user.isFavorite;
            });
          } ,
          backgroudColor: Colors.transparent,
        ),
        ActionItems(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPress: () {
            userProvider.deleteUser(index: index);
          },
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
                child: FutureBuilder<File>(
                  future: userProvider.getImageFileFromDocuments(user.userImage),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } 
                    else if (snapshot.hasError) {
                      return Icon(Icons.error);
                    } 
                    else if (snapshot.hasData) {
                      return Image.file(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    } 
                    else {
                      return Icon(Icons.broken_image);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Name : ",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${user.userFirstName} ${user.userLastName}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit), 
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RootScreen(user: user,),));
              },
            )
          ],
        ),
      ),
    );
  }
}