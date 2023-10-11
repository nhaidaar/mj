// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mj/widgets/custom_button.dart';

import '../../shared/const.dart';
import '../../shared/method.dart';
import '../../widgets/custom_form.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  bool isEmailEmpty = true;

  @override
  void initState() {
    super.initState();
    emailController.addListener(updateEmailState);
  }

  @override
  void dispose() {
    emailController.removeListener(updateEmailState);
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  void updateEmailState() {
    setState(() {
      isEmailEmpty = emailController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: blackColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Forgot Password',
                style: semiboldTS.copyWith(fontSize: 32),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Kami akan mengirimkan email berupa link untuk mengatur ulang password Anda!',
                style: mediumTS.copyWith(height: 1.5),
              ),
              const SizedBox(
                height: 28,
              ),

              // Email Form
              Text(
                'Email',
                style: semiboldTS,
              ),
              const SizedBox(
                height: 8,
              ),
              CustomFormField(
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                hintText: 'john@gmail.com',
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),

      // Forgot Password Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: !isEmailEmpty
            ? CustomContinue(
                text: 'Done',
                action: () async {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailController.text);
                    showSnackbar(context, 'Email berhasil dikirim!');
                  } on FirebaseAuthException catch (e) {
                    showSnackbar(context, e.code);
                  }
                },
              )
            : CustomContinue(
                text: 'Done',
                bgColor: white3Color,
              ),
      ),
    );
  }
}
