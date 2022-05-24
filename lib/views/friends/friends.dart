import 'package:billshare/constants.dart';
import 'package:billshare/models/group.dart';
import 'package:billshare/models/user.dart';
import 'package:billshare/services/database.dart';
import 'package:billshare/views/bills/bills.dart';
import 'package:billshare/views/friends/addFriends.dart';
import 'package:billshare/views/shared/loading.dart';
import 'package:billshare/views/shared/stats.dart';

// import 'package:billshare/views/shared/stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class Friends extends StatefulWidget {
  final AppUser currentuser;
  const Friends({Key? key, required this.currentuser}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final Database _db = Database();
  // Future fetchData() async {
  //   QuerySnapshot<Group> q = await _db.groupsRef
  //       .where('type', isEqualTo: 1)
  //       .withConverter<Group>(
  //           fromFirestore: ((snapshot, options) =>
  //               Group.fromJson(snapshot.data()!)),
  //           toFirestore: (group, _) => group.toJson())
  //       .get();

  //   print(q.docs[0].data());
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   fetchData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends",
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
      body: Column(
        children: [
          const Stats(),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Group>>(
              stream: _db.groupsRef
                  .where('type', isEqualTo: 1)
                  .where('membersUids', arrayContains: widget.currentuser.uid)
                  .withConverter<Group>(
                      fromFirestore: ((snapshot, options) =>
                          Group.fromJson(snapshot.data()!)),
                      toFirestore: (group, _) => group.toJson())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Group>> snapshot) {
                if (snapshot.hasData) {
                  final int friendsCount = snapshot.data!.docs.length;

                  return ListView.builder(
                      itemCount: friendsCount,
                      itemBuilder: (context, index) {
                        Group grp = snapshot.data!.docs[index].data();
                        return FriendTile(
                            group: grp, currentUser: widget.currentuser);
                      });
                }

                return const Loading();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddFriends(loggedInUser: widget.currentuser)));
        },
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  final Group group;
  final AppUser currentUser;
  String? name;
  FriendTile({required this.group, required this.currentUser, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    name = (group.members![0] != currentUser.name)
        ? group.members![0]
        : group.members![1];
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: const Icon(
          Icons.person,
          color: kPrimaryColor,
        ),
        title: Text(name!),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: kPrimaryColor,
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Bills(currentuser: currentUser)));
        },
      ),
    );
  }
}
