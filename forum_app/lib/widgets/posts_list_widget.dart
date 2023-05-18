import 'package:flutter/material.dart';
import 'package:forum_app/widgets/post_info_widget.dart';
import 'package:forum_app/widgets/post_user_info_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../pages/post_page.dart';
import '../services/auth/model.dart';
import '../services/auth/service.dart';
import '../services/post_service.dart';

class PostsListWidget extends StatefulWidget {
  final String searchText;
  final bool isInterestedPosts;
  final bool isLikedPosts;
  final bool isUserPosts;
  const PostsListWidget(this.isInterestedPosts, this.isLikedPosts, this.isUserPosts, this.searchText, {super.key,});

  @override
  State<PostsListWidget> createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends State<PostsListWidget> {
  final AuthServices _authServices = AuthServices();
  final PostService _postService = PostService();
  List<int> userInterests = [];
  List<Post> posts = [];

  filterList() {
    if (widget.isInterestedPosts)
    {
      posts = _postService.getPostByInterests(userInterests, posts, widget.searchText);
    }
    
    if (widget.isLikedPosts)
    {
      posts = _postService.getLikedPosts(posts, widget.searchText, Provider.of<UserModel?>(context, listen: false)!.id);
    }

    if (widget.isUserPosts)
    {
      posts = _postService.getUserPosts(posts, widget.searchText, Provider.of<UserModel?>(context, listen: false)!.id);
    }
  }

  void setUserInterests() async{
    if (userInterests.isEmpty)
    {
      userInterests = await _authServices.getUserInterest(Provider.of<UserModel?>(context, listen: false)!.id);
      if (mounted)
      {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    setUserInterests();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _postService.allPostsStream,
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.active
         || snapshot.connectionState == ConnectionState.done)
         && snapshot.data != null)
        {
          posts = _postService.convertPosts(snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
          filterList();

          if (posts.isNotEmpty)
          {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
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
          } else {
            return const Center(child: Text('Нет постов'));
          }
        }
        return LoadingAnimationWidget.fallingDot(color: Colors.cyan, size: 40);
      },
    );
  }
}