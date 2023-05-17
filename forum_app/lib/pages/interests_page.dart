import 'package:flutter/material.dart';
import 'package:forum_app/models/interests.dart';
import 'package:forum_app/services/auth/service.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class InterestsPage extends StatefulWidget {
  Post? post;
  List<int>? currentInterests;
  InterestsPage({super.key, required this.post, this.currentInterests});

  @override
  State<InterestsPage> createState() => _InterestsPageState(post);
}

class _InterestsPageState extends State<InterestsPage> {
  final AuthServices _authServices = AuthServices();
  final PostService _postService = PostService();
  Post? post;
  bool isCreatePost = false;
  List<int> _selectedInterests = [];

  _InterestsPageState(Post? crntPost) {
    post = crntPost;
  }

  @override
  void initState() {
    super.initState();

    if (widget.currentInterests != null)
    {
      setState(() {
        _selectedInterests = widget.currentInterests!;
      });
    }

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
                    content: const Text('Выберите тему!'),
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
            backgroundColor: _selectedInterests.contains(i)
                ? const Color.fromARGB(255, 189, 243, 192)
                : Colors.white,
            onPressed: () {
              setState(() {
                if (isCreatePost) {
                  _selectedInterests.clear();
                }

                if (_selectedInterests.contains(i)) {
                  _selectedInterests.remove(i);
                  return;
                }

                if (isCreatePost) {
                  post?.interestsId = i;
                }
                _selectedInterests.add(i);
              });
            },
            pressElevation: 5,
            side: const BorderSide(color: Colors.cyan, width: 1),
          ),
        );
      });
}
