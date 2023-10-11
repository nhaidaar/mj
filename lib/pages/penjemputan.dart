// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mj/models/order_model.dart';
import 'package:mj/pages/home.dart';
import 'package:mj/services/user_service.dart';
import 'package:mj/shared/const.dart';
import 'package:mj/shared/values.dart';
import 'package:mj/widgets/custom_button.dart';
import 'package:page_transition/page_transition.dart';

import '../blocs/user/user_bloc.dart';
import '../shared/method.dart';

class Penjemputan extends StatefulWidget {
  final OrderModel model;
  const Penjemputan({super.key, required this.model});

  @override
  State<Penjemputan> createState() => _PenjemputanState();
}

class _PenjemputanState extends State<Penjemputan> {
  bool bottomsheetOpened = false;

  LatLng? userPosition;
  LatLng? driverPosition;
  List<LatLng>? coordinates;

  Completer<GoogleMapController?> controller = Completer();
  GoogleMapPolyline googleMapPolyline = GoogleMapPolyline(apiKey: mapsApi);

  int estimasiDriver = 5; // in seconds
  late Timer timer;
  bool timerComplete = false;

  @override
  void initState() {
    super.initState();

    // Set the user and driver position
    userPosition = LatLng(
      widget.model.latitude!,
      widget.model.longitude!,
    );
    driverPosition = const LatLng(
      -7.9503375,
      112.615279,
    );

    // Get route (polylines)
    getPolylinesWithLocation();

    // Get the timer start from DateTime in Firebase
    checkTimer();

    // Start the timer
    startTimer();
  }

  void getPolylinesWithLocation() async {
    List<LatLng>? driveRoute =
        await googleMapPolyline.getCoordinatesWithLocation(
      origin: driverPosition!,
      destination: userPosition!,
      mode: RouteMode.driving,
    );
    setState(() {
      coordinates = driveRoute;
    });
  }

  void checkTimer() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(widget.model.orderMade!);

    if (difference.inSeconds >= estimasiDriver) {
      setState(() {
        timerComplete = true; // Jika melebihi 5 menit, tandai sebagai selesai
      });
    } else {
      setState(() {
        estimasiDriver =
            estimasiDriver - difference.inSeconds; // Kurangi sisa waktu
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (estimasiDriver > 0) {
          estimasiDriver--;
        } else {
          timerComplete = true;
          timer.cancel();
        }
      });
    });
  }

  void openBottomSheet() {
    if (!bottomsheetOpened) {
      showModalBottomSheet(
          useSafeArea: true,
          showDragHandle: true,
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (BuildContext context) {
            // return StatefulBuilder(
            //     builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alamat',
                    style: semiboldTS.copyWith(fontSize: 18),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.model.shortAddress.toString(),
                          style: semiboldTS.copyWith(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.model.fullAddress.toString(),
                          style: regularTS.copyWith(
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Row(
                    children: [
                      Text(
                        'Detail Setoran',
                        style: semiboldTS.copyWith(fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        'Order ID : ${widget.model.orderId}',
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
                          children: [
                            Text(
                              'Minyak (L)',
                              style: semiboldTS,
                            ),
                            const Spacer(),
                            Text(
                              '${widget.model.minyak} Liter',
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
                  const SizedBox(
                    height: 28,
                  ),
                  Text(
                    'Detail Kurir',
                    style: semiboldTS.copyWith(fontSize: 18),
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: whiteColor,
                          child: Image.asset(
                            'assets/icons/home_user.png',
                            scale: 1.5,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Budi Satya',
                              style: semiboldTS,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Honda Beat Biru',
                              style: mediumTS,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'N 1234 BPZ',
                              style: boldTS,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  timerComplete
                      ? CustomContinue(
                          text: 'Selesai',
                          action: () {
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
                                            'Selamat! Anda mendapatkan ${widget.model.poin} poin 🎉',
                                            style: semiboldTS,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          CustomContinue(
                                            text: 'Klaim sekarang',
                                            action: () async {
                                              try {
                                                await UserService()
                                                    .updateOrderStatus(
                                                        widget.model.orderId!);
                                                await UserService()
                                                    .updateUserContri(
                                                  widget.model.uid!,
                                                  widget.model.poin!,
                                                  widget.model.minyak!,
                                                );
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    PageTransition(
                                                      child: const Home(),
                                                      type: PageTransitionType
                                                          .fade,
                                                    ),
                                                    (route) => false);
                                              } on Exception catch (e) {
                                                showSnackbar(
                                                    context, e.toString());
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        )
                      : CustomContinue(
                          text: 'Selesai',
                          bgColor: white3Color,
                        ),
                  const SizedBox(
                    height: 28,
                  ),
                ],
              ),
            );
          });
      // });
      bottomsheetOpened = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()
        ..add(
          UserPostOrder(widget.model),
        ),
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserMakeOrderFailed) {
            showSnackbar(context, state.e);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is UserMakeOrderSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              openBottomSheet();
            });
            return WillPopScope(
              onWillPop: () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                      child: const Home(),
                      type: PageTransitionType.leftToRightWithFade,
                    ),
                    (route) => false);
                return false;
              },
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 72,
                  leadingWidth: 68,
                  backgroundColor: Colors.transparent,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            child: const Home(),
                            type: PageTransitionType.leftToRightWithFade,
                          ),
                          (route) => false,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: whiteColor,
                          border: Border.all(color: blackBlur20Color),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                  title: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 28,
                    ),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(color: blackBlur20Color),
                      borderRadius: BorderRadius.circular(41),
                    ),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: timerComplete ? greenColor : blueColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          timerComplete
                              ? Text(
                                  'Driver telah tiba',
                                  style: semiboldTS.copyWith(
                                      fontSize: 12, color: blackColor),
                                )
                              : Text(
                                  'Estimasi : ${estimasiDriver ~/ 60} menit lagi',
                                  style: semiboldTS.copyWith(
                                      fontSize: 12, color: blackColor),
                                ),
                        ],
                      ),
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0,
                ),
                extendBodyBehindAppBar: true,
                body: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.model.latitude!,
                      widget.model.longitude!,
                    ),
                    zoom: 14,
                  ),
                  mapType: MapType.terrain,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height),
                  onMapCreated: (mapController) {
                    controller.complete(mapController);
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('User Location'),
                      position: userPosition!,
                    ),
                    Marker(
                      markerId: const MarkerId('Driver Location'),
                      position: driverPosition!,
                    ),
                  },
                  polylines: {
                    Polyline(
                      width: 4,
                      polylineId: const PolylineId('Driver Route'),
                      color: blueColor,
                      points: coordinates ?? [],
                    ),
                  },
                ),
                floatingActionButton: FloatingShowBottomsheet(
                  action: () {
                    bottomsheetOpened = false;
                    openBottomSheet();
                  },
                  alamat: widget.model.shortAddress.toString(),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(55),
                child: Text(
                  'Sedang mencari kurir, tunggu sebentar ya...',
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

class FloatingShowBottomsheet extends StatelessWidget {
  final String alamat;
  final VoidCallback? action;
  const FloatingShowBottomsheet({super.key, this.action, required this.alamat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: action,
        child: Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: [
              BoxShadow(
                color: blackBlur20Color,
                blurRadius: 32,
                offset: const Offset(0, 16),
                spreadRadius: -20,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alamat',
                      style: mediumTS.copyWith(color: blackBlur40Color),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      alamat,
                      style: boldTS.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/icons/arrow_up.png',
                scale: 2,
              ),
            ],
          ),
        ));
  }
}
