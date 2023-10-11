import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mj/pages/article.dart';
import 'package:mj/pages/history.dart';
import 'package:mj/pages/profile.dart';
import 'package:page_transition/page_transition.dart';

import '../blocs/auth/auth_bloc.dart';
import '../shared/const.dart';
import 'auth/login.dart';
import 'dashboard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const ArticlePage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  Widget bottomNavbar() {
    return BottomAppBar(
      height: 78,
      child: BottomNavigationBar(
        backgroundColor: whiteColor,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: blackColor,
        unselectedItemColor: blackBlur50Color,
        selectedLabelStyle: semiboldTS.copyWith(fontSize: 12),
        unselectedLabelStyle: semiboldTS.copyWith(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: ImageIcon(
                AssetImage('assets/icons/home_dashboard.png'),
              ),
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: ImageIcon(
                AssetImage('assets/icons/home_article.png'),
              ),
            ),
            label: 'Article',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: ImageIcon(
                AssetImage('assets/icons/home_riwayat.png'),
              ),
            ),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: ImageIcon(
                AssetImage('assets/icons/home_user.png'),
              ),
            ),
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              child: const LoginPage(),
              type: PageTransitionType.fade,
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: bottomNavbar(),
      ),
    );
  }
}
