import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../responses/auth_responses.dart';
import 'model.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<UserModel?> get currentUser {
    return _firebaseAuth.authStateChanges().map(
        (User? user) => user != null ? UserModel.fromFirebase(user) : null);
  }

  Future<String?> signIn(String email, String password) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;

      if (user == null) {
        return AuthResponses.userNotFound;
      }

      return null;
    } on FirebaseAuthException catch (authException) {
      if (authException.code == 'wrong-password')
      {
        return AuthResponses.invalidPassword;
      }

      if (authException.code == 'invalid-email')
      {
        return AuthResponses.invalidEmail;
      }

      if (authException.code == 'user-not-found')
      {
        return AuthResponses.userNotFound;
      }
      return authException.code;
    } catch (e) {
      return AuthResponses.badResult;
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;

      if (user == null) {
        return AuthResponses.badResult;
      }

      return null;
    } on FirebaseAuthException catch (authException) {
      if (authException.code == 'email-already-exists')
      {
        return AuthResponses.userExist;
      }

      if (authException.code == 'invalid-email')
      {
        return AuthResponses.invalidEmail;
      }

      return authException.code;
    } catch (e) {
      return AuthResponses.badResult;
    }
  }

  Future logOut() async {
    await _firebaseAuth.signOut();
  }

  Future saveUserToDb(BuildContext context, String username, String email, String password) async
  {
    var userId = Provider.of<UserModel?>(context, listen: false)!.id;
    var dbRef = FirebaseDatabase.instance.ref().child('user');

    await dbRef!
        .child(userId)
        .child("username")
        .set(username);
    await dbRef!
        .child(userId)
        .child("email")
        .set(email);
    await dbRef!
        .child(userId)
        .child("password")
        .set(password);
  }
}
