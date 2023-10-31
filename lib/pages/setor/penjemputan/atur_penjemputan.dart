import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mj/models/order_model.dart';
import 'package:mj/pages/setor/penjemputan/penjemputan.dart';
import 'package:mj/services/maps_service.dart';
import 'package:mj/shared/method.dart';
import 'package:mj/widgets/custom_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../blocs/maps/maps_bloc.dart';
import '../../../models/warehouse_model.dart';
import '../../../services/warehouse_service.dart';
import '../../../shared/const.dart';

class AturPenjemputan extends StatefulWidget {
  final OrderModel model;
  const AturPenjemputan({super.key, required this.model});

  @override
  State<AturPenjemputan> createState() => _AturPenjemputanState();
}

class _AturPenjemputanState extends State<AturPenjemputan> {
  final Completer<GoogleMapController?> controller = Completer();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String? orderId;
  String? shortAddress;
  String? fullAddress;

  int? ongkir;
  int? realPoin;

  WarehouseModel? warehouse;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapsBloc()..add(GetCurrentLocation()),
      child: BlocBuilder<MapsBloc, MapsState>(
        builder: (context, state) {
          if (state is MapsLoaded) {
            return StreamBuilder(
              stream: WarehouseService().getWarehouse(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MiniPosCard> sortedCards = List.generate(
                    snapshot.data!.length,
                    (index) {
                      return MiniPosCard(
                        warehouse: snapshot.data![index],
                        user: state.position,
                        distance: Geolocator.distanceBetween(
                          snapshot.data![index].latitude!,
                          snapshot.data![index].longitude!,
                          state.position.latitude,
                          state.position.longitude,
                        ).toInt(),
                      );
                    },
                  );

                  // Sorting pos to nearest
                  sortedCards.sort((a, b) => a.distance.compareTo(b.distance));

                  // Set warehouse
                  warehouse = sortedCards[0].warehouse;

                  // Set ongkir
                  ongkir = ((sortedCards[0].distance ~/ 1000) - 2) * 2000;
                  if ((ongkir ?? 0) < 0) {
                    ongkir = 0;
                  }

                  // Set poin after ongkir
                  realPoin = widget.model.poin! - (ongkir ?? 0);
                  if ((realPoin ?? 0) < 0) {
                    realPoin = 0;
                  }

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
                        'Atur Penjemputan',
                        style: boldTS.copyWith(color: blackColor),
                      ),
                      elevation: 0,
                    ),
                    body: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      children: [
                        SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: blackBlur20Color, width: 1),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GoogleMap(
                                padding: const EdgeInsets.only(bottom: 150),
                                zoomControlsEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    state.position.latitude,
                                    state.position.longitude,
                                  ),
                                  zoom: 19.5,
                                ),
                                onMapCreated: (mapController) {
                                  controller.complete(mapController);
                                },
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('Your Location'),
                                    position: LatLng(
                                      state.position.latitude,
                                      state.position.longitude,
                                    ),
                                  ),
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Lokasimu saat ini',
                          style: semiboldTS,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FutureBuilder(
                          future: MapsService()
                              .getShortAddressFromPosition(state.position),
                          builder: (context, snapshot) {
                            shortAddress = snapshot.data;
                            return Text(
                              snapshot.data ?? 'Getting your Location...',
                              style: boldTS.copyWith(fontSize: 18),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Detail Lokasi',
                          style: semiboldTS,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: white2Color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FutureBuilder(
                            future: MapsService()
                                .getFullAddressFromPosition(state.position),
                            builder: (context, snapshot) {
                              fullAddress = snapshot.data;
                              return Text(
                                snapshot.data ?? 'Getting your Location...',
                                style: semiboldTS,
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Pos Terdekat',
                          style: semiboldTS,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        sortedCards[0],
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Konfirmasi',
                          style: semiboldTS,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: white2Color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Minyak (L)',
                                    style: semiboldTS,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${widget.model.minyak.toString()} Liter',
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
                                    'Poin Rewards',
                                    style: semiboldTS,
                                  ),
                                  const Spacer(),
                                  Text(
                                    widget.model.poin.toString(),
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
                                    'Biaya Penjemputan',
                                    style: semiboldTS,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '$ongkir',
                                    style: boldTS,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                '*Biaya penjemputan gratis untuk 2 km pertama',
                                style: regularTS.copyWith(fontSize: 12),
                              ),
                              const Divider(
                                height: 24,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Poin untuk Anda',
                                    style: semiboldTS,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '$realPoin',
                                    style: extraboldTS.copyWith(
                                      color: orangeColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
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
                      child: (realPoin ?? 0) > 0
                          ? CustomContinue(
                              text: 'Konfirmasi',
                              action: () {
                                handleConfirmation(context, state);
                              },
                            )
                          : CustomContinue(
                              text: 'Konfirmasi',
                              bgColor: white3Color,
                            ),
                    ),
                  );
                }
                return Container();
              },
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: yellowColor,
              ),
            ),
          );
        },
      ),
    );
  }

  void handleConfirmation(BuildContext context, MapsLoaded state) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      text:
                          'Pastikan data yang anda isi sudah benar karena konfirmasi tidak dapat dibatalkan. ',
                      style: mediumTS.copyWith(height: 1.5),
                      children: [
                        TextSpan(
                          text: 'Lanjut konfirmasi?',
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
                            action: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  child: Penjemputan(
                                    model: widget.model.copyWith(
                                      orderMade: DateTime.now(),
                                      uid: userId,
                                      orderId: generateOrderId(),
                                      isFinished: false,
                                      shortAddress: shortAddress,
                                      fullAddress: fullAddress,
                                      userLatitude: state.position.latitude,
                                      userLongitude: state.position.longitude,
                                      warehouseLatitude: warehouse!.latitude,
                                      warehouseLongitude: warehouse!.longitude,
                                      poin: realPoin,
                                    ),
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
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

class MiniPosCard extends StatelessWidget {
  final Position user;
  final WarehouseModel warehouse;
  final int distance;
  const MiniPosCard(
      {super.key,
      required this.user,
      required this.warehouse,
      required this.distance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white2Color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            warehouse.title.toString(),
            style: semiboldTS,
          ),
          const SizedBox(
            height: 6,
          ),
          FutureBuilder(
            future: MapsService().getShortAddressFromLatLng(
              warehouse.latitude!,
              warehouse.longitude!,
            ),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? 'Getting your Location...',
                style: regularTS.copyWith(
                  height: 1.5,
                ),
              );
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: ShapeDecoration(
                  shape: const CircleBorder(),
                  color: greenColor,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                '${distance < 1000 ? '$distance m' : '${(distance / 1000).toStringAsFixed(1)} km'} dari lokasi Anda',
                style: mediumTS.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
