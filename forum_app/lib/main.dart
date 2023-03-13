import 'package:flutter/material.dart';
import 'package:forum_app/regPage.dart';

void main() {
  runApp(const AppThemeMaterial());
}

class AppThemeMaterial extends StatelessWidget {
  const AppThemeMaterial({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/':(context) => const RegPage(),},
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        primaryColor: Colors.cyan.shade400
      ),
      debugShowCheckedModeBanner: false,
    );
  }

}