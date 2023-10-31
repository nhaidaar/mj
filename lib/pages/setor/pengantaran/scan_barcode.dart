// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mj/models/order_model.dart';
import 'package:mj/pages/setor/pengantaran/antar_sendiri.dart';
import 'package:mj/shared/method.dart';
import 'package:page_transition/page_transition.dart';

import '../../../blocs/user/user_bloc.dart';
import '../../../models/warehouse_model.dart';
import '../../../services/user_service.dart';
import '../../../shared/const.dart';
import '../../../widgets/custom_button.dart';
import '../../home.dart';

class ScanBarcode extends StatefulWidget {
  final WarehouseModel warehouse;
  const ScanBarcode({super.key, required this.warehouse});

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  final user = FirebaseAuth.instance.currentUser;
  String? orderId;
  double? minyak;

  void handleClaimDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Selamat! Anda mendapatkan ${(minyak! * 2000).toInt()} poin 🎉',
                    style: semiboldTS,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomContinue(
                    text: 'Kembali ke Beranda',
                    action: () async {
                      try {
                        showLoadingDialog(context);

                        await UserService().addOrder(
                          OrderModel(
                            orderMade: DateTime.now(),
                            orderId: orderId,
                            uid: user!.uid,
                            isFinished: true,
                            shortAddress: '',
                            fullAddress: '',
                            userLatitude: 0,
                            userLongitude: 0,
                            warehouseLatitude: widget.warehouse.latitude,
                            warehouseLongitude: widget.warehouse.longitude,
                            minyak: minyak,
                            poin: (minyak! * 2000).toInt(),
                          ),
                        );

                        await UserService().updateUserContri(
                          user!.uid,
                          (minyak! * 2000).toInt(),
                          minyak!,
                        );

                        // Pop loading dialog
                        Navigator.pop(context);

                        Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            child: const Home(),
                            type: PageTransitionType.fade,
                          ),
                          (route) => false,
                        );

                        showSnackbar(context, 'Poin berhasil diklaim!');
                      } on Exception catch (e) {
                        // Pop loading dialog
                        Navigator.pop(context);

                        showSnackbar(context, e.toString());
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(UserScanBarcode()),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserScanBarcodeSuccess) {
            orderId = generateOrderId();
            minyak = (Random().nextInt(5) + 1);
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
                  'Detail Penyetoran',
                  style: boldTS.copyWith(color: blackColor),
                ),
                elevation: 0.5,
              ),
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Alamat Pos',
                    style: semiboldTS.copyWith(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  PosCard(warehouse: widget.warehouse),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Text(
                        'Detail Setoran',
                        style: semiboldTS.copyWith(fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        'Order ID : $orderId',
                        style: mediumTS.copyWith(fontSize: 10),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: white2Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Penyetor',
                              style: semiboldTS,
                            ),
                            const Spacer(),
                            Expanded(
                              child: Text(
                                user!.displayName ?? 'Guest User',
                                style: boldTS,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Text(
                              'Minyak (L)',
                              style: semiboldTS,
                            ),
                            const Spacer(),
                            Text(
                              '$minyak Liter',
                              style: boldTS,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Text(
                              'Poin untuk Anda',
                              style: semiboldTS,
                            ),
                            const Spacer(),
                            Text(
                              '${(minyak! * 2000).toInt()}',
                              style: boldTS,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 15,
                      spreadRadius: 25,
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: CustomContinue(
                  text: 'Konfirmasi',
                  action: () {
                    handleClaimDialog(context);
                  },
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(55),
                child: Text(
                  'Scan barcode dalam proses, tunggu sebentar ya...',
                  style: semiboldTS.copyWith(
                    fontSize: 20,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
