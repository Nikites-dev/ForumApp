import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:forum_app/models/post.dart';

class PostPage extends StatelessWidget {
  Post post;
  PostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            post.imgUrl != null
                ? Image(
                    image: NetworkImage(post.imgUrl!),
                  )
                : SizedBox(),
            Text('${post.title!}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(' ${post.text!}'),
          ],
        ),
      ),
    );
  }
}
