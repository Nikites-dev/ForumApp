import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forum_app/pages/mainViewPager.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                                height: 200,
                                width: 200,
                                child: file == null
                                    ? IconButton(
                                        icon: str == null
                                            ? Icon(Icons.add_a_photo,
                                                size: 90,
                                                color: Colors.lightBlue)
                                            : Image.network('$str'),
                                        onPressed: () {
                                          getImage();
                                        },
                                      )
                                    : MaterialButton(
                                        height: 100,
                                        child:
                                            Image.file(file!, fit: BoxFit.fill),
                                        onPressed: () {
                                          getImage();
                                        },
                                      )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: username,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Username',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email',
                            ),
                            maxLength: 10,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            height: 40,
                            onPressed: () {
                              if (file != null) {
                                uploadFile();
                              }
                            },
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            color: Colors.lightGreen,
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
