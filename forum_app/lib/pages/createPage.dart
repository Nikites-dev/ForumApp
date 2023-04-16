import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CreatePage extends StatelessWidget {
  String name, email, phone;
  CreatePage(
      {super.key,
      required this.name,
      required this.email,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${name}'),
            Text('Email: ${email}'),
            Text('Phone: ${phone}'),
          ],
        ),
      ),
    );
  }
}
