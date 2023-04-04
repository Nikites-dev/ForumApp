import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forum_app/pages/mainViewPager.dart';


class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => Profile();
}

class Profile extends State<ProfileView> {

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  File? file;
  ImagePicker image = ImagePicker();
  var url;

  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('user');
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
                 icon: Icon(
                   Icons.add_a_photo,
                   size: 90,
                   color: Colors.lightBlue
                 ),
                 onPressed: () {
                   getImage();
                 },
               )
             : MaterialButton(
                 height: 100,
                 child: Image.file(
                   file!,
                   fit: BoxFit.fill
                 ),
                 onPressed: () {
                   getImage();
                 },
               )
             ),
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

               if(file != null) {
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

  getImage() async{
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadFile() async {
    try {
      var imgfile = FirebaseStorage.instance.ref().child("UserImages").child("/${username.text}.jpg");

    UploadTask task = imgfile.putFile(file!);
    TaskSnapshot snapshot = await task;

    url = await snapshot.ref.getDownloadURL();
    setState(() {
      url = url;
    });
    if(url != null) {
      Map<String, String> User = {
        'username': username.text,
        'email': email.text,
      };

      dbRef!.push().set(User).whenComplete(() {
        Navigator.pushReplacement(context,
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
        );
      });
    }
    } on Exception catch (e) {
      print(e);
    }
  }
}




