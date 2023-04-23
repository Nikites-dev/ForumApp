import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:forum_app/widgets/inputWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'interestsPage.dart';

class CreatePage extends StatelessWidget {
  String name, email, phone;
  final TextEditingController edTitlePost = TextEditingController();
  final TextEditingController edTextPost = TextEditingController();

  CreatePage(
      {super.key,
      required this.name,
      required this.email,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    List<Choice> choices = <Choice>[
      Choice(title: "Menu 1", icon: Icons.arrow_drop_up_rounded),
    ];
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
            onTap: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InterestsPage()))
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

              InkWell(onTap: () => {}, child: Icon(Icons.image_outlined)),

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
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
