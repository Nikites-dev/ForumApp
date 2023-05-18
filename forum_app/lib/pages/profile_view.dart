import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:forum_app/pages/interests_page.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:forum_app/services/image_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/auth/model.dart';
import '../widgets/posts_list_widget.dart';

class ProfileView extends StatefulWidget {
  final String searchText;
  ProfileView(this.searchText, {super.key,});

  @override
  State<ProfileView> createState() => Profile();
}

class Profile extends State<ProfileView> {
  final AuthServices _authServices = AuthServices();
  final ImageService _imageService = ImageService();
  late List<Widget> tabBarViews;
  late List<Widget> tabs;
  bool _loading = false;
  User? user;
  bool isSelectUserImage = false;

  File? file;
  ImagePicker imagePicker = ImagePicker();

  void setUserInfo() async{
    user = await _authServices.getUser(Provider.of<UserModel?>(context, listen: false)!.id);
    if (mounted)
    {
      setState(() {});
    }
  }

  selectImage() async {
    var img = await imagePicker.pickImage(source: ImageSource.gallery);
    if (img != null)
    {
      setState(() {
        file = File(img.path);
      });
      isSelectUserImage = true;
    }
  }

  uploadFile() async {
    if (file != null)
    {
      setState(() {
        _loading = true;
      });
      await _imageService.uploadUserImage(file!, Provider.of<UserModel?>(context, listen: false)!.id);
      setState(() {
        isSelectUserImage = false;
        _loading = false;
      });
      file = null;
      setUserInfo();
    }
  }
  
  @override
  void initState() {
    super.initState();
    setUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    tabs = [
      const Tab(
        icon: Icon(Icons.person),
        text: 'Мои посты',
      ),
      const Tab(
        icon: Icon(CupertinoIcons.heart_fill),
        text: 'Понравившиеся',
      ),
    ];

    tabBarViews = [
      PostsListWidget(false, false, true, widget.searchText),
      PostsListWidget(false, true, false, widget.searchText),
    ];

    return DefaultTabController(
      length: tabs.length, 
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled)
          {
            return [ 
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child:
                      !_loading ? SizedBox(
                        height: 160,
                        width: 160,
                        child: Stack(children: [
                          Center(
                            child: SizedBox(
                              height: 160,
                              width: 160,
                              child: file == null
                                ? IconButton(
                                    icon: user == null || user!.image == null || user!.image == 'null'
                                      ? CircleAvatar(
                                          radius: 70,
                                          child: Text(user != null && user!.username != null ? user!.username![0] : '', 
                                            style: const TextStyle(fontSize: 50,color: Colors.white),
                                          ),
                                      )
                                      : CircleAvatar(
                                          radius: 70,
                                          backgroundImage:
                                            NetworkImage(user!.image!),
                                      ),
                                    onPressed: () {
                                      selectImage();
                                    },
                                  )
                                : MaterialButton(
                                    height: 100,
                                    child: Image.file(file!,
                                        fit: BoxFit.fill),
                                    onPressed: () {
                                      selectImage();
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
                                      icon: const Icon(
                                        Icons.save_as,
                                        size: 22,
                                        color:Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ) : LoadingAnimationWidget.fallingDot(color: Colors.cyan, size: 120)
                    ),  
              
                    user != null && user!.username != null
                    ? Text(user!.username!,
                      style: const TextStyle(fontSize: 23,),
                    )
                    : LoadingAnimationWidget.waveDots(color: Colors.cyan, size: 20),
              
                    user != null && user!.email != null
                    ? Text(user!.email!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                    : LoadingAnimationWidget.waveDots(color: Colors.cyan, size: 20),
                
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              InterestsPage(post: null, currentInterests: user != null ? user!.interests : [])));
                      }, 
                      child: const Text('Интересы', 
                        style: TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),
                
                    const SizedBox(
                      height: 10,
                    ),
                    TabBar(tabs: tabs),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(children: tabBarViews),
        ),
      )
    );
  }
}
