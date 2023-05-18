import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/pages/auth_page.dart';
import 'package:forum_app/pages/create_page.dart';
import 'package:forum_app/pages/interests_page.dart';
import 'package:forum_app/pages/mainViewPager.dart';
import 'package:forum_app/pages/profile_view.dart';
import 'package:forum_app/pages/reg_page.dart';
import 'package:forum_app/services/auth/landing.dart';
import 'package:forum_app/services/auth/service.dart';
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
          '/': (context) => const LandingPage(),
          '/reg': (context) => RegPage(),
          '/auth': (context) => const AuthPage(),
          '/home': (context) => const HomePage(),
          '/interests': (context) => InterestsPage(post: null,),
          '/create': (context) => CreatePage(),
          '/profile': (context) => ProfileView(),
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
