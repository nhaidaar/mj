import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mj/repositories/auth_repository.dart';
import 'package:mj/pages/home.dart';
import 'package:mj/shared/const.dart';

import 'blocs/auth/auth_bloc.dart';
import 'firebase_options.dart';
import 'pages/auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              auth: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'MJ',
          theme: ThemeData(
            fontFamily: 'PlusJakartaSans',
            scaffoldBackgroundColor: whiteColor,
            appBarTheme: AppBarTheme(
              backgroundColor: whiteColor,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Home();
              }
              return const LoginPage();
            },
          ),
        ),
      ),
    );
  }
}
