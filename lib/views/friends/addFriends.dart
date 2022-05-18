// ignore: file_names
import 'package:billshare/constants.dart';
import 'package:billshare/models/user.dart';
import 'package:billshare/services/database.dart';
import 'package:billshare/views/shared/loading.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class AddFriends extends StatefulWidget {
  final AppUser loggedInUser;
  const AddFriends({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  String email = '';
  bool isLoading = false;
  AppUser? searchUser;
  // List<Map<String, dynamic>> usersMap = [];
  final Database _db = Database();

  Widget searchList() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return SearchTile(
          user: searchUser,
          loggedInUser: widget.loggedInUser,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Groups",
          style: TextStyle(fontFamily: "DancingScript", color: kPrimaryColor),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: kPrimaryColor, //change your color here
        ),
        elevation: 0.0,
      ),
      body: isLoading
          ? const Loading()
          : SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 300,
                          child: TextField(
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(16, 224, 210, 210),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Search users...",
                              hintStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(143, 0, 0, 0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () async {
                                if (email != '' &&
                                    email != widget.loggedInUser.email) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  searchUser = await _db.getUserByEmail(email);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (searchUser != null) Expanded(child: searchList()),
                  ],
                ),
              ),
            ),
    );
  }
}

// ignore: must_be_immutable
class SearchTile extends StatelessWidget {
  AppUser? user;
  AppUser? loggedInUser;
  final Database _db = Database();
  SearchTile({this.user, this.loggedInUser, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user!.name!),
        subtitle: Text(user!.email!),
        trailing: const Icon(
          Icons.add,
        ),
        onTap: () async {
          bool result = await _db.addFriend(loggedInUser!, user!);
          if (result) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
