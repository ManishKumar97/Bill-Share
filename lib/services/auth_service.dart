import 'package:billshare/models/user.dart';
import 'package:billshare/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Database db = Database();
  AppUser? _userFromFirebaseUser(User? user,
      {String name = "", String email = ""}) {
    return user != null
        ? AppUser(name: name, email: user.email, uid: user.uid, friends: [])
        : null;
  }

  // auth change user stream
  Stream<AppUser?> get authchanges {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      AppUser? loggedInUser;
      if (user != null) {
        loggedInUser = await db.getUserByEmail(email);
      }
      return loggedInUser;
      // return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      AppUser? loggedInUser;
      if (user != null) {
        loggedInUser =
            AppUser(uid: user.uid, name: name, email: email, friends: []);
        db.registerNewUser(loggedInUser);
      }
      return loggedInUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
