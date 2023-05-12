import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:forum_app/services/image_service.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import 'auth/model.dart';

class PostService
{
  final ImageService _imgService = ImageService();

  Future<Post> createPost(BuildContext context, String title, String text, File? image) async
  {
    var userId = Provider.of<UserModel?>(context, listen: false)!.id;
    var newPost = Post();
    newPost.username = userId.toString();
    newPost.title = title.toString();
    newPost.text = text.toString();
    newPost.createPost = DateTime.now();
    if (image != null)
    {
      var url = await _imgService.uploadPostImage(image);
      newPost.imgUrl = url;
    }

    return newPost;
  }

  savePost(BuildContext context, Post post)
  {
      var dbRef = FirebaseDatabase.instance.ref().child('post');
      var newKey = dbRef.push();
      var keyValue = newKey.key.toString();
      post.id = keyValue;

      var userId = Provider.of<UserModel?>(context, listen: false)!.id;

      dbRef.child(keyValue).child('id').set(post.id.toString());
      dbRef.child(keyValue).child('username').set(userId);
      dbRef.child(keyValue).child('title').set(post.title.toString());
      dbRef.child(keyValue).child('text').set(post.text.toString());
      dbRef.child(keyValue).child('imgUrl').set(post.imgUrl.toString());
      dbRef.child(keyValue).child('interestsId').set(post.interestsId.toString());
      dbRef.child(keyValue).child('createPost').set(post.createPost.toString());
      dbRef.child(keyValue).child('comments').set(post.comments.toString());
      dbRef.child(keyValue).child('likes').set(post.likes.toString());
  }
}