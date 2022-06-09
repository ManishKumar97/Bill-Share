import 'dart:collection';

import 'package:billshare/models/bill.dart';
import 'package:billshare/models/group.dart';
import 'package:billshare/models/indebt.dart';
import 'package:billshare/models/notification.dart';
import 'package:billshare/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference groupsRef =
      FirebaseFirestore.instance.collection('groups');

  final CollectionReference billsRef =
      FirebaseFirestore.instance.collection('bills');
  final CollectionReference indebtRef =
      FirebaseFirestore.instance.collection('indebts');
  final CollectionReference notificationRef =
      FirebaseFirestore.instance.collection('notifications');

  Future registerNewUser(AppUser loggedInUser) async {
    try {
      final docref = usersRef.doc(loggedInUser.uid).withConverter<AppUser>(
          fromFirestore: ((snapshot, options) =>
              AppUser.fromJson(snapshot.data()!)),
          toFirestore: (loggedInUser, _) => loggedInUser.toJson());
      await docref.set(loggedInUser);
    } catch (e) {
      print("Could not register new user");
    }
  }

  Future getUserByEmail(String emailid) async {
    try {
      final queryRef = usersRef
          .where('email', isEqualTo: emailid)
          .withConverter<AppUser>(
              fromFirestore: ((snapshot, options) =>
                  AppUser.fromJson(snapshot.data()!)),
              toFirestore: (user, _) => user.toJson());
      QuerySnapshot<AppUser> querySnapshot = await queryRef.get();
      AppUser? user = querySnapshot.docs[0].data();
      return user;
    } catch (e) {
      print("error fetching the user");
    }
  }

  Future addFriend(AppUser currentUser, AppUser newFriend) async {
    try {
      currentUser.friends?[newFriend.uid] = newFriend.name!;
      newFriend.friends?[currentUser.uid] = currentUser.name!;
      final userRef = usersRef.withConverter<AppUser>(
          fromFirestore: ((snapshot, options) =>
              AppUser.fromJson(snapshot.data()!)),
          toFirestore: (user, _) => user.toJson());

      await userRef.doc(currentUser.uid).set(currentUser);
      await userRef.doc(newFriend.uid).set(newFriend);

      String gid = groupsRef.doc().id;
      Map<String, String> mems = {
        currentUser.uid: currentUser.name!,
        newFriend.uid: newFriend.name!
      };
      Group grp = Group(
        groupId: gid,
        type: groupType.individual,
        name: "Individual",
        membersUids: [currentUser.uid, newFriend.uid],
        // members: [currentUser.name!, newFriend.name!],
        members: mems,
        createdDate: DateTime.now(),
      );

      final docRef = groupsRef.doc(gid).withConverter<Group>(
          fromFirestore: ((snapshot, options) =>
              Group.fromJson(snapshot.data()!)),
          toFirestore: (group, _) => group.toJson());
      await docRef.set(grp);
      return true;
    } catch (e) {
      print("cannot add friend");
    }
  }

  Future<bool> addIndebt(
      String owedTo,
      String owedBy,
      double amount,
      DateTime createdDate,
      String billId,
      DateTime dueDate,
      String groupId) async {
    String indebtId = indebtRef.doc().id;
    Indebt indebt = Indebt(
        indebtId: indebtId,
        groupId: groupId,
        owedTo: owedTo,
        owedBy: owedBy,
        amount: amount,
        billId: billId,
        createdDate: createdDate,
        dueDate: dueDate,
        status: indebtstatus.pending);
    final docRef = indebtRef.doc(indebtId).withConverter<Indebt>(
        fromFirestore: ((snapshot, options) =>
            Indebt.fromJson(snapshot.data()!)),
        toFirestore: (indebt, _) => indebt.toJson());
    await docRef.set(indebt);
    return true;
  }

  Future<bool> deleteIndebt(
    String billId,
  ) async {
    WriteBatch batch = _db.batch();
    final indebtRecordRef = indebtRef
        .where("billId", isEqualTo: billId)
        .withConverter<Indebt>(
            fromFirestore: ((snapshot, options) =>
                Indebt.fromJson(snapshot.data()!)),
            toFirestore: (indebt, _) => indebt.toJson());

    QuerySnapshot<Indebt> querySnapshot = await indebtRecordRef.get();
    // HashSet<String> indebtIds = HashSet<String>();
    List<DocumentReference<Indebt>> docRefs = [];

    for (var doc in querySnapshot.docs) {
      batch.delete(indebtRef.doc(doc.id));
    }
    await batch.commit();
    return true;
  }

  Future<void> addNotification(
      String userId, DateTime now, String title, DateTime dueDate) async {
    try {
      final queryRef = usersRef.doc(userId).withConverter<AppUser>(
          fromFirestore: ((snapshot, options) =>
              AppUser.fromJson(snapshot.data()!)),
          toFirestore: (user, _) => user.toJson());
      DocumentSnapshot<AppUser> querySnapshot = await queryRef.get();
      AppUser? user = querySnapshot.data();
      if (user != null && user.token != null) {
        String notId = notificationRef.doc().id;
        billNotification notf = billNotification(
          notificationId: notId,
          status: false,
          token: (user.token != null) ? user.token! : "",
          year: now.year,
          month: now.month,
          day: now.day,
          hours: now.hour,
          minutes: now.minute,
          title: title,
          body: "",
        );
        final docRef = notificationRef
            .doc(notId)
            .withConverter<billNotification>(
                fromFirestore: ((snapshot, options) =>
                    billNotification.fromJson(snapshot.data()!)),
                toFirestore: (notf, _) => notf.toJson());
        docRef.set(notf);
        notId = notificationRef.doc().id;
        notf = billNotification(
          notificationId: notId,
          status: false,
          token: (user.token != null) ? user.token! : "",
          year: dueDate.year,
          month: dueDate.month,
          day: dueDate.day,
          hours: dueDate.hour,
          minutes: dueDate.minute,
          title: title,
          body: "",
        );
        final newdocRef = notificationRef
            .doc(notId)
            .withConverter<billNotification>(
                fromFirestore: ((snapshot, options) =>
                    billNotification.fromJson(snapshot.data()!)),
                toFirestore: (notf, _) => notf.toJson());
        newdocRef.set(notf);
      }
    } catch (e) {
      print("error adding notification");
    }
  }

  Future addBill(
    String billId,
    String title,
    double amount,
    DateTime dueDate,
    String paidBy,
    String createdUserId,
    String groupId,
    String comments,
    Map<String, double> values,
    List<bool> splittype,
  ) async {
    try {
      if (billId != "") {
        DateTime now = DateTime.now();

        await _db.runTransaction((transaction) async {
          final docRef = billsRef.doc(billId).withConverter<Bill>(
              fromFirestore: ((snapshot, options) =>
                  Bill.fromJson(snapshot.data()!)),
              toFirestore: (bill, _) => bill.toJson());

          // await docRef.set(bill);
          transaction.update(docRef, {
            "amount": amount,
            "title": title,
            "billId": billId,
            "dueDate": dueDate.toString(),
            "paidBy": paidBy,
            "createdUserID": createdUserId,
            "groupId": groupId,
            "comments": comments,
            "status": 1,
            "splittype": (splittype[0]) ? 0 : (splittype[1] ? 1 : 2),
            "memberShares": values
          });
          values.forEach((key, value) async {
            if (key != paidBy && value > 0.0) {
              await deleteIndebt(billId);
              await addIndebt(
                  paidBy, key, value, now, billId, dueDate, groupId);
              await addNotification(
                  key, now, "Bill Updated: " + title, dueDate);
            }
          });
        }).then(
          (value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"),
        );

        return;
      }
      billId = billsRef.doc().id;
      DateTime now = DateTime.now();
      Bill bill = Bill(
          amount: amount,
          title: title,
          billId: billId,
          createdDate: now,
          dueDate: dueDate,
          paidBy: paidBy,
          createdUserID: createdUserId,
          groupId: groupId,
          comments: comments,
          status: billstatus.pending,
          splittype: (splittype[0])
              ? splitType.equally
              : (splittype[1] ? splitType.percentage : splitType.number),
          memberShares: values);

      await _db.runTransaction((transaction) async {
        final docRef = billsRef.doc(billId).withConverter<Bill>(
            fromFirestore: ((snapshot, options) =>
                Bill.fromJson(snapshot.data()!)),
            toFirestore: (bill, _) => bill.toJson());

        // await docRef.set(bill);
        transaction.set(docRef, bill);
        values.forEach((key, value) async {
          if (key != paidBy && value > 0.0) {
            await addIndebt(paidBy, key, value, now, billId, dueDate, groupId);
            await addNotification(key, now, "Bill Added: " + title, dueDate);
          }
        });
      }).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"),
      );

      return true;
    } catch (e) {
      print("cannot add bill");
    }
  }

  Future<double> getAmountUserOwesForBill(String billId, String userId) async {
    try {
      final indebtRecordRef = indebtRef
          .where("billId", isEqualTo: billId)
          .where("owedBy", isEqualTo: userId)
          .where("status", isEqualTo: 1)
          .withConverter<Indebt>(
              fromFirestore: ((snapshot, options) =>
                  Indebt.fromJson(snapshot.data()!)),
              toFirestore: (indebt, _) => indebt.toJson());
      QuerySnapshot<Indebt> querySnapshot = await indebtRecordRef.get();
      Indebt? indebt = querySnapshot.docs[0].data();
      return indebt.amount;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getAmountUserGetsForBill(String billId, String userId) async {
    try {
      final indebtRecordRef = indebtRef
          .where("billId", isEqualTo: billId)
          .where("owedTo", isEqualTo: userId)
          .where("status", isEqualTo: 1)
          .withConverter<Indebt>(
              fromFirestore: ((snapshot, options) =>
                  Indebt.fromJson(snapshot.data()!)),
              toFirestore: (indebt, _) => indebt.toJson());

      QuerySnapshot<Indebt> querySnapshot = await indebtRecordRef.get();
      double ans = 0.0;
      for (var doc in querySnapshot.docs) {
        ans += doc.data().amount;
      }
      return ans;
    } catch (e) {
      print("Unable to fetch data");
      return 0.0;
    }
  }

  Future<double> getAmountUserGetsInGroup(
      groupType grouptype, String userId) async {
    try {
      final groupRecordsRef = groupsRef
          .where("type", isEqualTo: (grouptype == groupType.individual) ? 1 : 2)
          .where('membersUids', arrayContains: userId)
          .withConverter<Group>(
              fromFirestore: ((snapshot, options) =>
                  Group.fromJson(snapshot.data()!)),
              toFirestore: (group, _) => group.toJson());
      final indebtRecordsRef = indebtRef
          .where("status", isEqualTo: 1)
          .where("owedTo", isEqualTo: userId)
          .withConverter<Indebt>(
              fromFirestore: ((snapshot, options) =>
                  Indebt.fromJson(snapshot.data()!)),
              toFirestore: (indebt, _) => indebt.toJson());
      QuerySnapshot<Group> queryGroupsSnapshot = await groupRecordsRef.get();
      double ans = 0.0;
      for (QueryDocumentSnapshot<Group> g in queryGroupsSnapshot.docs) {
        QuerySnapshot<Indebt> queryIndebtSnapshot = await indebtRecordsRef
            .where("groupId", isEqualTo: g.data().groupId)
            .get();
        for (var doc in queryIndebtSnapshot.docs) {
          ans += doc.data().amount;
        }
      }

      return ans;
    } catch (e) {
      print("Unable to fetch data");
      return 0.0;
    }
  }

  Future<double> getAmountUserOwesInGroup(
      groupType grouptype, String userId) async {
    try {
      final groupRecordsRef = groupsRef
          .where("type", isEqualTo: (grouptype == groupType.individual) ? 1 : 2)
          .where('membersUids', arrayContains: userId)
          .withConverter<Group>(
              fromFirestore: ((snapshot, options) =>
                  Group.fromJson(snapshot.data()!)),
              toFirestore: (group, _) => group.toJson());
      final indebtRecordsRef = indebtRef
          .where("status", isEqualTo: 1)
          .where("owedBy", isEqualTo: userId)
          .withConverter<Indebt>(
              fromFirestore: ((snapshot, options) =>
                  Indebt.fromJson(snapshot.data()!)),
              toFirestore: (indebt, _) => indebt.toJson());
      QuerySnapshot<Group> queryGroupsSnapshot = await groupRecordsRef.get();
      double ans = 0.0;
      for (QueryDocumentSnapshot<Group> g in queryGroupsSnapshot.docs) {
        QuerySnapshot<Indebt> queryIndebtSnapshot = await indebtRecordsRef
            .where("groupId", isEqualTo: g.data().groupId)
            .get();
        for (var doc in queryIndebtSnapshot.docs) {
          ans += doc.data().amount;
        }
      }

      return ans;
    } catch (e) {
      print("Unable to fetch data");
      return 0.0;
    }
  }

  Future<double> getAmountUserOwesOrGetsFromFriendInGroup(
      String groupId, String currentUserId, String friendUserId) async {
    try {
      final owedByRecordRef = indebtRef
          .where("groupId", isEqualTo: groupId)
          .where("status", isEqualTo: 1)
          .where("owedBy", isEqualTo: currentUserId)
          .where("owedTo", isEqualTo: friendUserId)
          .withConverter<Indebt>(
              fromFirestore: ((snapshot, options) =>
                  Indebt.fromJson(snapshot.data()!)),
              toFirestore: (indebt, _) => indebt.toJson());

      QuerySnapshot<Indebt> querySnapshot = await owedByRecordRef.get();
      double amountUserOwes = 0.0;
      for (var doc in querySnapshot.docs) {
        amountUserOwes += doc.data().amount;
      }
      final owedToRecordRef = indebtRef
          .where("groupId", isEqualTo: groupId)
          .where("status", isEqualTo: 1)
          .where("owedBy", isEqualTo: friendUserId)
          .where("owedTo", isEqualTo: currentUserId)
          .withConverter<Indebt>(
              fromFirestore: ((snapshot, options) =>
                  Indebt.fromJson(snapshot.data()!)),
              toFirestore: (indebt, _) => indebt.toJson());

      querySnapshot = await owedToRecordRef.get();
      double amountUserGets = 0.0;
      for (var doc in querySnapshot.docs) {
        amountUserGets += doc.data().amount;
      }
      return amountUserGets - amountUserOwes;
    } catch (e) {
      print("Unable to fetch data");
      return 0.0;
    }
  }

  Future addGroup(AppUser currentUser, Map<String, bool> selectedFriends,
      String groupName) async {
    try {
      List<String> members = [];
      Map<String, String> membersMap = {};
      members.add(currentUser.uid);
      membersMap[currentUser.uid] = currentUser.name!;
      for (String key in selectedFriends.keys) {
        if (selectedFriends[key]!) {
          members.add(key);
          membersMap[key] = currentUser.friends![key]!;
        }
      }
      String gid = groupsRef.doc().id;

      Group grp = Group(
        groupId: gid,
        type: groupType.group,
        name: groupName,
        membersUids: members,
        // members: [currentUser.name!, newFriend.name!],
        members: membersMap,
        createdDate: DateTime.now(),
      );

      final docRef = groupsRef.doc(gid).withConverter<Group>(
          fromFirestore: ((snapshot, options) =>
              Group.fromJson(snapshot.data()!)),
          toFirestore: (group, _) => group.toJson());
      await docRef.set(grp);
      return true;
    } catch (e) {
      print("cannot add friend");
    }
  }

  Future settleDebtsInGroup(
      AppUser user,
      Group group,
      Map<String, double> totalAmountToSettleInGroup,
      Map<String, bool> friendsToSettle) async {
    try {
      WriteBatch batch = _db.batch();
      final indebtRecordRef = indebtRef
          .where("groupId", isEqualTo: group.groupId)
          .where("status", isEqualTo: 1)
          .withConverter<Indebt>(
              fromFirestore: ((snapshot, options) =>
                  Indebt.fromJson(snapshot.data()!)),
              toFirestore: (indebt, _) => indebt.toJson());

      QuerySnapshot<Indebt> querySnapshot = await indebtRecordRef.get();
      HashSet<String> billIds = HashSet<String>();
      List<DocumentReference<Indebt>> docRefs = [];

      for (var doc in querySnapshot.docs) {
        if (friendsToSettle.containsKey(doc.data().owedBy) &&
            friendsToSettle[doc.data().owedBy]! &&
            doc.data().owedTo == user.uid) {
          if (totalAmountToSettleInGroup[doc.data().owedBy]! > 0) {
            billIds.add(doc.data().billId);
            batch.update(indebtRef.doc(doc.id), {"status": 2});
          }
        } else if (friendsToSettle.containsKey(doc.data().owedTo) &&
            friendsToSettle[doc.data().owedTo]! &&
            doc.data().owedBy == user.uid) {
          if (totalAmountToSettleInGroup[doc.data().owedTo]! < 0) {
            billIds.add(doc.data().billId);
            batch.update(indebtRef.doc(doc.id), {"status": 2});
          }
        }
      }
      await batch.commit();
      await updateBillStatusOnSettle(billIds);

      return true;
    } catch (e) {
      print("Unable to settle group");
    }
  }

  Future updateBillStatusOnSettle(HashSet<String> billIds) async {
    WriteBatch batch = _db.batch();
    QuerySnapshot<Indebt> querySnapshot;
    HashSet<String> settledBills = HashSet<String>();
    for (var id in billIds) {
      querySnapshot = await indebtRef
          .where("billId", isEqualTo: id)
          .where("status", isEqualTo: 1)
          .withConverter<Indebt>(
              fromFirestore: ((snapshot, options) =>
                  Indebt.fromJson(snapshot.data()!)),
              toFirestore: (indebt, _) => indebt.toJson())
          .get();
      if (querySnapshot.docs.isEmpty) settledBills.add(id);
    }

    for (var id in settledBills) {
      batch.update(billsRef.doc(id), {"status": 2});
    }
    await batch.commit();

    return true;
  }
}
