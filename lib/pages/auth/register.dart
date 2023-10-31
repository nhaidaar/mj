// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mj/models/user_model.dart';
import 'package:mj/pages/auth/upload_picture.dart';
import 'package:mj/services/user_service.dart';
import 'package:mj/shared/const.dart';
import 'package:page_transition/page_transition.dart';

import '../../blocs/auth/auth_bloc.dart';

import '../../shared/method.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_form.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool areFieldsEmpty = true;
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    nameController.addListener(updateFieldState);
    emailController.addListener(updateFieldState);
    passwordController.addListener(updateFieldState);
  }

  @override
  void dispose() {
    nameController.removeListener(updateFieldState);
    emailController.removeListener(updateFieldState);
    passwordController.removeListener(updateFieldState);
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() {
      areFieldsEmpty = emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          nameController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          final user = FirebaseAuth.instance.currentUser!;
          user.updateDisplayName(nameController.text);
          UserService().addUserToFirestore(
            UserModel(
              uid: user.uid,
              email: emailController.text,
              fullName: nameController.text,
              profilePict: '',
              totalMinyak: 0,
              totalPoin: 0,
              totalPendapatan: 0,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              child: const UploadPicture(),
              type: PageTransitionType.rightToLeft,
            ),
            (route) => false,
          );
        }
        if (state is AuthError) {
          showSnackbar(context, state.e);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: yellowColor,
                ),
              ),
            );
          }
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/logo_vector.png',
                        width: 48,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Title
                      Text(
                        'Hi, Welcome!',
                        style: semiboldTS.copyWith(fontSize: 32),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Daftar sekarang dan jadilah agen perubahan.',
                        style: mediumTS,
                      ),
                      const SizedBox(
                        height: 28,
                      ),

                      // Name Form
                      Text(
                        'Name',
                        style: semiboldTS,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormField(
                        focusNode: nameFocusNode,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        hintText: 'John Doe',
                      ),

                      const SizedBox(
                        height: 20,
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

                      // Password Form
                      Text(
                        'Password',
                        style: semiboldTS,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormField(
                        focusNode: passwordFocusNode,
                        controller: passwordController,
                        obscureText: _passwordVisible,
                        isPassword: true,
                        hintText: 'Never share your password!',
                        action: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // If one of field empty, disable the register button
                      !areFieldsEmpty
                          ? CustomContinue(
                              text: 'Register',
                              action: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                  AuthSignUp(
                                    emailController.text,
                                    passwordController.text,
                                  ),
                                );
                              },
                            )
                          : CustomContinue(
                              text: 'Register',
                              bgColor: white3Color,
                            ),

                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: blackBlur20Color,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 9),
                            child: Text(
                              'atau',
                              style: mediumTS.copyWith(color: blackBlur20Color),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: blackBlur20Color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),

                      // Register with Google Button (Coming Soon)
                      GestureDetector(
                        onTap: () {
                          showSnackbar(context, 'This feature is coming soon!');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: white2Color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/google.png',
                                  scale: 2,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Register with Google',
                                  style: semiboldTS.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageTransition(
                      child: const LoginPage(),
                      type: PageTransitionType.leftToRight,
                      childCurrent: widget,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(24),
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: mediumTS,
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: semiboldTS,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
