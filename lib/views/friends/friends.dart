import 'package:billshare/constants.dart';
import 'package:billshare/models/group.dart';
import 'package:billshare/models/user.dart';
import 'package:billshare/services/database.dart';
import 'package:billshare/views/bills/bills.dart';
import 'package:billshare/views/friends/addFriends.dart';
import 'package:billshare/views/shared/loading.dart';
import 'package:billshare/views/shared/stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class Friends extends StatefulWidget {
  final AppUser currentuser;

  const Friends({Key? key, required this.currentuser}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  double amountUserOwes = 0.0;
  double amountUserGets = 0.0;
  bool isLoading = true;
  final Database _db = Database();

  Future<void> fetchStats() async {
    try {
      setState(() {
        amountUserGets = 0.0;
        amountUserGets = 0.0;
        isLoading = true;
      });
      double val1 = await _db.getAmountUserGetsInGroup(
          groupType.individual, widget.currentuser.uid);
      double val2 = await _db.getAmountUserOwesInGroup(
          groupType.individual, widget.currentuser.uid);
      setState(() {
        amountUserGets = val1;
        amountUserOwes = val2;
        isLoading = false;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    fetchStats();
    super.initState();
  }

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
      body: isLoading
          ? const Loading()
          : Column(
              children: [
                Stats(
                  getAmount: amountUserGets,
                  owesAmount: amountUserOwes,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Group>>(
                    stream: _db.groupsRef
                        .where('type', isEqualTo: 1)
                        .where('membersUids',
                            arrayContains: widget.currentuser.uid)
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
                                group: grp,
                                currentUser: widget.currentuser,
                                fetchStats: fetchStats,
                              );
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
  final Function fetchStats;
  FriendTile(
      {required this.group,
      required this.currentUser,
      required this.fetchStats,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    group.members.forEach((uid, username) {
      if (uid != currentUser.uid) name = username;
    });
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
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Bills(currentUser: currentUser, group: group)));
          await fetchStats();
        },
      ),
    );
  }
}
