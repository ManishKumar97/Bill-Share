import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future registerNewUser(String name, String email, User user) async {
    try {
      await _db.collection('users').doc(user.uid).set({
        "name": name,
        "email": email,
      });
    } catch (e) {
      print("Could not register new user");
    }
  }
}
