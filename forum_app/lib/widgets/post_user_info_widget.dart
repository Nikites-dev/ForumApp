import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  Future cacheUserInfoFuture = Future(() => null);
  
  Future<void> loadUserInfo() async
  {
    var info = await _authServices.getUserInfo(widget.post.username!);
    widget.userImg = info.userImg;
    widget.userName = info.username;
  }

  Future<bool> cacheUserInfo() async
  {
    await _authServices.cacheInfo(widget.post.username!);

    return true;
  }

  @override
  void initState() {
    super.initState();
    cacheUserInfoFuture = cacheUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
          future: cacheUserInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data == true)
            {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AuthServices.uniqueUsers[widget.post.username]!.userImg != 'null' ? CircleAvatar(
                      backgroundImage: NetworkImage(
                          AuthServices.uniqueUsers[widget.post.username]!.userImg,),
                    )
                    : CircleAvatar(
                      child: Text(AuthServices.uniqueUsers[widget.post.username]!.username != 'null' 
                        ? AuthServices.uniqueUsers[widget.post.username]!.username[0]
                        : '',
                        style: const TextStyle(fontSize: 18,color: Colors.white),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AuthServices.uniqueUsers[widget.post.username]!.username != 'null' ? [
                      Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(AuthServices.uniqueUsers[widget.post.username]!.username),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: widget.post.createPost == null 
                        ? const Text("не указано") 
                        : Text(_dateFormatter.format(widget.post.createPost!), style: const TextStyle(fontSize: 12),),
                      ),
                    ] 
                    : [LoadingAnimationWidget.waveDots(color: Colors.cyan, size: 10),]
                  ),
                ],
              );
            }
            return const Padding(padding: EdgeInsets.all(0.0));
          } 
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