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
  Future<List<UserModel>>? searchedUser;

  @override
  void initState() {
    super.initState();
    searchedUser = getFavoriteUsers();
  }

  Future<List<UserModel>> getFavoriteUsers() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    List<UserModel> allUsers = await userProvider.fetchUser();
    return allUsers.where((user) => user.isFavorite).toList();
  }

  Future<List<UserModel>> searchUser({String? searchText}) async {
    List<UserModel> users = await getFavoriteUsers();
    if (searchText == null || searchText.isEmpty) return users;

    return users.where((user) =>
      user.userFullName.toLowerCase().contains(searchText.toLowerCase()) ||
      user.userCity.toLowerCase().contains(searchText.toLowerCase()) ||
      user.userEmail.toLowerCase().contains(searchText.toLowerCase())
    ).toList();
  }

  void onSearchTextChanged(String value) {
    setState(() {
      searchedUser = searchUser(searchText: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
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
                      searchedUser = getFavoriteUsers();
                    });
                  },
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                labelText: "Search User",
              ),
              onChanged: onSearchTextChanged, // Trigger search on text change
            ),
            const SizedBox(height: 5),
            FutureBuilder<List<UserModel>>(
              future: searchedUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasError)
                  return Center(child: Text("Error: ${snapshot.error}"));
                if (!snapshot.hasData || snapshot.data!.isEmpty)
                  return Center(child: Text("No Users Found"));

                List<UserModel> users = snapshot.data!;
                return Column(
                  children: [
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
                    Text("slide left to like or delete user")
                  ],
                );
              },
            ),
          ],
        ),
      )
    );
  }



  // This function displays the user details in a slideable item
  Slideable _listItem({required BuildContext context, required UserModel user}) {
    int calculateAge(DateTime dob) {
      DateTime today = DateTime.now();
      int age = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }
      return age;
    }

    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Slideable(
      items: <ActionItems>[
        ActionItems(
          icon: Icon(user.isFavorite ? Icons.thumb_up : Icons.thumb_up_outlined, color: Colors.blue),
          onPress: () async {
            user.isFavorite = await userProvider.likebutton(userId: user.userId!, isFavorite: !user.isFavorite);
            setState(() {
              searchedUser = getFavoriteUsers(); // Refresh after favorite toggle
            });
          },
          backgroudColor: Colors.transparent,
        ),
      ],
      child: Card(
        elevation: 3,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Color.fromARGB(124, 158, 158, 158)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User's profile image
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Colors.white),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(File(user.userImage)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User's full name and age
                    Row(
                      children: [
                        Icon(Icons.person, size: 25),
                        const SizedBox(width: 8),
                        Text(
                          user.userFullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(" | "),
                        const SizedBox(width: 10),
                        Text(
                          "${calculateAge(DateTime.parse(user.userDOB))} years old",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // User's city
                    Row(
                      children: [
                        Icon(Icons.location_city, size: 25),
                        const SizedBox(width: 8),
                        Text(
                          user.userCity,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
