import 'package:billshare/models/user.dart';
import "package:flutter/material.dart";
import 'package:billshare/views/settings/components/profile_menu.dart';
import 'package:billshare/services/auth_service.dart';
import "package:billshare/constants.dart";

class Settings extends StatefulWidget {
  final AppUser user;
  const Settings({Key? key, required this.user}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Share',
            style: TextStyle(
              fontFamily: "DancingScript",
              color: kPrimaryColor,
            )),
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: kPrimaryColor,
            tooltip: 'Logout',
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text("Welcome ${widget.user.name!}"),
            ProfileMenu(
              text: "My Account",
              icon: const Icon(Icons.account_circle),
              press: () => {},
            ),
            ProfileMenu(
              text: "Notifications",
              icon: const Icon(Icons.notifications),
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: const Icon(Icons.settings),
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: const Icon(Icons.exit_to_app),
              press: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
