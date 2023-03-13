import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RegPage extends StatelessWidget {
  const RegPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "ForumApp",
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 30
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}