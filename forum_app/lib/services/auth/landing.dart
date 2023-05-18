import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:forum_app/pages/home_view.dart';
import '../../pages/auth_page.dart';
import 'model.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel? model = Provider.of<UserModel?>(context);
    final bool check = model != null;
    return check ? const HomePage() : const AuthPage();
  }
}
