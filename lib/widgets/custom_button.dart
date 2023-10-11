import 'package:flutter/material.dart';

import '../shared/const.dart';

class CustomContinue extends StatelessWidget {
  final String text;
  final VoidCallback? action;
  final Color? bgColor;
  const CustomContinue(
      {super.key, required this.text, this.action, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bgColor ?? yellowColor,
        ),
        child: Text(
          text,
          style: semiboldTS.copyWith(
            fontSize: 16,
            color: bgColor == white3Color ? blackBlur40Color : blackColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
