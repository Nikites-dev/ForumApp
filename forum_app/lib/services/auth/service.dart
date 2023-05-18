import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../models/comment.dart';
import '../../models/user_info.dart' as models_user_info;
import '../../models/user.dart' as models_user;
import '../../responses/auth_responses.dart';
import 'model.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.ref();
  static Map<String, models_user_info.UserInfo> uniqueUsers = <String, models_user_info.UserInfo>{};

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
    try{
      var userId = Provider.of<UserModel?>(context, listen: false)!.id;
      var usersRef = _dbRef.child('user');

      var user = usersRef.child(userId);

      await user
          .child("username")
          .set(username);
      await user
          .child("email")
          .set(email);
      await user
          .child("password")
          .set(password);
    } catch (e) {return;}
  }

  Future updateUserInterests(BuildContext context, List<int> selectedInterests) async
  {
    try{
      var userId = Provider.of<UserModel?>(context, listen: false)!.id;

    await _dbRef
        .child('user')
        .child(userId.toString())
        .child("interests")
        .set(selectedInterests);
    } catch (e) {return;}
  }
 
  Future<void> cacheUserInfo(List<Comment> comments, bool isFirstBuild) async
  {
    if (isFirstBuild)
    {
      for(int i= 0; i < comments.length; ++i)
      {
        var userId = comments[i].username;
        await cacheInfo(userId!);
      }
    } else {
      var userId = comments.last.username;
      await cacheInfo(userId!);
    }
  }

  Future<void> cacheInfo(String userId) async
  {
    if (!uniqueUsers.containsKey(userId))
      {
        uniqueUsers.addAll({userId: models_user_info.UserInfo('null', 'null')});
        var userInfo = await getUserInfo(userId);
        uniqueUsers[userId] = userInfo;
      }
  }

  Future<models_user_info.UserInfo> getUserInfo(String userId) async
  {
    try{
      var usersRef = _dbRef.child('user');
      DataSnapshot snapshot = await usersRef.child(userId).get();

      var userImg = snapshot.child('image').value.toString();
      var userName = snapshot.child('username').value.toString();
      return models_user_info.UserInfo(userName, userImg);
    } catch (e) {return models_user_info.UserInfo('null', 'null');}
  }

  Future<List<int>> getUserInterest(String userId) async
  {
    try{
      var usersRef = _dbRef.child('user');
      DataSnapshot snapshot = await usersRef.child(userId).child('interests').get();

      List<int> interests = [];
      snapshot.children.forEach((element) {
        interests.add(int.parse(element.value.toString()));
      });

      return interests;
    } catch (e) {return [];}    
  }

  Future<void> updateCacheInfo(String userId) async
  {
    if (uniqueUsers.containsKey(userId))
    {
      uniqueUsers.addAll({userId: models_user_info.UserInfo('null', 'null')});
      var userInfo = await getUserInfo(userId);
      uniqueUsers[userId] = userInfo;
    }
  }

  Future<models_user.User?> getUser(String userId) async
  {
    try{
      var usersRef = _dbRef.child('user');
      DataSnapshot snapshot = await usersRef.child(userId).get();

      return models_user.User.fromMap(snapshot.value as Map<dynamic, dynamic>);
    } catch (e) {return null;}
  }
}