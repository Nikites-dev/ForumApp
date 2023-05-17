import 'package:flutter/material.dart';
import 'package:forum_app/widgets/posts_list_widget.dart';


class MainView extends StatefulWidget {
  final String searchText;
  MainView(this.searchText, {super.key,});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
          Center(
            child: PostsListWidget(true, false, false, widget.searchText),
          ),
      ),
    );
  }
}