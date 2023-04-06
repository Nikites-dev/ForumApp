import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:forum_app/widgets/inputWidget.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthServices _service = AuthServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future SignIn() async {
    var user =
        await _service.signIn(_emailController.text, _passwordController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                    'Авторизация',
                    style: TextStyle(fontSize: 30, color: Colors.cyan),
                  ),
                ],
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
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      final snackBar = SnackBar(
                        content: const Text('Fill in all the fields!'),
                        backgroundColor: Colors.primaries.first,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      // <-- при неверных данных перекидывает в regPage
                      SignIn();
                      Navigator.pushNamed(context, '/');
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
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New to Forum?'),
                  TextButton(
                    onPressed: () => Navigator.popAndPushNamed(context, "/reg"),
                    child: const Text(
                      'Create an account.',
                      style: TextStyle(
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
