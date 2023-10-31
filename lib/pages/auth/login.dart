// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mj/shared/const.dart';
import 'package:mj/widgets/custom_button.dart';
import 'package:mj/widgets/custom_form.dart';
import 'package:page_transition/page_transition.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../shared/method.dart';
import '../home.dart';
import 'forgot_password.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool areFieldsEmpty = true;
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    emailController.addListener(updateFieldState);
    passwordController.addListener(updateFieldState);
  }

  @override
  void dispose() {
    emailController.removeListener(updateFieldState);
    passwordController.removeListener(updateFieldState);
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() {
      areFieldsEmpty =
          emailController.text.isEmpty || passwordController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
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
                        'Welcome Back!',
                        style: semiboldTS.copyWith(fontSize: 32),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Lakukan sign in untuk dapat mengakses akun anda.',
                        style: mediumTS,
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
                        isPassword: true,
                        hintText: 'Never share your password!',
                        obscureText: _passwordVisible,
                        action: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      // Forgot Password Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageTransition(
                                  child: const ForgotPassword(),
                                  type: PageTransitionType.rightToLeft,
                                  childCurrent: widget,
                                ),
                              );
                            },
                            child: Text(
                              'Lupa Password?',
                              style: mediumTS,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // If one of field empty, disable the sign in button
                      !areFieldsEmpty
                          ? CustomContinue(
                              text: 'Login',
                              action: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                  AuthSignIn(
                                    emailController.text,
                                    passwordController.text,
                                  ),
                                );
                              },
                            )
                          : CustomContinue(
                              text: 'Login',
                              bgColor: white3Color,
                            ),

                      const SizedBox(
                        height: 16,
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

                      // Login with Google Button (Coming Soon)
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
                                  'Login with Google',
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
                      child: const RegisterPage(),
                      type: PageTransitionType.rightToLeft,
                      childCurrent: widget,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(24),
                  child: Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: mediumTS,
                      children: [
                        TextSpan(
                          text: 'Register',
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
