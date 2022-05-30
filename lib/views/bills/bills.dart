import 'package:billshare/models/group.dart';
import "package:flutter/material.dart";
import 'package:billshare/models/user.dart';
import 'package:billshare/constants.dart';
import 'package:billshare/views/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:billshare/services/database.dart';
import 'package:billshare/models/bill.dart';
import 'package:billshare/views/bills/addBill.dart';

class Bills extends StatefulWidget {
  final AppUser currentUser;
  final Group group;
  const Bills({Key? key, required this.currentUser, required this.group})
      : super(key: key);

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
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Bill>>(
              stream: _db.billsRef
                  .where('groupId', isEqualTo: widget.group.groupId)
                  .orderBy('createdDate', descending: true)
                  .withConverter<Bill>(
                      fromFirestore: ((snapshot, options) =>
                          Bill.fromJson(snapshot.data()!)),
                      toFirestore: (bill, _) => bill.toJson())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Bill>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading();
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text("error");
                  }
                  if (snapshot.hasData) {
                    final int billsCount = snapshot.data!.docs.length;

                    return ListView.builder(
                        itemCount: billsCount,
                        itemBuilder: (context, index) {
                          Bill bill = snapshot.data!.docs[index].data();
                          return BillTile(bill: bill, group: widget.group);
                        });
                  }
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
                  builder: (context) => AddBill(
                        loggedInUser: widget.currentUser,
                        group: widget.group,
                      )));
        },
      ),
    );
  }
}

class BillTile extends StatelessWidget {
  final Bill bill;
  final Group group;
  String? title;
  BillTile({required this.bill, required this.group, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: const Icon(
          Icons.receipt,
          color: kPrimaryColor,
        ),
        title: Text(bill.title),
        trailing: Text("\$" + "${bill.amount}"),
        onTap: () {},
      ),
    );
  }
}
