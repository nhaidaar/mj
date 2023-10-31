import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mj/models/order_model.dart';
import 'package:mj/models/withdraw_model.dart';
import 'package:mj/services/history_service.dart';
import 'package:mj/shared/const.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int isSelected = 1;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          'Transaksi Terakhir',
          style: boldTS.copyWith(color: blackColor),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: HistoryFilter(
                    title: 'Penyetoran',
                    isSelected: isSelected == 1,
                    action: () {
                      setState(() {
                        isSelected = 1;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: HistoryFilter(
                    title: 'Penarikan',
                    isSelected: isSelected == 2,
                    action: () {
                      setState(() {
                        isSelected = 2;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            isSelected == 1
                ? StreamBuilder(
                    stream: HistoryService().streamPenyetoran(user!.uid),
                    builder: (
                      context,
                      AsyncSnapshot<List<OrderModel>> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return Text(
                            'Ayo mulai transaksi pertamamu!',
                            style: mediumTS,
                            textAlign: TextAlign.center,
                          );
                        }
                        snapshot.data!.sort(
                            (a, b) => b.orderMade!.compareTo(a.orderMade!));

                        return Column(
                          children: snapshot.data!.map((OrderModel order) {
                            return OrderHistoryTile(
                              order: order,
                            );
                          }).toList(),
                        );
                      }

                      return Center(
                        child: CircularProgressIndicator(
                          color: yellowColor,
                        ),
                      );
                    },
                  )
                : StreamBuilder(
                    stream: HistoryService().streamPenarikan(user!.uid),
                    builder: (
                      context,
                      AsyncSnapshot<List<WithdrawModel>> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return Text(
                            'Ayo mulai transaksi pertamamu!',
                            style: mediumTS,
                            textAlign: TextAlign.center,
                          );
                        }
                        snapshot.data!.sort((a, b) =>
                            b.withdrawMade!.compareTo(a.withdrawMade!));

                        return Column(
                          children:
                              snapshot.data!.map((WithdrawModel withdraw) {
                            return WithdrawHistory(
                              withdraw: withdraw,
                            );
                          }).toList(),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: yellowColor,
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class OrderHistoryTile extends StatelessWidget {
  final OrderModel order;
  const OrderHistoryTile({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: yellow2Color,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${order.orderId}',
                    style: boldTS.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  order.isFinished!
                      ? Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: greenColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: whiteColor,
                          ),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                '${order.minyak} L',
                style: semiboldTS,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                DateFormat('dd MMMM yyyy - HH.mm').format(order.orderMade!),
                style: regularTS.copyWith(fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '+ ${order.poin}',
            style: extraboldTS.copyWith(fontSize: 20),
          )
        ],
      ),
    );
  }
}

class WithdrawHistory extends StatelessWidget {
  final WithdrawModel withdraw;
  const WithdrawHistory({
    super.key,
    required this.withdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: yellow2Color,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${withdraw.withdrawId}',
                    style: boldTS.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  withdraw.isFinished!
                      ? Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: greenColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: whiteColor,
                          ),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/ewallet_${withdraw.ewallet}.png',
                    scale: 2,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    withdraw.ewallet!.toUpperCase(),
                    style: semiboldTS,
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                DateFormat('dd MMMM yyyy - HH.mm')
                    .format(withdraw.withdrawMade!),
                style: regularTS.copyWith(fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '- ${withdraw.nominal}',
            style: extraboldTS.copyWith(fontSize: 20),
          )
        ],
      ),
    );
  }
}

class HistoryFilter extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? action;
  const HistoryFilter({
    super.key,
    required this.title,
    required this.isSelected,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? yellowColor : white2Color,
          border: Border.all(color: white3Color),
          borderRadius: BorderRadius.circular(41),
        ),
        child: Text(
          title,
          style: semiboldTS,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
