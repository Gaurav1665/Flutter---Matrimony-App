import 'dart:io';
import 'package:flutter/material.dart';
import 'package:matrimony_app/Model/userModel.dart';
import 'package:matrimony_app/Provider/userProvider.dart';
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
  Future<List<UserModel>>? searchedUser;

  @override
  void initState() {
    super.initState();
    searchedUser = getList();
  }

  Future<List<UserModel>> getList() async {
    return await Provider.of<UserProvider>(context, listen: false).fetchUser();
  }

  Future<List<UserModel>> searchUser({String? searchText}) async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false); // Using listen: false
    List<UserModel> users = await userProvider.fetchUser();
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
                      searchedUser = getList();
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
                          onTap: () {
                            _showUserInfoDialog(context, _user);
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            ),
            const SizedBox(height: 5),
            Center(child: Text("Note: swipe left to like or delete user",style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),)
          ],
        ),
      ),
    );
  }

  void _showUserInfoDialog(BuildContext context, UserModel user) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: size.width * 0.3,
                width: size.width * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(File(user.userImage), fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 10),
              Text("${user.userFullName}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildTableRow("Email:", user.userEmail),
              _buildTableRow("Contact:", user.userContact),
              _buildTableRow("City:", user.userCity),
              _buildTableRow("Gender:", user.userGender),
              _buildTableRow("DOB:", user.userDOB),
              _buildTableRow("Hobbies:", user.userHobbies),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RootScreen(userId: user.userId!,),),);
                },
                child: Text("Edit"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[700],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Colors.blueGrey[600],
              ),
            ),
          ),
        ],
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

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false); // Using listen: false
    Size size = MediaQuery.of(context).size;

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
        ActionItems(
          icon: Icon(Icons.delete, color: Colors.red),
          onPress: () async {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Warning"),
                  content: Text("Are you sure you want to delete this user?"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("No")
                    ),
                    ElevatedButton(
                        onPressed: () async{
                          await userProvider.deleteUser(user.userId!);
                          onSearchTextChanged(search.text);
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text("Yes")
                    ),
                  ],
                );
              },
            );
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
