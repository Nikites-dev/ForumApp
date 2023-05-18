import 'package:flutter/material.dart';
import 'package:forum_app/pages/main_view.dart';
import 'package:forum_app/pages/profile_view.dart';
import 'package:forum_app/services/auth/service.dart';
import '../widgets/input_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int index = 0;
  List<Widget> listPages = [];

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
      ProfileView(_searchController.text),
    ];

    var primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 28.0, 8.0),
            child: SizedBox(
              width: 250,
              child: InputWidget(
                _searchController,
                color: Colors.black54,
                icon: const Icon(Icons.search, color: Colors.black54),
                labelText: 'Search',
                cursorColor: Colors.black54,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await AuthServices().logOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.black54,),
          ),
        ],
      ),
      body: listPages.elementAt(index),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.pushNamed(context, '/create');
        },
        backgroundColor: Colors.cyan.shade500,
        child: const Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: primaryColor,
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
    );
  }
}
