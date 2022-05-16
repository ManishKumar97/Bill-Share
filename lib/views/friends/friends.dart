import 'package:billshare/constants.dart';
import 'package:billshare/views/friends/create_groups.dart';
import "package:flutter/material.dart";

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends",
            style: TextStyle(
              color: kPrimaryColor,
            )),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: kPrimaryColor,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateGroups()));
        },
      ),
    );
  }
}
