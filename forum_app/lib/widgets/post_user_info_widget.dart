import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/post.dart';
import '../services/auth/service.dart';
import 'interest_chip_widget.dart';

class PostUserInfoWidget extends StatefulWidget {
  Post post;
  String? userName;
  String? userImg = "";

  PostUserInfoWidget({super.key, required this.post});

  @override
  State<PostUserInfoWidget> createState() => _PostUserInfoWidgetState();
}

class _PostUserInfoWidgetState extends State<PostUserInfoWidget> {
  final AuthServices _authServices = AuthServices();
  final DateFormat _dateFormatter = DateFormat('dd.MM.y HH:mm');
  
  Future<void> loadUserInfo() async
  {
    var info = await _authServices.getUserInfo(widget.post.username!);
    widget.userImg = info.userImg;
    widget.userName = info.username;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
              child: InterestChipWidget(post: widget.post)
            ),
          ],
        ),
      ],
    );
  }
}