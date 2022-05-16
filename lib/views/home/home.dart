import 'package:billshare/views/bill/bills.dart';
import 'package:billshare/views/chat/chats.dart';
import 'package:billshare/views/friends/friends.dart';
import 'package:billshare/views/settings/settings.dart';
import "package:flutter/material.dart";
import "package:billshare/constants.dart";
import 'package:billshare/services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  List<Widget> pages = <Widget>[
    const Bills(),
    const Chats(),
    const Friends(),
    const Settings(),
  ];
  int _tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _tabIndex = value;
          });
        },
        currentIndex: _tabIndex,
        type: BottomNavigationBarType.fixed,
        // selectedIconTheme: const IconThemeData(color: kPrimaryColor),
        unselectedItemColor: Colors.grey,
        selectedItemColor: kPrimaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Bills"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Friends"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
