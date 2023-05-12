import 'package:flutter/material.dart';
import 'package:forum_app/pages/homeView.dart';
import 'package:forum_app/pages/profileView.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/inputWidget.dart';
import 'createPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<User> users = List.from(DBConnection().listUserMap());
  // Future users = DBConnection().list();

  final TextEditingController _searchController = TextEditingController();
  int index = 0;
  final listPages = [
    MainView(),
    ProfileView(),
  ];

  RemoveLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 28.0, 8.0),
            child: SizedBox(
              width: 250,
              child: InputWidget(
                _searchController,
                color: Colors.black,
                icon: Icon(Icons.search, color: Colors.black),
                labelText: 'Search',
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await AuthServices().logOut();
              await RemoveLocalData();
              Navigator.popAndPushNamed(context, '/');
              // Navigator.pop(context);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: listPages.elementAt(index),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => Navigator.(context) => CreatePage()));
          Navigator.popAndPushNamed(context, '/create');
        },
        backgroundColor: Colors.cyan.shade700,
        child: const Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: Colors.cyan,
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Главная",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: "Профиль",
          )
        ],
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
      ),
      // body: ListView(
      //   physics: const BouncingScrollPhysics(),
      //   children: users.map((user) {
      //     return Card(
      //       child: ListTile(
      //         title: Text(user.name!),
      //         subtitle: Text(user.login!),
      //         onTap: () {},
      //       ),
      //     );
      //   }).toList(),
      // ),
      // body: ListView.builder(
      //   itemCount: users.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(users as String),
      //     );
      //   },
      // ),
    );
  }
}
