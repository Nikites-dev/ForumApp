import 'package:cached_network_image/cached_network_image.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:forum_app/models/Interests.dart';
import 'package:forum_app/models/post.dart';
import 'package:forum_app/models/user.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController commentController = TextEditingController();

  Future<void> loadUserInfo() async
  {
    var dbRef = FirebaseDatabase.instance.ref().child('user');
    DataSnapshot snapshot = await dbRef.child(widget.post.username!).get();
    widget.userImg = snapshot.child('image').value.toString();
    widget.userName = snapshot.child('username').value.toString();
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
                title: Text(comment.Username!),
                subtitle: Text(comment.Text!),
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
                              padding: EdgeInsets.all(8.0),
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
                              : Text(DateFormat("yyyy-MM-dd").format(widget.post.createPost!)),
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
                                  loadUserInfo();
                                });
                              },
                              style: ButtonStyle(
                                elevation:
                                    MaterialStateProperty.all<double>(0),
                                backgroundColor:
                                    const MaterialStatePropertyAll(Colors.white),
                              ),
                              child: Row(children: [
                                const Icon(Icons.arrow_upward_rounded,
                                    color: Colors.grey),
                                const SizedBox(width: 2.0),
                                widget.post.likes == null ? const Text("0") : Text(widget.post.likes!.length.toString(),
                                    style: const TextStyle(color: Colors.grey)),
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
          padding: const EdgeInsets.all(8.0),
          child: InputWidget(
            commentController,
            labelText: "Введите сообщение",
            color: Colors.cyan,
            icon: const Icon(Icons.message, color: Colors.cyan),
          ),
        ),
      ),
    );
  }
}
