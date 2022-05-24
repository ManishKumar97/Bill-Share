import 'package:billshare/constants.dart';
import 'package:billshare/models/user.dart';
import 'package:billshare/services/database.dart';
import 'package:billshare/views/shared/loading.dart';
import "package:flutter/material.dart";

class AddBill extends StatefulWidget {
  final AppUser loggedInUser;
  const AddBill({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  State<AddBill> createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  String title = '';
  bool isLoading = false;
  AppUser? searchUser;
  final Database _db = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Bill",
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
                    Text(
                      'Enter your bill details below',
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
