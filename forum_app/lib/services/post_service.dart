import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:forum_app/services/image_service.dart'; 
import 'package:provider/provider.dart';

import '../models/comment.dart';
import '../models/post.dart';
import 'auth/model.dart';

class PostService
{
  final ImageService _imgService = ImageService();
  final _dbRef = FirebaseDatabase.instance.ref();
  final allPostsStream = FirebaseDatabase.instance.ref('post').onValue;

  Future<Post> createPost(BuildContext context, String title, String text) async
  {
    try{
      var userId = Provider.of<UserModel?>(context, listen: false)!.id;
      var newPost = Post();
      newPost.username = userId.toString();
      newPost.title = title.toString();
      newPost.text = text.toString();
      newPost.createPost = DateTime.now();

      return newPost;
    } on Exception catch(e) {
      return Post();
    }
  }

  savePost(BuildContext context, Post post, File? image) async
  {

    try{
      var postsRef = _dbRef.child('post');
      var newKey = postsRef.push();
      var keyValue = newKey.key.toString();
      post.id = keyValue;

      var userId = Provider.of<UserModel?>(context, listen: false)!.id;

      if (image != null)
      {
        var url = await _imgService.uploadPostImage(image);
        post.imgUrl = url;
      }

      var postRef = postsRef.child(keyValue);

      await postRef.child('id').set(post.id.toString());
      await postRef.child('username').set(userId);
      await postRef.child('title').set(post.title.toString());
      await postRef.child('text').set(post.text.toString());
      await postRef.child('imgUrl').set(post.imgUrl.toString());
      await postRef.child('interestsId').set(post.interestsId.toString());
      await postRef.child('createPost').set(post.createPost.toString());
      await postRef.child('comments').set(post.comments.toString());
      await postRef.child('likes').set(post.likes.toString());
    } on Exception catch (e) {return;} 
  }

  Future<void> likePost(BuildContext context, Post post) async
  {
    try{
      post.likes ??= [];

      var userId = Provider.of<UserModel?>(context, listen: false)!.id;

      if (post.likes!.contains(userId))
      {
        post.likes!.remove(userId);
      }
      else{
        post.likes!.add(userId);
      }

      var postsRef = _dbRef.child('post');
      
      if (post.likes!.isEmpty)
      {
        postsRef.child(post.id!).child('likes').set("null");
      }
      else
      {
        postsRef.child(post.id!).child('likes').set(post.likes);
      }
    } on Exception catch(e) {return;}
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
    try {
      post.comments ??= [];

      var userId = Provider.of<UserModel?>(context, listen: false)!.id;
      
      post.comments!.add(Comment(userId, text, DateTime.now()));

      var postsRef = _dbRef.child('post');

      if(post.comments!.isEmpty)
      {
        postsRef.child(post.id!).child('comments').set("null");
      }
      else{
        var newKey = postsRef.child(post.id!).child('comments').push();
        var keyValue = newKey.key.toString();
        var comment = postsRef.child(post.id!).child('comments').child(keyValue);

        comment.child('username').set(userId);
        comment.child('text').set(post.comments!.last.text);
        comment.child('createdDate').set(post.comments!.last.createdDate.toString());
      }
    } on Exception catch(e) {return;}
  }

  List<Post> getPostByInterests(List<int> interests, List<Post> posts, String searchText)
  {
    var searchStr = searchText.toLowerCase();
    List<Post> filteredList = posts
        .where((Post post) => (post.title!.toLowerCase().contains(searchStr)
        || post.text!.toLowerCase().contains(searchText))  && interests.contains(post.interestsId))
        .toList();

    filteredList.sort(((a, b) => b.createPost!.compareTo(a.createPost!)));
    return filteredList;
  }

  List<Post> getLikedPosts(List<Post> posts, String searchText, String userId)
  {
    var searchStr = searchText.toLowerCase();
    List<Post> filteredList = posts.where((Post post) => 
        (post.likes != null ? post.likes!.contains(userId) : false) 
        && (post.title!.toLowerCase().contains(searchStr)
        || post.text!.toLowerCase().contains(searchText)))
        .toList();

    filteredList.sort(((a, b) => b.createPost!.compareTo(a.createPost!)));
    return filteredList;
  }

  List<Post> getUserPosts(List<Post> posts, String searchText, String userId)
  {
    var searchStr = searchText.toLowerCase();
    List<Post> filteredList = posts
        .where((Post post) => (post.title!.toLowerCase().contains(searchStr)
        || post.text!.toLowerCase().contains(searchText)) && post.username == userId)
        .toList();

    filteredList.sort(((a, b) => b.createPost!.compareTo(a.createPost!)));
    return filteredList;
  }
}