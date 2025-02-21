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
    List<UserModel> favorite = allUsers.where((user) => user.isFavorite).toList();
    print(favorite.toList());
    return favorite;
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
              onChanged: onSearchTextChanged,
            ),
            const SizedBox(height: 5),
            FutureBuilder<List<UserModel>>(
              future: searchedUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                if (snapshot.hasError)
                  return Center(child: Text("Error: ${snapshot.error}"));

                if (snapshot.data == null || snapshot.data!.isEmpty)
                  return Expanded(child: Center(child: Text("No User Found")));

                List<UserModel> users = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      UserModel _user = users[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: GestureDetector(
                          onLongPressDown: (val) => setState(() {}),
                          child: _listItem(context: context, user: _user),
                        ),
                      );
                    },
                  ),
                );
              }
            ),
            const SizedBox(height: 5),
            Center(child: Text("Note: swipe left to like or dislike user",style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),)
          ],
        ),
      ),
    );
  }



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
    Size size = MediaQuery.of(context).size;

    return Slideable(
      items: <ActionItems>[
        ActionItems(
          icon: Icon(user.isFavorite ? Icons.thumb_up : Icons.thumb_up_outlined, color: Colors.blue),
          onPress: () async {
            user.isFavorite = await userProvider.likebutton(userId: user.userId!, isFavorite: !user.isFavorite);
            setState(() {
              searchedUser = getFavoriteUsers();
            });
          },
          backgroudColor: Colors.transparent,
        ),
      ],
      child: Card(
        elevation: 4,
        child: Container(
          height: size.height*0.13,
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: size.height*0.1,
                width: size.height*0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: Colors.white),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(File(user.userImage), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 25),
                        const SizedBox(width: 8),
                        Text(
                          user.userGender=="Male" ? "♂" : "♀",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.location_city, size: 25),
                      ],
                    ),
                    const SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.userFullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              user.userGender,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(" | "),
                            const SizedBox(width: 5),
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
