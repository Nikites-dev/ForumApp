import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/models/interests.dart';
import 'package:forum_app/models/comment.dart';
import 'package:forum_app/models/post.dart';
import 'package:intl/intl.dart';
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
  final ScrollController _scrollController = ScrollController(); 
  final TextEditingController _commentController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('dd.MM HH:MM');

  Future<void> likePost() async
  {
    widget.post.likes ??= [];

    var userId = Provider.of<UserModel?>(context, listen: false)!.id;

    if (widget.post.likes!.contains(userId))
    {
      widget.post.likes!.remove(userId);
    }
    else{
      widget.post.likes!.add(userId);
    }

    var dbRef = FirebaseDatabase.instance.ref().child('post');
    
    if (widget.post.likes!.isEmpty)
    {
      dbRef.child(widget.post.id!).child('likes').set("null");
    }
    else
    {
      dbRef.child(widget.post.id!).child('likes').set(widget.post.likes);
    }
  }

  Future<void> loadUserInfo() async
  {
    var dbRef = FirebaseDatabase.instance.ref().child('user');
    DataSnapshot snapshot = await dbRef.child(widget.post.username!).get();
    widget.userImg = snapshot.child('image').value.toString();
    widget.userName = snapshot.child('username').value.toString();
  }

  Future<void> sendComment() async
  {
    widget.post.comments ??= [];

    var dbRef = FirebaseDatabase.instance.ref().child('user');
    var userId = Provider.of<UserModel?>(context, listen: false)!.id;
    DataSnapshot snapshot = await dbRef.child(userId).get();

    widget.post.comments!.add(Comment(snapshot.child('username').value.toString(), _commentController.text));
    _commentController.clear();

    dbRef = FirebaseDatabase.instance.ref().child('post');

    setState(() {
      if(widget.post.comments!.isEmpty)
      {
        dbRef.child(widget.post.id!).child('comments').set("null");
      }
      else{
        var newKey = dbRef.child(widget.post.id!).child('comments').push();
        var keyValue = newKey.key.toString();
        dbRef.child(widget.post.id!).child('comments').child(keyValue).child('username').set(widget.post.comments!.last.username);
        dbRef.child(widget.post.id!).child('comments').child(keyValue).child('text').set(widget.post.comments!.last.text);
      }
    });
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
                leading: const Icon(Icons.message_outlined),
                title: Text(comment.username!),
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
                                  likePost();
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
                        : commentChild(),
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
                  sendComment();
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                },),
            )
          ]),
        ),
      ),
    );
  }
}
