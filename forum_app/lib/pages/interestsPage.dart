import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:forum_app/models/Interests.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/interest.dart';
import '../models/post.dart';
import '../services/auth/model.dart';

class InterestsPage extends StatefulWidget {
  Post? post;
  InterestsPage({super.key, required this.post});

  @override
  State<InterestsPage> createState() => _InterestsPageState(post);
}

class _InterestsPageState extends State<InterestsPage> {
  Post? post;
  bool isCreatePost = false;
  List<String> _selectedInterests = [];
  String? userId;
  DatabaseReference? dbRef;

  _InterestsPageState(Post? crntPost) {
    post = crntPost;
  }

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref();
    getLocalData();

    if (post != null) {
      isCreatePost = true;
    }
  }

  UploadUserInterestsToDb() async {
    if (userId != null && post == null) {
      await dbRef!
          .child('user')
          .child(userId.toString())
          .child("interests")
          .set(_selectedInterests);
    }
  }

  UploadPostToDb() async {
    if (post != null) {
// dbRef!.child('post').push(
//       post.comments
//    )
//    .then((snapshot) => {
//       ref.child(snapshot.key).update({
//          "id": snapshot.key
//       })
//    });

      // await dbRef!.child('post').set(post?.username.toString());
      // await dbRef!.child('post').set(post?.title.toString());
      // await dbRef!.child('post').set(post?.text.toString());
      // await dbRef!.child('post').set(post?.imgUrl.toString());
      // await dbRef!.child('post').set(post?.interestsId.toString());
      // await dbRef!.child('post').set(post?.createPost.toString());
      // await dbRef!.child('post').set(post?.comments.toString());
      // await dbRef!.child('post').set(post?.likes.toString());
    }
  }

  getLocalData() async {
    // Async func to handle Futures easier; or use Future.then
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const Text("Interests",
                style: TextStyle(fontSize: 30, color: Colors.cyan)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            const Text("Choose interests",
                style: TextStyle(fontSize: 20, color: Colors.cyan)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              flex: 1,
              child: Wrap(
                children: _buildGridTileList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedInterests.isEmpty) {
                  final snackBar = SnackBar(
                    content: const Text('Select interests!'),
                    backgroundColor: Colors.primaries.first,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  if (post == null) {
                    UploadUserInterestsToDb();
                    Navigator.pushNamed(context, "/");
                  } else {
                    UploadPostToDb();
                    Navigator.pushNamed(context, "/home");
                  }
                }
              },
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGridTileList() =>
      List.generate(Interests.list.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 4,
            right: 4,
          ),
          child: ActionChip(
            avatar: Interests.list[i].icon,
            label: Text(Interests.list[i].name.toString(),
                style: const TextStyle(fontSize: 20, color: Colors.black54)),
            backgroundColor: _selectedInterests.contains(Interests.list[i].name)
                ? const Color.fromARGB(255, 189, 243, 192)
                : Colors.white,
            onPressed: () {
              setState(() {
                if (isCreatePost) {
                  _selectedInterests.clear();
                }

                if (_selectedInterests.contains(Interests.list[i].name)) {
                  _selectedInterests.remove(Interests.list[i].name);
                  return;
                }

                if (isCreatePost) {
                  post?.interestsId = i;
                }
                _selectedInterests.add(Interests.list[i].name!);
              });
            },
            pressElevation: 5,
            side: const BorderSide(color: Colors.cyan, width: 1),
          ),
        );
      });
}
