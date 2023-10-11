import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mj/pages/atur_minyak.dart';
import 'package:mj/pages/notifications.dart';
import 'package:mj/pages/penjemputan.dart';
import 'package:mj/pages/tukar_poin.dart';
import 'package:mj/shared/const.dart';
import 'package:mj/shared/method.dart';
import 'package:page_transition/page_transition.dart';

import '../blocs/user/user_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: blackBlur20Color),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundImage: user!.photoURL != null
                      ? NetworkImage(user.photoURL.toString()) as ImageProvider
                      : const AssetImage('assets/images/profile.jpg'),
                  radius: 24,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const NotificationPage(),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: const Stack(
                  children: [
                    Icon(Icons.notifications_outlined),
                    // Positioned(
                    //   right: 2,
                    //   top: 2,
                    //   child: Container(
                    //     height: 8,
                    //     width: 8,
                    //     decoration: const BoxDecoration(
                    //         shape: BoxShape.circle, color: Colors.red),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          BlocProvider(
            create: (context) =>
                UserBloc()..add(UserCheckPendingOrder(user.uid)),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserPendingOrder) {
                  int estimasi = 300;
                  final difference =
                      DateTime.now().difference(state.order.orderMade!);
                  if (difference.inSeconds >= estimasi) {
                    estimasi = 0;
                  } else {
                    estimasi =
                        estimasi - difference.inSeconds; // Kurangi sisa waktu
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: Penjemputan(model: state.order),
                          type: PageTransitionType.rightToLeft,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: yellow2Color,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: whiteColor,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/icons/dashboard_pendingorder.png',
                                ),
                                scale: 2,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sedang Dijemput',
                                style: semiboldTS.copyWith(
                                  fontSize: 11,
                                  color: blackBlur40Color,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                '${estimasi ~/ 60} Menit lagi',
                                style: semiboldTS.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_right_alt),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          Text(
            'Selamat Datang, Naufal 👋',
            style: semiboldTS.copyWith(fontSize: 24, height: 1.5),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: yellowColor,
                  ),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DashboardStatus(
                                icon: 'assets/icons/dashboardstatus_point.png',
                                title: 'Total Poin',
                                value: data['totalPoin'].toString(),
                              ),
                              const SizedBox(height: 20),
                              DashboardStatus(
                                icon: 'assets/icons/dashboardstatus_minyak.png',
                                title: 'Total Minyak',
                                value: '${data['totalMinyak'].toString()} L',
                              ),
                              const SizedBox(height: 20),
                              DashboardStatus(
                                icon:
                                    'assets/icons/dashboardstatus_earning.png',
                                title: 'Total Penarikan',
                                value:
                                    'Rp ${data['totalPendapatan'].toString()}',
                              ),
                            ],
                          );
                        }
                        return const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DashboardStatus(
                              icon: 'assets/icons/dashboardstatus_point.png',
                              title: 'Total Poin',
                              value: '-',
                            ),
                            SizedBox(height: 20),
                            DashboardStatus(
                              icon: 'assets/icons/dashboardstatus_minyak.png',
                              title: 'Total Minyak',
                              value: '-',
                            ),
                            SizedBox(height: 20),
                            DashboardStatus(
                              icon: 'assets/icons/dashboardstatus_earning.png',
                              title: 'Total Penarikan',
                              value: '-',
                            ),
                          ],
                        );
                      }),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardAction(
                      isJemput: true,
                      action: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: const AturMinyak(),
                            type: PageTransitionType.rightToLeft,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DashboardAction(
                      isJemput: false,
                      action: () {
                        showSnackbar(context, 'Coming soon !');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const DashboardTukarPoin(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              color: blackBlur50Color,
            ),
          ),
          Text(
            'Isi Petisi Yuk!',
            style: semiboldTS.copyWith(fontSize: 20),
          ),
          const SizedBox(
            height: 12,
          ),
          CarouselSlider(
            items: [
              Image.asset('assets/images/petisi.png'),
              Image.asset('assets/images/petisi.png'),
            ],
            options: CarouselOptions(
              height: 155,
              autoPlay: true,
              enableInfiniteScroll: true,
              viewportFraction: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardStatus extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  const DashboardStatus({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: yellow2Color,
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(icon),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: mediumTS.copyWith(fontSize: 10),
            ),
            Text(
              value,
              style: semiboldTS.copyWith(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}

class DashboardAction extends StatelessWidget {
  final bool isJemput;
  final VoidCallback? action;
  const DashboardAction({super.key, this.isJemput = true, this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isJemput ? orangeColor : greenColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: whiteColor,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(isJemput
                  ? 'assets/icons/home_penjemputan.png'
                  : 'assets/icons/home_antarsendiri.png'),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                  isJemput ? 'Penjemputan' : 'Antar Sendiri',
                  style: semiboldTS.copyWith(fontSize: 14, color: whiteColor),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward,
                  color: whiteColor,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardTukarPoin extends StatelessWidget {
  const DashboardTukarPoin({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: const TukarPoin(),
            type: PageTransitionType.rightToLeft,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: greyColor,
        ),
        child: Text(
          'Tukar Poin',
          style: semiboldTS.copyWith(
            fontSize: 14,
            color: whiteColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
