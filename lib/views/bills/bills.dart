import 'package:billshare/models/group.dart';
import 'package:billshare/views/bills/viewBills.dart';
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
  bool isLoading = true;
  // double amountUserOwes = 0.0;
  // double amountUserGets = 0.0;
  Map<String, double> totalAmountToSettleInGroup = {};
  Map<String, bool> friendsToSettleInGroup = {};
  Future<void> fetchStats() async {
    setState(() {
      isLoading = true;
    });
    Map<String, double> temp = {};
    for (String key in widget.group.members.keys) {
      temp[key] = await _db.getAmountUserOwesOrGetsFromFriendInGroup(
          widget.group.groupId, widget.currentUser.uid, key);
    }
    totalAmountToSettleInGroup = Map.from(temp)
      ..removeWhere((k, v) => v == 0.0);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    widget.group.members.forEach((key, value) {
      if (key != widget.currentUser.uid) {
        totalAmountToSettleInGroup[key] = 0.0;
        friendsToSettleInGroup[key] = false;
      }
    });
    fetchStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      body: isLoading
          ? const Loading()
          : Column(
              children: [
                Column(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: totalAmountToSettleInGroup.length,
                      itemBuilder: (context, index) {
                        String key =
                            totalAmountToSettleInGroup.keys.elementAt(index);
                        double val = totalAmountToSettleInGroup[key]!;
                        String friendName = widget.group.members[key]!;

                        bool get = (val > 0.0);
                        if (!get) {
                          val = val * -1;
                        }

                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (get)
                                  ? "$friendName owes you \$$val "
                                  : "You owe $friendName \$$val ",
                              style: const TextStyle(
                                  fontSize: 16, color: kPrimaryColor),
                            ),
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        totalAmountToSettleInGroup.length,
                                    itemBuilder: (context, index) {
                                      String key = totalAmountToSettleInGroup
                                          .keys
                                          .elementAt(index);
                                      double val =
                                          totalAmountToSettleInGroup[key]!;
                                      String friendName =
                                          widget.group.members[key]!;

                                      bool get = (val > 0.0);
                                      if (!get) {
                                        val = val * -1;
                                      }
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        width: size.width / 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(19),
                                        ),
                                        child: CheckboxListTile(
                                          title: Text((get)
                                              ? "$friendName paid you \$$val "
                                              : "You paid $friendName \$$val "),
                                          value: friendsToSettleInGroup[key],
                                          onChanged: (val) {
                                            setState(() {
                                              friendsToSettleInGroup[key] =
                                                  val!;
                                            });
                                          },
                                          checkColor: Colors.white,
                                          activeColor: kPrimaryColor,
                                        ),
                                      );
                                    },
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        await _db.settleDebtsInGroup(
                                            widget.currentUser,
                                            widget.group,
                                            totalAmountToSettleInGroup,
                                            friendsToSettleInGroup);
                                        await fetchStats();
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Done",
                                        style: TextStyle(
                                          fontFamily: "DancingScript",
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 20),
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)))
                                ],
                              );
                            });
                          },
                        );
                        setState(() {
                          fetchStats();
                        });
                      },
                      child: const Text(
                        "Settle Up",
                        style: TextStyle(fontFamily: "DancingScript"),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
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
                      } else if (snapshot.connectionState ==
                              ConnectionState.active ||
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
                                return BillTile(
                                  bill: bill,
                                  group: widget.group,
                                  loggedInUser: widget.currentUser,
                                );
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
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddBill(
                        loggedInUser: widget.currentUser,
                        group: widget.group,
                      )));

          await fetchStats();
        },
      ),
    );
  }
}

class BillTile extends StatefulWidget {
  final Bill bill;
  final Group group;
  final AppUser loggedInUser;
  const BillTile(
      {required this.bill,
      required this.group,
      required this.loggedInUser,
      Key? key})
      : super(key: key);

  @override
  State<BillTile> createState() => _BillTileState();
}

class _BillTileState extends State<BillTile> {
  final Database _db = Database();
  double amount = 0.0;
  bool paidByUser = true;
  bool isLoading = true;
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    double val = 0.0;
    if (widget.bill.status == billstatus.pending &&
        widget.bill.paidBy == widget.loggedInUser.uid) {
      val = await _db.getAmountUserGetsForBill(
          widget.bill.billId, widget.loggedInUser.uid);
      setState(() {
        amount = val;
        paidByUser = true;
      });
    } else if (widget.bill.status == billstatus.pending &&
        widget.bill.paidBy != widget.loggedInUser.uid) {
      val = await _db.getAmountUserOwesForBill(
          widget.bill.billId, widget.loggedInUser.uid);
      setState(() {
        amount = val;
        paidByUser = false;
      });
    } else {
      setState(() {
        amount = val;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SizedBox.shrink()
        : Card(
            elevation: 0.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: const Icon(
                Icons.receipt,
                color: kPrimaryColor,
              ),
              title: Text(widget.bill.title),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(!(widget.bill.memberShares
                          .containsKey(widget.loggedInUser.uid))
                      ? "you are not involved"
                      : ((amount == 0.0 ||
                              widget.bill.status == billstatus.settled)
                          ? "you are settled up"
                          : (paidByUser)
                              ? "you get"
                              : "you owe")),
                  if (widget.bill.status == billstatus.pending &&
                      widget.bill.memberShares
                          .containsKey(widget.loggedInUser.uid) &&
                      amount > 0.0)
                    Text(
                      "\$$amount",
                    )
                ],
              ),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewBills(
                              loggedInUser: widget.loggedInUser,
                              group: widget.group,
                              bill: widget.bill,
                            )));

                //await fetchData();
              },
            ),
          );
  }
}
