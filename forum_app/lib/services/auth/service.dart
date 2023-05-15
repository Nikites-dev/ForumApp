import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../models/comment.dart';
import '../../models/user_info.dart' as models_user_info;
import '../../responses/auth_responses.dart';
import 'model.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Map<String, models_user_info.UserInfo> uniqueUsers = <String, models_user_info.UserInfo>{};

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

    await dbRef
        .child(userId)
        .child("username")
        .set(username);
    await dbRef
        .child(userId)
        .child("email")
        .set(email);
    await dbRef
        .child(userId)
        .child("password")
        .set(password);
  }

  Future updateUserInterests(BuildContext context, List<String> selectedInterests) async
  {
    var userId = Provider.of<UserModel?>(context, listen: false)!.id;
    var dbRef = FirebaseDatabase.instance.ref().child('user');

    await dbRef
        .child('user')
        .child(userId.toString())
        .child("interests")
        .set(selectedInterests);
  }
 
  Future<void> cacheUserInfo(List<Comment> comments, bool isFirstBuild) async
  {
    if (isFirstBuild)
    {
      for(int i= 0; i < comments.length; ++i)
      {
        var userId = comments[i].username;
        if (!uniqueUsers.containsKey(userId))
        {
          var userInfo = await getUserInfo(userId!);
          uniqueUsers.addAll({userId: userInfo});
        }
      }
    } else {
      var userId = comments.last.username;
      if (!uniqueUsers.containsKey(userId))
      {
        var userInfo = await getUserInfo(userId!);
        uniqueUsers.addAll({userId: userInfo});
      }
    }
  }

  Future<models_user_info.UserInfo> getUserInfo(String userId) async
  {
    var dbRef = FirebaseDatabase.instance.ref().child('user');
    DataSnapshot snapshot = await dbRef.child(userId).get();
    var userImg = snapshot.child('image').value.toString();
    var userName = snapshot.child('username').value.toString();
    return models_user_info.UserInfo(userName, userImg);
  }
}
