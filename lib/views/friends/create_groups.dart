import 'package:billshare/constants.dart';
import "package:flutter/material.dart";

class CreateGroups extends StatefulWidget {
  const CreateGroups({Key? key}) : super(key: key);

  @override
  State<CreateGroups> createState() => _CreateGroupsState();
}

class _CreateGroupsState extends State<CreateGroups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Groups",
          style: TextStyle(color: kPrimaryColor),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: kPrimaryColor, //change your color here
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(29.5),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: "Search",
            icon: Icon(
              Icons.search,
              color: kPrimaryColor,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
