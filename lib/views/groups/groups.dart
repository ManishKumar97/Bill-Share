import 'package:billshare/models/user.dart';
import 'package:billshare/views/shared/stats.dart';
import "package:flutter/material.dart";
import 'package:billshare/constants.dart';

class Groups extends StatefulWidget {
  final AppUser user;
  const Groups({Key? key, required this.user}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups",
            style: TextStyle(
              fontFamily: "DancingScript",
              color: kPrimaryColor,
            )),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: kPrimaryColor,
        ),
      ),
      body: const Stats(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        onPressed: () {},
      ),
    );
  }
}
