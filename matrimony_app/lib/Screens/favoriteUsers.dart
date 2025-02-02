import 'dart:io';
import 'package:flutter/material.dart';
import 'package:matrimony_app/Model/userModel.dart';
import 'package:matrimony_app/Provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:slideable/slideable.dart';

class FavoriteUserScreen extends StatefulWidget {
  const FavoriteUserScreen({super.key});

  @override
  State<FavoriteUserScreen> createState() => _FavoriteUserScreenState();
}

class _FavoriteUserScreenState extends State<FavoriteUserScreen> {
  TextEditingController search = TextEditingController();
  Future<List<UserModel>>? searchedUser ;

  @override
  void initState() {
    super.initState();
    searchedUser  = getFavoriteUsers();
  }

  Future<List<UserModel>> getFavoriteUsers() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    List<UserModel> allUsers = await userProvider.fetchUser ();
    return allUsers.where((user) => user.isFavorite).toList();
  }

  void searchUser () {
    setState(() {
      searchedUser  = Provider.of<UserProvider>(context, listen: false).searchUser (searchText: search.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserModel>>(
        future: searchedUser ,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("No Users Found"));

          List<UserModel> users = snapshot.data!;
          return Column(
            children: [
              TextFormField(
                controller: search,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      search.clear();
                      setState(() {
                        searchedUser  = getFavoriteUsers();
                      });
                    },
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  labelText: "Search User",
                ),
                onFieldSubmitted: (value) => searchUser (),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    UserModel _user = users[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: GestureDetector(
                        onLongPressDown: (val) {},
                        child: _listItem(context: context, user: _user),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Slideable _listItem({required BuildContext context, required UserModel user}) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Slideable(
      items: <ActionItems>[
        ActionItems(
          icon: Icon(user.isFavorite ? Icons.thumb_up : Icons.thumb_up_outlined, color: Colors.blue),
          onPress: () async {
            user.isFavorite = await userProvider.likebutton(userId: user.userId!, isFavorite: !user.isFavorite);
            setState(() {});
          },
          backgroudColor: Colors.transparent,
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 214, 214, 214),
          border: Border.all(width: 1, color: Color.fromARGB(124, 158, 158, 158)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FutureBuilder<File>(
                  future: userProvider.getImageFileFromDocuments(user.userImage),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
                    if (snapshot.hasError) return Icon(Icons.error);
                    return snapshot.hasData ? Image.file(snapshot.data!, fit: BoxFit.cover) : Icon(Icons.broken_image);
                  },
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Name :", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 10),
                  Text("${user.userFirstName} ${user.userLastName}", style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}