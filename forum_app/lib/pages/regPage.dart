import 'package:flutter/material.dart';
import 'package:forum_app/components/input.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:forum_app/widgets/inputWidget.dart';

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

  Future signIn() async {
    var user =
        await _service.signIn(_emailController.text, _passwordController.text);
  }

  Future signUp() async {
    var user = await _service.register(
        _emailController.text, _passwordController.text);
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
              child: Input(
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
                onPressed: () {
                  signUp();
                  Navigator.pushNamed(context, '/home');
                  print('true');
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
