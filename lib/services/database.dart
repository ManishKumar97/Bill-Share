import 'package:billshare/models/group.dart';
import 'package:billshare/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference groupsRef =
      FirebaseFirestore.instance.collection('groups');

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
      Group grp = Group(
          groupId: gid,
          type: groupType.individual,
          name: "Individual",
          membersUids: [currentUser.uid, newFriend.uid],
          members: [currentUser.name!, newFriend.name!]);

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
}
