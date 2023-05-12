import 'package:flutter/material.dart';
import 'package:forum_app/models/interests.dart';
import 'package:forum_app/services/auth/service.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class InterestsPage extends StatefulWidget {
  Post? post;
  InterestsPage({super.key, required this.post});

  @override
  State<InterestsPage> createState() => _InterestsPageState(post);
}

class _InterestsPageState extends State<InterestsPage> {
  final AuthServices _authServices = AuthServices();
  final PostService _postService = PostService();
  Post? post;
  bool isCreatePost = false;
  final List<String> _selectedInterests = [];

  _InterestsPageState(Post? crntPost) {
    post = crntPost;
  }

  @override
  void initState() {
    super.initState();

    if (post != null) {
      isCreatePost = true;
    }
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
            const Text("Темы",
                style: TextStyle(fontSize: 30, color: Colors.cyan)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(post == null ? "Выберите интересные для вас темы" : "Выберите тему поста",
                style: const TextStyle(fontSize: 20, color: Colors.cyan)),
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
                    _authServices.updateUserInterests(context, _selectedInterests);
                    Navigator.popAndPushNamed(context, "/");
                  } else {
                    _postService.savePost(context, post!);
                    Navigator.popAndPushNamed(context, "/home");
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
                  'Продолжить',
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
