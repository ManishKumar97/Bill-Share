import 'package:billshare/models/user.dart';
import 'package:billshare/views/shared/stats.dart';
import "package:flutter/material.dart";
import 'package:billshare/constants.dart';
import 'package:billshare/services/database.dart';
import 'package:billshare/models/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:billshare/views/shared/loading.dart';
import 'package:billshare/views/bills/bills.dart';
import 'package:billshare/views/groups/createGroups.dart';

class Groups extends StatefulWidget {
  final AppUser user;
  const Groups({Key? key, required this.user}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
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
      double val1 =
          await _db.getAmountUserGetsInGroup(groupType.group, widget.user.uid);
      double val2 =
          await _db.getAmountUserOwesInGroup(groupType.group, widget.user.uid);
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
                        .where('type', isEqualTo: 2)
                        .where('membersUids', arrayContains: widget.user.uid)
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
                              return GroupTile(
                                group: grp,
                                user: widget.user,
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
                      CreateGroups(loggedInUser: widget.user)));
        },
      ),
    );
  }
}

class GroupTile extends StatelessWidget {
  final Group group;
  final AppUser user;
  String? name;
  final Function fetchStats;
  GroupTile(
      {required this.group,
      required this.user,
      required this.fetchStats,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    name = group.name;
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: const Icon(
          Icons.group,
          color: kPrimaryColor,
        ),
        title: Text(name!),
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Bills(
                        currentUser: user,
                        group: group,
                      )));
          await fetchStats();
        },
      ),
    );
  }
}
