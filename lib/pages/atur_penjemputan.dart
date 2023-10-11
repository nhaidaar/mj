import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mj/models/order_model.dart';
import 'package:mj/pages/penjemputan.dart';
import 'package:mj/services/maps_service.dart';
import 'package:mj/shared/method.dart';
import 'package:mj/widgets/custom_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../blocs/maps/maps_bloc.dart';
import '../shared/const.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapsBloc()..add(GetCurrentLocation()),
      child: BlocBuilder<MapsBloc, MapsState>(
        builder: (context, state) {
          if (state is MapsLoaded) {
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
                padding: const EdgeInsets.all(20),
                children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: blackBlur20Color, width: 1),
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
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Detail Lokasi',
                        style: semiboldTS,
                      ),
                      // const Spacer(),
                      // const Icon(
                      //   Icons.edit,
                      //   size: 20,
                      // ),
                      // const SizedBox(
                      //   width: 6,
                      // ),
                      // Text(
                      //   'Edit',
                      //   style: semiboldTS.copyWith(fontSize: 12),
                      // ),
                    ],
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
                    height: 20,
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
                              'Poin untuk Anda',
                              style: semiboldTS,
                            ),
                            const Spacer(),
                            Text(
                              widget.model.poin.toString(),
                              style: boldTS,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: CustomContinue(
                  text: 'Konfirmasi',
                  action: () {
                    handleConfirmation(context, state);
                  },
                ),
              ),
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
                                      latitude: state.position.latitude,
                                      longitude: state.position.longitude,
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
