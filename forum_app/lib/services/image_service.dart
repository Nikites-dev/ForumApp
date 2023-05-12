import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:xid/xid.dart';

class ImageService
{
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
}