import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/pages/authPage.dart';
import 'package:forum_app/pages/createPage.dart';
import 'package:forum_app/pages/interestsPage.dart';
import 'package:forum_app/pages/mainViewPager.dart';
import 'package:forum_app/pages/regPage.dart';
import 'package:forum_app/services/auth/landing.dart';
import 'package:forum_app/services/auth/service.dart';
import 'package:forum_app/services/realtimeDb/insert.dart';
import 'package:google_fonts/google_fonts.dart';
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
          '/insert': (context) => ccreate(),
          '/interests': (context) => InterestsPage(post: null,),
          '/create': (context) => CreatePage(),
        },
        theme: ThemeData(
            fontFamily: GoogleFonts.montserrat().fontFamily,
            primarySwatch: Colors.cyan,
            primaryColor: Colors.cyan.shade400),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
