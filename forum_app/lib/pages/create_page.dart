import 'package:flutter/material.dart';
import 'dart:io';
import 'package:forum_app/services/post_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../models/post.dart';
import 'interests_page.dart';

class CreatePage extends StatefulWidget {
  @override
  State<CreatePage> createState() => Create();
}

class Create extends State<CreatePage> {
  final PostService _postService = PostService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final bool _loading = false;
  Post? newPost = Post();
  File? file;
  ImagePicker imagePicker = ImagePicker();

  void showSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value),
        backgroundColor: Colors.primaries.first,));
  }

  selectImage() async {
    var img = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (img != null)
      {
        file = File(img.path);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _textController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return !_loading ?  Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: InkWell(
              child: Row(
                children: const [
                    Text(
                    'Далее',
                  ),
                  Icon(Icons.keyboard_arrow_right_rounded),
                ],
              ),
              onTap: () async {
                if(_textController.text.trim() != "" && _titleController.text.trim() != "")
                {
                  newPost = await _postService.createPost(context, _titleController.text.toString(), _textController.text.toString());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InterestsPage(
                        post: newPost,
                        postImgFile: file,)));
                } else {
                  showSnackBar('Заполните заголовок и текст!');
                }
              },
            ),
          )
        ]
      ),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Container(height: 80),
            Column(
              children: [
               file != null? 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                  height: 100,
                  child: Image.file(
                    file!,
                    fit: BoxFit.fill),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    selectImage();
                  },),
                )
                : const Padding(padding: EdgeInsets.all(8.0), child: Text('Изображение не выбрано'),),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    autofocus: true,
                    controller: _titleController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 200,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Заголовок',
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
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 600,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration.collapsed(
                      hintText: 'текст поста',
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
              InkWell(
                onTap: () => {FocusManager.instance.primaryFocus?.unfocus(), selectImage(),},
                child: const Icon(Icons.image_outlined)),
              InkWell(
                onTap: () => {FocusManager.instance.primaryFocus?.unfocus()},
                child: const Icon(Icons.arrow_drop_down_rounded),
              ),
            ],
          ),
        )),
      )
    ) : Scaffold(body: Center(child: LoadingAnimationWidget.fallingDot(color: primaryColor, size: 60),));
  }
}