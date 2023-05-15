import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/models/interests.dart';
import 'package:forum_app/models/post.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:forum_app/services/post_service.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../services/auth/model.dart';
import '../widgets/inputWidget.dart';

class PostPage extends StatefulWidget {
  Post post;
  String? userName;
  String? userImg = "";

  PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final AuthServices _authServices = AuthServices();
  final PostService _postService = PostService();
  final ScrollController _scrollController = ScrollController(); 
  final TextEditingController _commentController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('dd.MM HH:MM');
  bool isFirstBuild = true;
  
  Future<void> loadUserInfo() async
  {
    var info = await _authServices.getUserInfo(widget.post.username!);
    widget.userImg = info.userImg;
    widget.userName = info.username;
  }

  Future<void> loadCommentsInfo() async
  {
    await _authServices.cacheUserInfo(widget.post.comments!, isFirstBuild);
    isFirstBuild = false;
  }

  Widget commentChild()
  { 
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: widget.post.comments!.map(
          (comment) {
            return Card(    
              child: ListTile(
                leading: _authServices.uniqueUsers[comment.username] == null
                  ? LoadingAnimationWidget.fallingDot(color: Colors.cyan, size: 30)
                  : CircleAvatar(
                        backgroundImage: NetworkImage(
                            _authServices.uniqueUsers[comment.username]!.userImg),),
                title:_authServices. uniqueUsers[comment.username] == null
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingAnimationWidget.waveDots(color: Colors.cyan, size: 10),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_authServices.uniqueUsers[comment.username]!.username),
                        Text(_dateFormatter.format(comment.createdDate!), style: const TextStyle(fontSize: 10),)
                      ]
                    ),    
                subtitle: Text(comment.text!),
              ),
            );
          }).toList()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
      ),
      body: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FutureBuilder(
                          future: loadUserInfo(),
                          builder: (context, snapshot)
                          {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    widget.userImg!),
                              )
                            );
                          }
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                              future: loadUserInfo(),
                              builder: (context, snapshot)
                              {
                                return Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(widget.userName ?? ""),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: widget.post.createPost == null 
                              ? const Text("не указано") 
                              : Text(_dateFormatter.format(widget.post.createPost!)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(Interests.list[widget.post.interestsId!].name!),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.post.title!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.post.imgUrl == null
                        ? const Text("Пост без изображения",
                            style: TextStyle(fontSize: 18,))
                        : CachedNetworkImage(
                            imageUrl: widget.post.imgUrl!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.post.text!,
                        style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w300),
                      ), 
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _postService.likePost(context, widget.post);
                                });
                              },
                              style: ButtonStyle(
                                elevation:
                                    MaterialStateProperty.all<double>(0),
                                backgroundColor:
                                    const MaterialStatePropertyAll(Colors.white),
                              ),
                              child: Row(children: [
                                Icon(Icons.arrow_upward_rounded,
                                    color: widget.post.likes == null 
                                    ? Colors.grey 
                                    : (widget.post.likes!.contains(Provider.of<UserModel?>(context, listen: false)!.id) 
                                    ? Colors.red 
                                    : Colors.grey)),
                                const SizedBox(width: 2.0),
                                Text(widget.post.likes == null ? "0" : widget.post.likes!.length.toString(),
                                    style: const TextStyle(
                                      color: Colors.grey),
                                ),
                              ]),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                elevation:
                                MaterialStateProperty.all<
                                    double>(0),
                                backgroundColor:
                                const MaterialStatePropertyAll(
                                    Colors.white),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons
                                      .message_outlined,
                                      color: Colors.grey),
                                  const SizedBox(width: 5.0),
                                  Text(widget.post.comments == null ? "0" : widget.post.comments!.length.toString(),
                                    style: const TextStyle(
                                        color: Colors.grey),
                                  ),
                              ],),
                            ),
                        ],),
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text("Комментарии", style: TextStyle(color: Colors.grey)),
                        ),
                        widget.post.comments == null
                        ? const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text("Комментариев пока нет..."),
                        )
                        : FutureBuilder(
                          future: loadCommentsInfo(),
                          builder: (context, snapshot)
                          {
                            return commentChild();
                          }) ,
                      ]),
                  ],),
                ],),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InputWidget(
              _commentController,
              labelText: "Введите сообщение",
              color: Colors.cyan,
              icon: const Icon(Icons.message, color: Colors.cyan),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.cyan,
                onPressed: () {
                  setState(() {
                    _postService.sendComment(context, widget.post, _commentController.text);
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                    _commentController.clear();
                  });
                },),
            )
          ]),
        ),
      ),
    );
  }
}
