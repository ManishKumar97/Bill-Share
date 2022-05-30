import 'package:billshare/models/bill.dart';
import 'package:billshare/models/group.dart';
import 'package:billshare/models/indebt.dart';
import 'package:billshare/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference groupsRef =
      FirebaseFirestore.instance.collection('groups');

  final CollectionReference billsRef =
      FirebaseFirestore.instance.collection('bills');
  final CollectionReference indebtRef =
      FirebaseFirestore.instance.collection('indebts');

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
      currentUser.friends?.add({newFriend.uid: newFriend.name!});
      newFriend.friends?.add({currentUser.uid: currentUser.name!});
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

  Future<bool> addIndebt(String owedTo, String owedBy, double amount,
      DateTime createdDate, String billId, DateTime dueDate) async {
    String indebtId = indebtRef.doc().id;
    Indebt indebt = Indebt(
        indebtId: indebtId,
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

  Future addBill(
      String title,
      double amount,
      DateTime dueDate,
      String paidBy,
      String createdUserId,
      String groupId,
      String comments,
      Map<String, double> values) async {
    try {
      String billId = billsRef.doc().id;
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
          status: billstatus.pending);
      final docRef = billsRef.doc(billId).withConverter<Bill>(
          fromFirestore: ((snapshot, options) =>
              Bill.fromJson(snapshot.data()!)),
          toFirestore: (bill, _) => bill.toJson());
      await docRef.set(bill);
      values.forEach((key, value) async {
        if (key != paidBy && value > 0.0) {
          await addIndebt(paidBy, key, value, now, billId, dueDate);
        }
      });
      return true;
    } catch (e) {
      print("cannot add bill");
    }
  }
}
