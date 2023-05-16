import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/models/post.dart';
import 'package:forum_app/pages/post_page.dart';
import 'package:forum_app/widgets/post_info_widget.dart';
import 'package:forum_app/widgets/post_user_info_widget.dart';

import '../services/post_service.dart';

class MainView extends StatefulWidget {
  final String searchText;
  MainView( this.searchText, {super.key,});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final PostService _postService = PostService();
  List<Post> posts = [];

  filterList() {
    List<Post> filteredList = posts
        .where((Post post) => post.title!.toLowerCase().contains(widget.searchText.toLowerCase()))
        .toList();

    filteredList.sort(((a, b) => b.createPost!.compareTo(a.createPost!)));

    posts = filteredList;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
          Center(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance.ref('post').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                {
                  posts = _postService.convertPosts(snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
                  filterList();

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PostPage(post: posts[index])));
                          },
                          child: Column(
                            children: [
                              PostUserInfoWidget(post: posts[index]),
                              PostInfoWidget(post: posts[index], isForList: true)
                          ]),
                        ),
                      );
                    },
                  );
                }
                return const Padding(padding: EdgeInsets.all(0.0));
              },
            )
          ),
      ),
    );
  }
}