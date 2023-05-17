import 'package:flutter/material.dart';
import 'package:forum_app/pages/main_view.dart';
import 'package:forum_app/pages/profileView.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/inputWidget.dart';
import 'create_page.dart';

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
  List<Widget> listPages = [];

  RemoveLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
    _searchController.addListener(() {
        setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    listPages = [
      MainView(_searchController.text),
      ProfileView(),
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 28.0, 8.0),
            child: SizedBox(
              width: 250,
              child: InputWidget(
                _searchController,
                color: Colors.black,
                icon: const Icon(Icons.search, color: Colors.black),
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
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.pushNamed(context, '/create');
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
