import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:forum_app/models/Interests.dart';
import 'package:forum_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/pages/postPage.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // List<Post> posts = List.from(listPosts);

  List<Post> posts = [];
  DatabaseReference? dbRef;
  DatabaseReference? dbRefUser;
  int index = 0;

  Future<List<Post>> getListPosts() async {
    final snapshot = await FirebaseDatabase.instance.ref('post').get();

    final map = snapshot.value as Map<dynamic, dynamic>;

    map.forEach((key, value) {
      final user = Post.fromMap(value);
      posts.add(user);
    });
    return posts;
  }


  @override
  void initState() {
    super.initState();
    dbRefUser = FirebaseDatabase.instance.ref().child('user');
  }

  Future<User> GetUserFromDb(String userId) async {
    DataSnapshot snapshot = await dbRefUser!.child(userId.toString()).get() ;
    return new User(
        Username: snapshot.child('username').value.toString(),
        Email: snapshot.child('email').value.toString(),
        Image: snapshot.child('image').value.toString(),
        Interests: null,
        Password: null);
  }

  String GetInterestById(int id)
  {
    return Interests.list[id].name.toString();
  }


  // onItemSearch(String value) {
  //   setState(
  //     () {
  //       posts = listPosts
  //           .where((element) => element.username!.contains(value))
  //           .toList();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // List<Post> posts = [];
    //posts = getListPosts();
    List<Post>? crntPosts = [];
    return SafeArea(
        child: Scaffold(
          body:
              Center(
                child: FutureBuilder(
                    future: getListPosts(),
                    builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                      Widget child;
                      if (snapshot.connectionState == ConnectionState.done) {
                         crntPosts = snapshot.data;
                        // posts = List.from(listPosts);
                        child = Center(
                          child: ListView(
                            children: crntPosts!.map(
                                  (post) {
                                    User? userPost;
                                    String? img;
                                    String? username;
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              PostPage(post: post)));
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                 FutureBuilder(

                                                     future: GetUserFromDb(post.username.toString()),
                                                  builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                                                  Widget childUser;
                                                  if (snapshot.connectionState == ConnectionState.done) {
                                                   userPost = snapshot.data;
                                                     img = userPost?.Image;
                                                    username = userPost?.Username;
                                                    childUser =  Row(children: [


                                                      Padding(
                                                        padding: const EdgeInsets.all(
                                                            8.0),
                                                        child: CircleAvatar(
                                                          backgroundImage: NetworkImage(
                                                              img.toString()),
                                                        ),
                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.all(
                                                            1.0),
                                                        child: Text(username.toString()),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(
                                                            1.0),
                                                        child: Text('10 ч.'),
                                                      ),



                                                    ],);
                                                    return childUser;
                                                  }
                                                  return Center(child: CircularProgressIndicator());
                                                  }
                                                ),


                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(GetInterestById( post.interestsId!)),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: new Text(
                                                SetText(post.title!),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: post.imgUrl == null
                                                  ? new Text(
                                                SetText(post.text!),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300),
                                              )
                                                  : CachedNetworkImage(
                                                imageUrl: post.imgUrl!,
                                                placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                                errorWidget: (context, url,
                                                    error) =>
                                                new Icon(Icons.error),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: Container(
                                                child: Row(children: [
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                        child: Row(children: [
                                                          Icon(Icons
                                                              .arrow_upward_rounded,
                                                              color: Colors.grey),
                                                          SizedBox(width: 2.0),
                                                          Text("1412",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                        ]),
                                                        onPressed: () {},
                                                        style: ButtonStyle(
                                                          elevation:
                                                          MaterialStateProperty.all<
                                                              double>(0),
                                                          backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(children: [
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons
                                                              .message_outlined,
                                                              color: Colors.grey),
                                                          SizedBox(width: 5.0),
                                                          Text(
                                                            "8",
                                                            style: TextStyle(
                                                                color: Colors.grey),
                                                          ),
                                                        ],
                                                      ),
                                                      style: ButtonStyle(
                                                        elevation:
                                                        MaterialStateProperty.all<
                                                            double>(0),
                                                        backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.white),
                                                      ),
                                                    ),
                                                  ]),
                                                ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        );
                        return child;
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
        ));

  }

}
String SetText(String text) {
  if (text.length > 150) {
    return text.toString().substring(0, 150).trim() + "...";
  }
  return text;
}




// Row(
// children: <Widget>[
// Flexible(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: new Text(post.title!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// ),),
// Flexible(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: new Text(post.text.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
// ),),
// ],
// ),