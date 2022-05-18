import 'package:billshare/models/user.dart';
import 'package:billshare/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:billshare/views/authentication/authentication.dart";

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    // return either the Home or Authenticate widget
    if (user == null || user.uid == "") {
      return const Authenticate();
    } else {
      return Home(email: user.email!);
    }
  }
}
