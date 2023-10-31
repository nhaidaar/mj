import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mj/screens/checker.dart';
import 'package:mj/shared/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Checker(),
          ),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Image.asset(
              'assets/images/logo.png',
              scale: 6,
            ),
            Text(
              'Version 1.0.1',
              style: mediumTS.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
