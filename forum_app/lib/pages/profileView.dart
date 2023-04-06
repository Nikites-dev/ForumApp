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
  ImagePicker image = ImagePicker();
  var url;

  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    getLocalData();
    dbRef = FirebaseDatabase.instance.ref().child('user');
    GetDataFromDb_data();
  }

  void GetDataFromDb_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    if (userId != null) {
      DataSnapshot snapshot =
          await dbRef!.child(userId.toString()).child('username').get();
      username.text = snapshot.value.toString();
    }

    // if (snapshot.exists) {
    //   username.text = snapshot.value.toString();
    // } else {
    //   print('No data available.');
    //   username.text = 'No data available.';
    // }

    // DataSnapshot snapshot = await dbRef!.child('userId').get();

    // username.text = dbRef.child(userId!).get('sd');
    // email.text = Contact.Email!;
    // url = Contact['url'];
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                    height: 200,
                    width: 200,
                    child: file == null
                        ? IconButton(
                            icon: Icon(Icons.add_a_photo,
                                size: 90, color: Colors.lightBlue),
                            onPressed: () {
                              getImage();
                            },
                          )
                        : MaterialButton(
                            height: 100,
                            child: Image.file(file!, fit: BoxFit.fill),
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
      ),
    );
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
          .child("/${dbRef?.child('username').get().toString()}.jpg");

      UploadTask task = imgfile.putFile(file!);
      TaskSnapshot snapshot = await task;

      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
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
}
