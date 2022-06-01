import 'package:billshare/constants.dart';
import 'package:billshare/models/group.dart';
import 'package:billshare/models/user.dart';
import "package:flutter/material.dart";

class SettleBills extends StatefulWidget {
  final AppUser loggedInUser;
  final Group group;
  final Map<String, double> totalAmountToSettleInGroup;
  const SettleBills(
      {required this.loggedInUser,
      required this.group,
      required this.totalAmountToSettleInGroup,
      Key? key})
      : super(key: key);

  @override
  State<SettleBills> createState() => _SettleBillsState();
}

class _SettleBillsState extends State<SettleBills> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settle Bills",
          style: TextStyle(fontFamily: "DancingScript", color: kPrimaryColor),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: kPrimaryColor, //change your color here
        ),
        elevation: 0.0,
      ),
    );
  }
}
