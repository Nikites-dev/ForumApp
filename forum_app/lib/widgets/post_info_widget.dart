import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../services/auth/model.dart';
import '../services/post_service.dart';

class PostInfoWidget extends StatefulWidget {
  Post post;
  PostInfoWidget({super.key, required this.post});

  @override
  State<PostInfoWidget> createState() => _PostInfoWidgetState();
}

class _PostInfoWidgetState extends State<PostInfoWidget> {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.post.title!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.post.imgUrl == null || widget.post.imgUrl == "null"
            ? const Text("",)
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
              fontSize: 18, fontWeight: FontWeight.w300),
          ), 
        ),
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
                Icon(CupertinoIcons.heart_fill,
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
                MaterialStateProperty.all<double>(0),
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
      ],);
  }
}