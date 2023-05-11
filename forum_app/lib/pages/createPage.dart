import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forum_app/pages/mainViewPager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:xid/xid.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'interestsPage.dart';

class CreatePage extends StatefulWidget {
  @override
  State<CreatePage> createState() => Create();
}

class Create extends State<CreatePage> {

  // String name, email, phone;
  final TextEditingController edTitlePost = TextEditingController();
  final TextEditingController edTextPost = TextEditingController();
  Post? newPost = new Post();
  String? username;
  File? file;

  String? userId;
  String? userImage;
  ImagePicker image = ImagePicker();
  var url;

  bool isSelectUserImage = false;
  var xid = Xid();
 DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('user');
  }

  @override
  Widget build(BuildContext context) {
    List<Choice> choices = <Choice>[
      Choice(title: "Menu 1", icon: Icons.arrow_drop_up_rounded),
    ];

 

    SharedPreferences prefs;
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: InkWell(
            child: Row(
              children: [
                Text(
                  'Далее',
                ),
                Icon(Icons.keyboard_arrow_right_rounded),
              ],
            ),
            onTap: () async => {

              if(edTextPost.text.trim() != "" && edTitlePost.text.trim() != "")
              {


                  prefs = await SharedPreferences.getInstance(),
                  username = prefs.getString('userId'),
                newPost?.username = username.toString(),
                newPost?.title = edTitlePost.text.toString(),
                newPost?.text = edTextPost.text.toString(),
                newPost?.createPost = DateTime.now(),
              //   newPost?.username = prefs.getString('userId'),
                uploadFile(),
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InterestsPage(post: newPost,)))  
              } else
              {
              
              }
            },
          ),
        )
      ]),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Container(height: 80),
            Column(
              children: [

               file != null? 
                 MaterialButton(
                  height: 100,
                  child: Image.file(file!,
                      fit: BoxFit.fill),
                  onPressed: () {
                    getImage();
                  },
                ):Text('dsd'),
                 


                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    autofocus: true,
                    controller: edTitlePost,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 200,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 32,
                          fontWeight: FontWeight.w700),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: edTextPost,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 350,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration.collapsed(
                      hintText: 'body text (optional)',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // PopupMenuButton(
              //   icon: Icon(
              //     Icons.arrow_drop_up_rounded,
              //     color: Colors.white,
              //   ),
              //   itemBuilder: (BuildContext context) {
              //     return choices.map((Choice choice) {
              //       return PopupMenuItem<Choice>(
              //         value: choice,
              //         child: Text(choice.title),
              //       );
              //     }).toList();
              //   },
              // ),

              InkWell(onTap: () => {
            
                  getImage(),
                                              
            
              }, child: Icon(Icons.image_outlined)),

              InkWell(
                onTap: () => {FocusManager.instance.primaryFocus?.unfocus()},
                child: Icon(Icons.arrow_drop_down_rounded),
              ),
            ],
          ),
        )),
      ),
    );
  }

 
 getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
      setState(() {
      file = File(img!.path);
    });

    isSelectUserImage = true;
  }

  uploadFile() async {
    try {
      var imgfile = FirebaseStorage.instance
          .ref()
          .child("PostImages")
          .child("/${xid.toString()}.jpg");

      UploadTask task = imgfile.putFile(file!);
      TaskSnapshot snapshot = await task;

      url = await snapshot.ref.getDownloadURL();
  
        url = url;
    
      if (url != null) {
        newPost?.imgUrl = url.toString();

        isSelectUserImage = false;

        // await dbRef!.child(userId).set(_usernameController.text.toString());
        // Map<String, String> User = {
        //   'username': username.text,
        //   'email': email.text,
        // };

        // dbRef!.push().set(User).whenComplete(() {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (_) => HomePage(),
        //     ),
        //   );
        // });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  GetImgUser() {}


}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
