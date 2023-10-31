import 'package:flutter/material.dart';
import 'package:mj/shared/const.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          'Artikel',
          style: boldTS.copyWith(color: blackColor),
        ),
        elevation: 1,
      ),
      body: Center(
        child: Text(
          'This feature is coming soon.',
          style: semiboldTS,
        ),
      ),
    );
  }
}
