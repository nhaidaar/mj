// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mj/models/withdraw_model.dart';
import 'package:mj/services/user_service.dart';
import 'package:mj/shared/method.dart';
import 'package:mj/widgets/custom_button.dart';
import 'package:mj/widgets/custom_form.dart';
import 'package:page_transition/page_transition.dart';

import '../shared/const.dart';
import 'home.dart';

class TukarPoin extends StatefulWidget {
  const TukarPoin({super.key});

  @override
  State<TukarPoin> createState() => _TukarPoinState();
}

class _TukarPoinState extends State<TukarPoin> {
  final notelpController = TextEditingController();
  final notelpFocusNode = FocusNode();

  int? userPoin;
  int? selectedProvider;
  int? selectedNominal;

  String ewallet = '';
  int jumlahNominal = 0;

  bool isNoTelpEmpty = true;

  @override
  void initState() {
    super.initState();
    notelpController.addListener(updateFieldState);
  }

  @override
  void dispose() {
    notelpController.removeListener(updateFieldState);
    notelpController.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() {
      isNoTelpEmpty = notelpController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
          'Tukar Poin',
          style: boldTS.copyWith(color: blackColor),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 12,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  userPoin = data['totalPoin'];
                  return PoinUser(poin: data['totalPoin'].toString());
                }
                return const PoinUser(poin: '-');
              }),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih e-wallet',
                  style: semiboldTS.copyWith(fontSize: 16),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EwalletCard(
                      iconUrl: 'assets/icons/ewallet_gopay.png',
                      title: 'Gopay',
                      isSelected: selectedProvider == 0,
                      action: () {
                        setState(() {
                          selectedProvider = 0;
                          ewallet = 'gopay';
                        });
                      },
                    ),
                    EwalletCard(
                      iconUrl: 'assets/icons/ewallet_dana.png',
                      title: 'Dana',
                      isSelected: selectedProvider == 1,
                      action: () {
                        setState(() {
                          selectedProvider = 1;
                          ewallet = 'dana';
                        });
                      },
                    ),
                    EwalletCard(
                      iconUrl: 'assets/icons/ewallet_spay.png',
                      title: 'Spay',
                      isSelected: selectedProvider == 2,
                      action: () {
                        setState(() {
                          selectedProvider = 2;
                          ewallet = 'spay';
                        });
                      },
                    ),
                    EwalletCard(
                      iconUrl: 'assets/icons/ewallet_linkaja.png',
                      title: 'Link Aja',
                      isSelected: selectedProvider == 3,
                      action: () {
                        setState(() {
                          selectedProvider = 3;
                          ewallet = 'linkaja';
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Masukkan nomor e-wallet',
                    style: semiboldTS.copyWith(fontSize: 16)),
                const SizedBox(
                  height: 12,
                ),
                CustomFormField(
                  controller: notelpController,
                  focusNode: notelpFocusNode,
                  keyboardType: TextInputType.phone,
                  hintText: '0812 3456 7890',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Pilih nominal (Rp)',
              style: semiboldTS.copyWith(fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                ...List.generate(7, (index) {
                  return NominalTukarPoin(
                    nominal: index < 4
                        ? (index + 1) * 5000
                        : index < 6
                            ? index * 10000
                            : (index - 1) * 20000,
                    isSelected: selectedNominal == index,
                    action: () {
                      setState(() {
                        selectedNominal = index;
                        index < 4
                            ? jumlahNominal = (index + 1) * 5000
                            : index < 6
                                ? jumlahNominal = index * 10000
                                : jumlahNominal = (index - 1) * 20000;
                      });
                    },
                  );
                }),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: !isNoTelpEmpty &&
                selectedProvider != null &&
                selectedNominal != null
            ? CustomContinue(
                text: 'Lanjutkan',
                bgColor: yellowColor,
                action: () {
                  if (userPoin! >= jumlahNominal) {
                    handleConfirmationDialog(context, user);
                  } else {
                    showSnackbar(context, 'Poin anda tidak cukup!');
                  }
                },
              )
            : CustomContinue(
                text: 'Lanjutkan',
                bgColor: white3Color,
              ),
      ),
    );
  }

  void handleConfirmationDialog(BuildContext context, User user) {
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
                  Text.rich(
                    TextSpan(
                      text: 'Proses penarikan saldo tidak dapat dibatalkan. ',
                      style: mediumTS.copyWith(height: 1.5),
                      children: [
                        TextSpan(
                          text: 'Lanjut tarik saldo?',
                          style: boldTS,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomContinue(
                            text: 'Tidak',
                            bgColor: white2Color,
                            action: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: CustomContinue(
                            text: 'Ya',
                            action: () async {
                              try {
                                await UserService().requestWithdraw(
                                  WithdrawModel(
                                    withdrawMade: DateTime.now(),
                                    uid: user.uid,
                                    withdrawId: generateOrderId(),
                                    ewallet: ewallet,
                                    nominal: jumlahNominal,
                                    tujuan: notelpController.text,
                                    isFinished: false,
                                  ),
                                );
                                await UserService().updateUserBalance(
                                  user.uid,
                                  jumlahNominal,
                                );
                                showSnackbar(
                                  context,
                                  'Penarikan sedang diproses!',
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  PageTransition(
                                    child: const Home(),
                                    type: PageTransitionType.fade,
                                  ),
                                  (route) => false,
                                );
                              } on Exception catch (e) {
                                showSnackbar(context, e.toString());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class NominalTukarPoin extends StatelessWidget {
  final int nominal;
  final bool isSelected;
  final VoidCallback? action;
  const NominalTukarPoin({
    super.key,
    required this.nominal,
    required this.isSelected,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 120,
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? yellowColor : white2Color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSelected
                ? Row(
                    children: [
                      Image.asset(
                        'assets/icons/nominal_selected.png',
                        scale: 2,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Dipilih',
                        style: semiboldTS.copyWith(fontSize: 12),
                      ),
                    ],
                  )
                : Image.asset(
                    'assets/icons/nominal_unselected.png',
                    scale: 2,
                  ),
            const Spacer(),
            Text(
              nominal.toString(),
              style: boldTS.copyWith(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class PoinUser extends StatelessWidget {
  final String poin;
  const PoinUser({super.key, required this.poin});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: yellowColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Total Poin Anda',
            style: mediumTS.copyWith(fontSize: 12),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            poin,
            style: boldTS.copyWith(
              fontSize: 32,
              letterSpacing: -0.7,
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.5),
            decoration: BoxDecoration(
              color: yellow2Color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Dalam Rupiah',
                  style: mediumTS.copyWith(fontSize: 12),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'Rp $poin',
                  style: boldTS.copyWith(
                    fontSize: 32,
                    wordSpacing: 2,
                    letterSpacing: -0.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EwalletCard extends StatelessWidget {
  final String iconUrl;
  final String title;
  final bool isSelected;
  final VoidCallback? action;
  const EwalletCard({
    super.key,
    required this.iconUrl,
    required this.title,
    required this.isSelected,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(6),
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: white2Color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? yellowColor : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconUrl,
                  scale: 2,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  title,
                  style: semiboldTS.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          isSelected
              ? Positioned(
                  right: 0,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: whiteColor, width: 2),
                      color: yellowColor,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
