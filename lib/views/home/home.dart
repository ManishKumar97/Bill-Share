import 'package:billshare/models/user.dart';
import 'package:billshare/services/database.dart';
import 'package:billshare/views/groups/groups.dart';
import 'package:billshare/views/friends/friends.dart';
import 'package:billshare/views/settings/settings.dart';
import 'package:billshare/views/shared/loading.dart';
import "package:flutter/material.dart";
import "package:billshare/constants.dart";
import 'package:billshare/services/auth_service.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  AppUser? user;
  final String email;
  Home({Key? key, this.user, required this.email}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final Database _db = Database();
  int _tabIndex = 0;
  bool isLoading = false;

  Future<AppUser> fetchUser(String email) async {
    AppUser loggedInUser = await _db.getUserByEmail(email);
    return loggedInUser;
  }

  Future<AppUser>? _getUser;
  @override
  void initState() {
    _getUser = fetchUser(widget.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<AppUser>(
        future: _getUser,
        initialData: null,
        builder: (
          BuildContext context,
          AsyncSnapshot<AppUser> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              widget.user = snapshot.data;
              List<Widget> _pages() => [
                    Friends(currentuser: widget.user!),
                    Groups(user: widget.user!),
                    Settings(user: widget.user!),
                  ];
              final List<Widget> pages = _pages();
              return pages[_tabIndex];
            }
          }
          return Text('State: ${snapshot.connectionState}');
        },
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Friends"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
