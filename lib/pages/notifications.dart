import 'package:flutter/material.dart';
import 'package:mj/shared/const.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: blackColor,
          ),
        ),
        title: Text(
          'Notifikasi',
          style: boldTS.copyWith(color: blackColor),
        ),
        centerTitle: true,
        elevation: 0,
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
