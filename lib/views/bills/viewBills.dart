import 'package:billshare/constants.dart';
import 'package:billshare/models/bill.dart';
import 'package:billshare/models/group.dart';
import 'package:billshare/models/user.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class ViewBills extends StatefulWidget {
  final AppUser loggedInUser;
  final Group group;
  final Bill bill;
  const ViewBills(
      {required this.loggedInUser,
      required this.group,
      required this.bill,
      Key? key})
      : super(key: key);

  @override
  State<ViewBills> createState() => _ViewBillsState();
}

class _ViewBillsState extends State<ViewBills> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.bill.title,
            style: const TextStyle(
                fontFamily: "DancingScript", color: kPrimaryColor),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: kPrimaryColor, //change your color here
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.bill.title,
                      style:
                          const TextStyle(fontSize: 22, color: kPrimaryColor)),
                  Text("\$" + widget.bill.amount.toString(),
                      style:
                          const TextStyle(fontSize: 20, color: kPrimaryColor)),
                  Text("Paid by " + widget.group.members[widget.bill.paidBy]!,
                      style:
                          const TextStyle(fontSize: 16, color: kPrimaryColor)),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.bill.memberShares.length,
                    itemBuilder: (context, index) {
                      String key =
                          widget.bill.memberShares.keys.elementAt(index);
                      double val = widget.bill.memberShares[key]!;
                      String friendName = widget.group.members[key]!;
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "$friendName owes \$$val ",
                            style: const TextStyle(
                                fontSize: 16, color: kPrimaryColor),
                          ),
                        ),
                      );
                    },
                  ),
                  Text(
                      " Created on " +
                          DateFormat.yMEd()
                              .add_jms()
                              .format(widget.bill.createdDate),
                      style:
                          const TextStyle(fontSize: 16, color: kPrimaryColor)),
                  Text(
                      "Due date on " +
                          DateFormat.yMEd()
                              .add_jms()
                              .format(widget.bill.dueDate),
                      style:
                          const TextStyle(fontSize: 16, color: kPrimaryColor)),
                  Text("Comments: " + widget.bill.comments!,
                      style:
                          const TextStyle(fontSize: 16, color: kPrimaryColor)),
                ]),
          ),
        ));
  }
}
