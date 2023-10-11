import 'package:flutter/material.dart';
import 'package:mj/models/order_model.dart';
import 'package:mj/pages/atur_penjemputan.dart';
import 'package:mj/shared/const.dart';
import 'package:mj/shared/method.dart';
import 'package:mj/widgets/custom_button.dart';
import 'package:page_transition/page_transition.dart';

class AturMinyak extends StatefulWidget {
  const AturMinyak({super.key});

  @override
  State<AturMinyak> createState() => _AturMinyakState();
}

class _AturMinyakState extends State<AturMinyak> {
  int selectedPackage = 0;
  int integerPart = 0;
  int decimalPart = 0;

  double minyak = 0;

  void incrementInteger() {
    setState(() {
      integerPart++;
      selectedPackage = 0;
    });
  }

  void decrementInteger() {
    setState(() {
      if (integerPart > 0) {
        integerPart--;
      }
      selectedPackage = 0;
    });
  }

  void incrementDecimal() {
    setState(() {
      decimalPart += 1;
      if (decimalPart >= 10) {
        decimalPart = 0;
        incrementInteger();
      }
      selectedPackage = 0;
    });
  }

  void decrementDecimal() {
    setState(() {
      decimalPart -= 1;
      if (decimalPart < 0) {
        if (integerPart != 0) {
          decimalPart = 9;
          decrementInteger();
        } else {
          decimalPart = 0;
        }
      }
      selectedPackage = 0;
    });
  }

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
          'Atur Jumlah Minyak',
          style: boldTS.copyWith(color: blackColor),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Pilih jumlah minyak',
              style: semiboldTS.copyWith(fontSize: 18),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                ...List.generate(5, (index) {
                  return JumlahMinyak(
                    model: OrderModel(
                      minyak: (index + 1).toDouble(),
                      poin: (index + 1) * 2000,
                    ),
                    isSelected: selectedPackage == (index + 1),
                    action: () {
                      setState(() {
                        selectedPackage = (index + 1);
                        minyak = (index + 1).toDouble();
                        integerPart = 0;
                        decimalPart = 0;
                      });
                    },
                  );
                })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Atur jumlah minyak manual',
              style: semiboldTS.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: white2Color,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masukkan jumlah minyak (L)',
                    style: mediumTS.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: orangeColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    decrementInteger();
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: whiteColor,
                                  )),
                              Text(
                                '$integerPart',
                                style: mediumTS.copyWith(
                                    fontSize: 20, color: whiteColor),
                              ),
                              IconButton(
                                onPressed: () {
                                  incrementInteger();
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: orangeColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    decrementDecimal();
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: whiteColor,
                                  )),
                              Text(
                                ',$decimalPart',
                                style: mediumTS.copyWith(
                                    fontSize: 20, color: whiteColor),
                              ),
                              IconButton(
                                onPressed: () {
                                  incrementDecimal();
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      Text(
                        'Jumlah minyak (L)',
                        style: mediumTS,
                      ),
                      const Spacer(),
                      Text(
                        '$integerPart,$decimalPart Liter',
                        style: boldTS.copyWith(color: orangeColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        'Jumlah poin yang didapat',
                        style: mediumTS,
                      ),
                      const Spacer(),
                      Text(
                        hitungPoin(integerPart, decimalPart).toString(),
                        style: boldTS.copyWith(color: orangeColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: CustomContinue(
          text: 'Lanjutkan',
          action: () {
            if (selectedPackage != 0) {
              minyak += (integerPart + decimalPart * 0.1);
            } else {
              minyak = (integerPart + decimalPart * 0.1);
            }
            if (minyak > 0) {
              Navigator.push(
                context,
                PageTransition(
                  child: AturPenjemputan(
                    model: OrderModel(
                      minyak: minyak,
                      poin: (minyak * 2000).toInt(),
                    ),
                  ),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            } else {
              showSnackbar(context, 'Jumlah minyak harus lebih dari 0!');
            }
          },
        ),
      ),
    );
  }
}

class JumlahMinyak extends StatelessWidget {
  final OrderModel model;
  final bool isSelected;
  final VoidCallback? action;
  const JumlahMinyak(
      {super.key, required this.model, required this.isSelected, this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.all(22),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border:
              Border.all(color: isSelected ? orangeColor : Colors.transparent),
          color: white2Color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: orangeColor,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ImageIcon(
                    const AssetImage('assets/icons/dashboardstatus_minyak.png'),
                    color: white2Color,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  '${model.minyak} Liter',
                  style: semiboldTS.copyWith(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: orangeColor,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ImageIcon(
                    const AssetImage('assets/icons/dashboardstatus_point.png'),
                    color: white2Color,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  '${model.poin} poin',
                  style: semiboldTS.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
