import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/pages/auth_page.dart';
import 'package:forum_app/pages/home_page.dart';
import 'package:forum_app/pages/regPage.dart';
import 'package:forum_app/services/auth/landing.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppThemeMaterial());
}

class AppThemeMaterial extends StatelessWidget {
  const AppThemeMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthServices().currentUser,
      initialData: null,
      child: MaterialApp(
        routes: {
          '/': (context) => LandingPage(),
          '/reg': (context) => RegPage(),
          '/auth': (context) => const AuthPage(),
          '/home': (context) => const HomePage(),
        },
        theme: ThemeData(
            primarySwatch: Colors.cyan, primaryColor: Colors.cyan.shade400),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
