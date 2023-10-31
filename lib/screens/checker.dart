import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mj/pages/home.dart';

import '../pages/auth/login.dart';

class Checker extends StatelessWidget {
  const Checker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Home();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
