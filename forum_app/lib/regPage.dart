import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'components/input.dart';

class RegPage extends StatelessWidget {
  const RegPage({super.key});

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
                Image.asset('assets/images/logo.png'),
                const Text(
                  'Регистрация',
                  style: TextStyle(fontSize: 30, color: Colors.cyan),
                ),
                
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const Input(
              color: Colors.cyan,
              icon: Icon(Icons.email, color: Colors.black),
              labelText: 'Email',
            ),
            const SizedBox(
              height: 12,
            ),
            const Input(
              color: Colors.cyan,
              icon: Icon(Icons.lock, color: Colors.black),
              labelText: 'Пароль',
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                onPressed: () {},
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
          ],
        )),
      ),
    );
  }
}
