import 'package:flutter/material.dart';

import '../models/interests.dart';
import '../models/post.dart';

class InterestChipWidget extends StatefulWidget {
  final Post post;
  const InterestChipWidget({super.key, required this.post});

  @override
  State<InterestChipWidget> createState() => _InterestChipWidgetState();
}

class _InterestChipWidgetState extends State<InterestChipWidget> {

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: () {},
      avatar: Padding(
        padding: const EdgeInsets.only(left: 4.0, bottom: 4.0,),
        child: Icon(Interests.list[widget.post.interestsId!].icon!.icon, color: Colors.black,),
      ),
      label: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(Interests.list[widget.post.interestsId!].name!, style: const TextStyle(fontSize: 12),),
      ),
      backgroundColor: Interests.list[widget.post.interestsId!].backgroundColor!,
    );
  }
}