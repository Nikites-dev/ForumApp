import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:forum_app/services/image_service.dart'; 
import 'package:provider/provider.dart';

import '../models/comment.dart';
import '../models/post.dart';
import 'auth/model.dart';

class PostService
{
  final ImageService _imgService = ImageService();
  final AuthServices _authServices = AuthServices();

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

  Future<void> likePost(BuildContext context, Post post) async
  {
    post.likes ??= [];

    var userId = Provider.of<UserModel?>(context, listen: false)!.id;

    if (post.likes!.contains(userId))
    {
      post.likes!.remove(userId);
    }
    else{
      post.likes!.add(userId);
    }

    var dbRef = FirebaseDatabase.instance.ref().child('post');
    
    if (post.likes!.isEmpty)
    {
      dbRef.child(post.id!).child('likes').set("null");
    }
    else
    {
      dbRef.child(post.id!).child('likes').set(post.likes);
    }
  }

  List<Post> convertPosts(Map<dynamic, dynamic> postsMap) {
    List<Post> posts = [];

    if (postsMap.isNotEmpty)
    {
      postsMap.forEach((key, value) {
        final post = Post.fromMap(value);
        posts.add(post);
      });
    }
    
    return posts;
  }

  Future<void> sendComment(BuildContext context, Post post, String text) async
  {
    post.comments ??= [];

    var dbRef = FirebaseDatabase.instance.ref().child('user');
    var userId = Provider.of<UserModel?>(context, listen: false)!.id;
    
    post.comments!.add(Comment(userId, text, DateTime.now()));

    dbRef = FirebaseDatabase.instance.ref().child('post');

    if(post.comments!.isEmpty)
    {
      dbRef.child(post.id!).child('comments').set("null");
    }
    else{
      var newKey = dbRef.child(post.id!).child('comments').push();
      var keyValue = newKey.key.toString();
      dbRef.child(post.id!).child('comments').child(keyValue).child('username').set(userId);
      dbRef.child(post.id!).child('comments').child(keyValue).child('text').set(post.comments!.last.text);
      dbRef.child(post.id!).child('comments').child(keyValue).child('createdDate').set(post.comments!.last.createdDate.toString());
    }
  }

  List<Post> getPostByInterests(List<int> interests, List<Post> posts, String searchText)
  {
    List<Post> filteredList = posts
        .where((Post post) => post.title!.toLowerCase().contains(searchText.toLowerCase()) && interests.contains(post.interestsId))
        .toList();

    filteredList.sort(((a, b) => b.createPost!.compareTo(a.createPost!)));
    return filteredList;
  }

  List<Post> getLikedPosts(List<Post> posts, String searchText, String userId)
  {
    List<Post> filteredList = posts
        .where((Post post) => (post.likes != null ? post.likes!.contains(userId) : false) && post.title!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    filteredList.sort(((a, b) => b.createPost!.compareTo(a.createPost!)));
    return filteredList;
  }

  List<Post> getUserPosts(List<Post> posts, String searchText, String userId)
  {
    List<Post> filteredList = posts
        .where((Post post) => post.title!.toLowerCase().contains(searchText.toLowerCase()) && post.username == userId)
        .toList();

    filteredList.sort(((a, b) => b.createPost!.compareTo(a.createPost!)));
    return filteredList;
  }
}