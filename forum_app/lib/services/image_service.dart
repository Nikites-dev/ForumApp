import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:xid/xid.dart';

class ImageService
{
  final AuthServices _authService = AuthServices();

  Future<String?> uploadPostImage(File file) async
  {
    var xid = Xid();
    
    try {
      var imgfile = FirebaseStorage.instance
        .ref()
        .child("PostImages")
        .child("/${xid.toString()}.jpg");

      UploadTask task = imgfile.putFile(file);
      TaskSnapshot snapshot = await task;

      var url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return 'null';
    }
  }

  Future<void> uploadUserImage(File file, String userId) async
  {
    try {
      var dbRef = FirebaseDatabase.instance.ref().child('user');

      var imgfile = FirebaseStorage.instance
        .ref()
        .child("UserImages")
        .child("/{userId}.jpg");

      UploadTask task = imgfile.putFile(file!);
      TaskSnapshot snapshot = await task;

      var url = await snapshot.ref.getDownloadURL();

      await dbRef.child(userId).child("image").set(url);
      _authService.updateCacheInfo(userId);
    } on Exception catch (e) {
      print(e);
    }
  }
}