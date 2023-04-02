import 'package:firebase_auth/firebase_auth.dart';

import 'model.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<UserModel?> get currentUser {
    return _firebaseAuth.authStateChanges().map(
        (User? user) => user != null ? UserModel.fromFirebase(user) : null);
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      if (user == null) {
        return null;
      }

      return UserModel.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> register(String email, String password) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      if (user == null) {
        return null;
      }

      return UserModel.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future logOut() async {
    await _firebaseAuth.signOut();
  }
}
