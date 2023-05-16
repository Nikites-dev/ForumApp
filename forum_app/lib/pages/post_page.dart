import 'package:flutter/material.dart';
import 'package:forum_app/models/post.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:forum_app/services/post_service.dart';
import 'package:forum_app/widgets/post_info_widget.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../widgets/inputWidget.dart';
import '../widgets/post_user_info_widget.dart';

class PostPage extends StatefulWidget {
  Post post;

  PostPage({super.key, required this.post});
  
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final AuthServices _authServices = AuthServices();
  final PostService _postService = PostService();
  final ScrollController _scrollController = ScrollController(); 
  final TextEditingController _commentController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('dd.MM.y HH:mm');
  bool isFirstBuild = true;
  bool isCommentFilled = false;

  Future<void> cacheUsersInfo() async
  {
    await _authServices.cacheUserInfo(widget.post.comments!, isFirstBuild);
    isFirstBuild = false;
  }

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {
        isCommentFilled = _commentController.text.isNotEmpty;
      });
    });
  }

  Widget commentsListView()
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
                PostUserInfoWidget(post: widget.post),
                PostInfoWidget(post: widget.post),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                      future: cacheUsersInfo(),
                      builder: (context, snapshot)
                      {
                        return commentsListView();
                      }) ,
                  ]),
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
                onPressed: !isCommentFilled ? null :  () {
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
