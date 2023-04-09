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

import '../models/user.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => Profile();
}

class Profile extends State<ProfileView> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();

  File? file;
  String? userId;
  String? userImage;
  ImagePicker image = ImagePicker();
  var url;

  bool isSelectUserImage = false;

  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    getLocalData();
    dbRef = FirebaseDatabase.instance.ref().child('user');
    GetImg();
    //  GetDataFromDb_data();
  }

  Future<String> GetDataFromDb_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    DataSnapshot snapshot = await dbRef!.child(userId.toString()).get();
    username.text = snapshot.child('username').value.toString();
    email.text = snapshot.child('email').value.toString();
    userImage = snapshot.child('image').value.toString();
    // url = snapshot.child('image').value.toString();
    return snapshot.child('image').value.toString();
  }

  void GetImg() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    DataSnapshot snapshot = await dbRef!.child(userId.toString()).get();
    // url = snapshot.child('image').value.toString();
  }

  saveLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId.toString());
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  @override
  Widget build(BuildContext context) {
    String? str;
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          FutureBuilder(
              future: GetDataFromDb_data(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                Widget child;
                if (snapshot.connectionState == ConnectionState.done) {
                  str = snapshot.data;
                  child = Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 160,
                              width: 160,
                              child: Stack(children: [
                                Center(
                                  child: Container(
                                    height: 160,
                                    width: 160,
                                    child: file == null
                                        ? IconButton(
                                            icon: str == null
                                                ? Icon(Icons.add_a_photo,
                                                    size: 90,
                                                    color: Colors.lightBlue)
                                                : CircleAvatar(
                                                    radius: 70,
                                                    backgroundImage:
                                                        NetworkImage('$str'),
                                                  ),
                                            onPressed: () {
                                              getImage();
                                            },
                                          )
                                        : MaterialButton(
                                            height: 100,
                                            child: Image.file(file!,
                                                fit: BoxFit.fill),
                                            onPressed: () {
                                              getImage();
                                            },
                                          ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Visibility(
                                    visible: isSelectUserImage,
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Center(
                                        child: CircleAvatar(
                                          child: IconButton(
                                            onPressed: () {
                                              if (file != null) {
                                                uploadFile();
                                              }
                                            },
                                            icon: Icon(
                                              Icons.save_as,
                                              size: 22,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),

                          Text(
                            username.text,
                            style: TextStyle(
                              fontSize: 23,
                            ),
                          ),

                          Text(
                            email.text,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          // CupertinoSwitch(
                          //   value: _switchValue,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _switchValue = value;
                          //     });
                          //   },
                          // ),
                          SizedBox(
                            height: 200,
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    elevation: 0,
                                    color: Color.fromARGB(255, 233, 232, 232),
                                    child: ButtonsTabBar(
                                      splashColor:
                                          Color.fromARGB(255, 125, 228, 247),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 255, 255),
                                      unselectedBackgroundColor:
                                          Color.fromARGB(255, 233, 232, 232),
                                      unselectedLabelStyle:
                                          TextStyle(color: Colors.black),
                                      labelStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                      tabs: [
                                        Tab(
                                          child: SizedBox(
                                            width: 120,
                                            child: Center(
                                              child: Text(
                                                'посты',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: SizedBox(
                                            width: 120,
                                            child: Center(
                                              child: Text('понравилось',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: <Widget>[
                                        Center(
                                          child: Icon(Icons.directions_car),
                                        ),
                                        Center(
                                          child: Icon(Icons.directions_transit),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                  str = snapshot.data;
                  return child;
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    ));
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
          .child("UserImages")
          .child("/${username.text}.jpg");

      UploadTask task = imgfile.putFile(file!);
      TaskSnapshot snapshot = await task;

      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
        await dbRef!.child(userId.toString()).child("image").set(url);

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
