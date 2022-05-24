import "package:flutter/material.dart";
import 'package:billshare/models/user.dart';
import 'package:billshare/constants.dart';
import 'package:billshare/views/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:billshare/services/database.dart';
import 'package:billshare/models/bill.dart';
import 'package:billshare/views/bills/addBill.dart';

class Bills extends StatefulWidget {
  final AppUser currentuser;
  const Bills({Key? key, required this.currentuser}) : super(key: key);

  @override
  State<Bills> createState() => _BillState();
}

class _BillState extends State<Bills> {
  final Database _db = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bills",
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
          // children: [
          //   Expanded(
          //     child: StreamBuilder<QuerySnapshot<Bill>>(
          //       stream: _db.groupsRef
          //           .where('type', isEqualTo: 1)
          //           .where('membersUids', arrayContains: widget.currentuser.uid)
          //           .withConverter<Group>(
          //               fromFirestore: ((snapshot, options) =>
          //                   Group.fromJson(snapshot.data()!)),
          //               toFirestore: (group, _) => group.toJson())
          //           .snapshots(),
          //       builder: (BuildContext context,
          //           AsyncSnapshot<QuerySnapshot<Group>> snapshot) {
          //         if (snapshot.hasData) {
          //           final int friendsCount = snapshot.data!.docs.length;

          //           return ListView.builder(
          //               itemCount: friendsCount,
          //               itemBuilder: (context, index) {
          //                 Group grp = snapshot.data!.docs[index].data();
          //                 return BillTile(
          //                     group: grp, currentUser: widget.currentuser);
          //               });
          //         }

          //         return const Loading();
          //       },
          //     ),
          //   ),
          // ],
          ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddBill(loggedInUser: widget.currentuser)));
        },
      ),
    );
  }
}

class BillTile extends StatelessWidget {
  final Bill bill;
  final AppUser currentUser;
  String? title;
  BillTile({required this.bill, required this.currentUser, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    title = bill.title;
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: const Icon(
          Icons.document_scanner,
          color: kPrimaryColor,
        ),
        title: Text(title!),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: kPrimaryColor,
        ),
        onTap: () {},
      ),
    );
  }
}
