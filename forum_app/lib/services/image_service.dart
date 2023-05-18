import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:xid/xid.dart';

class ImageService
{
  final AuthServices _authService = AuthServices();
  final _dbRef = FirebaseDatabase.instance.ref();
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String?> uploadPostImage(File file) async
  {
    var xid = Xid();
    
    try {
      var imgfile = _storageRef
        .child("PostImages")
        .child("/${xid.toString()}.jpg");

      UploadTask task = imgfile.putFile(file);
      TaskSnapshot snapshot = await task;

      var url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return 'null';
    }
  }

  Future<void> uploadUserImage(File file, String userId) async
  {
    try {
      var usersRef = _dbRef.child('user');

      var imgfile = FirebaseStorage.instance
        .ref()
        .child("UserImages")
        .child("/{userId}.jpg");

      UploadTask task = imgfile.putFile(file);
      TaskSnapshot snapshot = await task;

      var url = await snapshot.ref.getDownloadURL();

      await usersRef.child(userId).child("image").set(url);
      _authService.updateCacheInfo(userId);
    } on Exception catch (e) {}
  }
}