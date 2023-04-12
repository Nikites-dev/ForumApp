import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:forum_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});


  @override
    State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Post> posts = List.from(listPosts);
  int index = 0;
  onItemSearch(String value) {
    setState(
          () {
        posts = listPosts
            .where((element) => element.username!.contains(value))
            .toList();
        // return newDealList
        //     .where(
        //       (element) => element.title!.contains(value),
        //     )
        //     .toList();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: posts.map(
            (post) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.account_circle, size: 32,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(post.username!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text('10 ч.'),
                      ),
                    ],),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('interest'),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Text(post.title!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, ),),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(post.text!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),),)


                  ],
                ),
              ],
            ),



          );
        },
      ).toList(),
    );
  }
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