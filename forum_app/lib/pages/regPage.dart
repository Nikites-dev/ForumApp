import 'package:flutter/material.dart';
import 'package:forum_app/services/auth/model.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:forum_app/widgets/inputWidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class RegPage extends StatefulWidget {
  RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final AuthServices _service = AuthServices();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('user');
  }

  Future<bool> signUp() async {
    var user = await _service.register(
        _emailController.text, _passwordController.text);

    if (user != null) {
      saveLocalData(user);
      UploadUserToDb(user);
      return true;
    }
    return false;
  }

  UploadUserToDb(UserModel user) async {
    await dbRef!
        .child(user.id)
        .child("username")
        .set(_usernameController.text.toString());
    await dbRef!
        .child(user.id)
        .child("email")
        .set(_emailController.text.toString());
    await dbRef!
        .child(user.id)
        .child("password")
        .set(_passwordController.text.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  saveLocalData(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user.id);
    prefs.setString('username', _usernameController.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const Text(
                  'Регистрация',
                  style: TextStyle(fontSize: 30, color: Colors.cyan),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.06,
              child: InputWidget(
                _usernameController,
                color: Colors.cyan,
                icon: Icon(Icons.account_circle, color: Colors.cyan),
                labelText: 'Username',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.06,
              child: InputWidget(
                _emailController,
                color: Colors.cyan,
                icon: Icon(Icons.email, color: Colors.cyan),
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.06,
              child: InputWidget(
                _passwordController,
                color: Colors.cyan,
                icon: Icon(Icons.lock, color: Colors.cyan),
                labelText: 'Password',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.06,
              child: InputWidget(
                _passwordConfirmController,
                color: Colors.cyan,
                icon: Icon(Icons.lock, color: Colors.cyan),
                labelText: 'Confirm Password',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                onPressed: () async {
                  if (_passwordController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _usernameController.text.isEmpty) {
                    final snackBar = SnackBar(
                      content: const Text('Fill in all the fields!'),
                      backgroundColor: Colors.primaries.first,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (_passwordController.text.length < 6) {
                    final snackBar = SnackBar(
                      content: const Text('Password minimum 6 symbols!'),
                      backgroundColor: Colors.primaries.first,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (_passwordController.text !=
                      _passwordConfirmController.text) {
                    final snackBar = SnackBar(
                      content: const Text('Passwords don\'t match'),
                      backgroundColor: Colors.primaries.first,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    if (await signUp()) {
                      Navigator.pushNamed(context, '/interests');
                    } else {
                      var snackBar = SnackBar(
                        content: const Text('Something wrong! :('),
                        backgroundColor: Colors.primaries.first,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () => Navigator.popAndPushNamed(context, "/auth"),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.cyan,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
          ],
        )),
      ),
    );
  }
}
