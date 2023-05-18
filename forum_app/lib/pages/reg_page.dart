import 'package:flutter/material.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:forum_app/widgets/input_widget.dart';

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
  final TextEditingController _passwordConfirmController = TextEditingController();

  Future<bool> signUp() async {
    var regRes = await _service.register(
        _emailController.text, _passwordController.text);

    if (regRes != null)
    {
      showSnackBar(regRes);
      return false;
    }

    if (context.mounted)
    {
      _service.saveUserToDb(context, _usernameController.text, _emailController.text, _passwordController.text);
    }
    return true;
  }

  void showSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value),
        backgroundColor: Colors.primaries.first,));
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordConfirmController.dispose();
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
              child: InputWidget(
                _usernameController,
                color: Colors.cyan,
                icon: const Icon(Icons.account_circle, color: Colors.cyan),
                labelText: 'Имя',
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
                icon: const Icon(Icons.email, color: Colors.cyan),
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
                icon: const Icon(Icons.lock, color: Colors.cyan),
                labelText: 'Пароль',
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
                icon: const Icon(Icons.lock, color: Colors.cyan),
                labelText: 'Повтор пароля',
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
                    showSnackBar("Заполните все поля!");
                  } else if (_passwordController.text.length < 6) {
                    showSnackBar('Пароль должен содержать не менее 6 символов!');
                  } else if (_passwordController.text !=
                      _passwordConfirmController.text) {
                    showSnackBar('Пароли не совпадают!');
                  } else {
                    if (await signUp()) {
                      Navigator.pushNamed(context, '/interests');
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
                  'Зарегистрироваться',
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
                const Text('Уже есть аккаунт?'),
                TextButton(
                  onPressed: () => Navigator.popAndPushNamed(context, "/auth"),
                  child: const Text(
                    'Авторизация',
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
