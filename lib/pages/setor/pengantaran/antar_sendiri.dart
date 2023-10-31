import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mj/blocs/maps/maps_bloc.dart';
import 'package:mj/models/warehouse_model.dart';
import 'package:mj/pages/setor/pengantaran/detail_pos.dart';
import 'package:mj/services/warehouse_service.dart';
import 'package:mj/shared/method.dart';
import 'package:page_transition/page_transition.dart';

import '../../../services/maps_service.dart';
import '../../../shared/const.dart';

class AntarSendiri extends StatefulWidget {
  const AntarSendiri({super.key});

  @override
  State<AntarSendiri> createState() => _AntarSendiriState();
}

class _AntarSendiriState extends State<AntarSendiri> {
  final Completer<GoogleMapController?> controller = Completer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapsBloc()..add(GetCurrentLocation()),
      child: BlocBuilder<MapsBloc, MapsState>(
        builder: (context, state) {
          if (state is MapsLoaded) {
            return StreamBuilder<List<WarehouseModel>>(
                stream: WarehouseService().getWarehouse(),
                builder: (context, snapshot) {
                  // Show loading if the data not loaded yet
                  if (!snapshot.hasData) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(
                          color: yellowColor,
                        ),
                      ),
                    );
                  }

                  // Pop when error
                  if (snapshot.hasError) {
                    Navigator.pop(context);
                    showSnackbar(context, snapshot.error.toString());
                  }

                  // Add marker from snapshot
                  final markers = snapshot.data!
                      .where((warehouse) =>
                          warehouse.latitude != null &&
                          warehouse.longitude != null)
                      .map((warehouse) {
                    return Marker(
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure),
                      markerId: const MarkerId('Pos Pengantaran'),
                      position: LatLng(
                        warehouse.latitude!,
                        warehouse.longitude!,
                      ),
                    );
                  }).toSet();

                  markers.add(
                    Marker(
                      markerId: const MarkerId('Your Position'),
                      position: LatLng(
                        state.position.latitude,
                        state.position.longitude,
                      ),
                    ),
                  );

                  List<PosCard> sortedCards = List.generate(
                    snapshot.data!.length,
                    (index) {
                      return PosCard(
                        warehouse: snapshot.data![index],
                        distance: Geolocator.distanceBetween(
                          snapshot.data![index].latitude!,
                          snapshot.data![index].longitude!,
                          state.position.latitude,
                          state.position.longitude,
                        ).toInt(),
                      );
                    },
                  ).where((posCard) => posCard.distance! < 5000).toList();

                  sortedCards
                      .sort((a, b) => a.distance!.compareTo(b.distance!));

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
                        'Lokasi Pos Terdekat',
                        style: boldTS.copyWith(color: blackColor),
                      ),
                      elevation: 0.5,
                    ),
                    body: Stack(
                      children: [
                        LayoutBuilder(
                          builder: (
                            BuildContext context,
                            BoxConstraints constraints,
                          ) {
                            return SizedBox(
                              height: constraints.maxHeight,
                              child: GoogleMap(
                                zoomControlsEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    state.position.latitude - 0.015,
                                    state.position.longitude,
                                  ),
                                  zoom: 14,
                                ),
                                mapType: MapType.terrain,
                                onMapCreated: (mapController) {
                                  controller.complete(mapController);
                                },
                                markers: markers,
                              ),
                            );
                          },
                        ),
                        DraggableScrollableSheet(
                            snap: true,
                            snapSizes: const [0.075, 0.5],
                            initialChildSize: 0.5,
                            minChildSize: 0.075,
                            builder: (
                              BuildContext context,
                              ScrollController scrollController,
                            ) {
                              return Container(
                                padding: const EdgeInsets.only(top: 20),
                                decoration: ShapeDecoration(
                                  color: whiteColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                ),
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  controller: scrollController,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  children: [
                                    const Divider(
                                      indent: 140,
                                      endIndent: 140,
                                      thickness: 5,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder(
                                            future: MapsService()
                                                .getShortAddressFromPosition(
                                                    state.position),
                                            builder: (context, snapshot) {
                                              return Text(
                                                snapshot.data ??
                                                    'Getting your Location...',
                                                style: boldTS.copyWith(
                                                  fontSize: 18,
                                                  height: 1.5,
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          FutureBuilder(
                                            future: MapsService()
                                                .getFullAddressFromPosition(
                                                    state.position),
                                            builder: (context, snapshot) {
                                              return Text(
                                                snapshot.data ??
                                                    'Getting your Location...',
                                                style: mediumTS.copyWith(
                                                  color: blackBlur50Color,
                                                  height: 1.5,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Text(
                                      'List pos terdekat',
                                      style: semiboldTS.copyWith(fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    snapshot.data != null
                                        ? Column(
                                            children: sortedCards
                                                .map((card) => card)
                                                .toList(),
                                          )
                                        : Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Text(
                                                'Kami segera hadir di tempat Anda!',
                                                style: mediumTS.copyWith(
                                                  color: blackBlur50Color,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  );
                });
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
}

class PosCard extends StatelessWidget {
  final WarehouseModel warehouse;
  final int? distance;
  const PosCard({
    super.key,
    required this.warehouse,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (distance != null) {
          Navigator.push(
            context,
            PageTransition(
              child: DetailPos(
                warehouse: warehouse,
                distance: distance!,
              ),
              type: PageTransitionType.rightToLeft,
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: white2Color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: warehouse.imgUrl != ''
                      ? NetworkImage(warehouse.imgUrl!) as ImageProvider
                      : const AssetImage('assets/images/profile.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    warehouse.title.toString(),
                    style: semiboldTS.copyWith(
                      fontSize: 16,
                      color: warehouse.isAvailable!
                          ? blackColor
                          : blackBlur50Color,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  FutureBuilder(
                    future: MapsService().getShortAddressFromLatLng(
                        warehouse.latitude!, warehouse.longitude!),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? 'Getting your Location...',
                        style: mediumTS.copyWith(
                          color: warehouse.isAvailable!
                              ? blackColor
                              : blackBlur50Color,
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
                          color: warehouse.isAvailable!
                              ? greenColor
                              : Colors.redAccent,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        '${(warehouse.isAvailable! ? 'Buka' : 'Tutup')} ${distance != null ? '- $distance m' : ''}',
                        style: mediumTS.copyWith(
                          fontSize: 12,
                          color: warehouse.isAvailable!
                              ? blackColor
                              : blackBlur50Color,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
