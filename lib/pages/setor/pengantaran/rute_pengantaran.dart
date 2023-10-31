import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mj/models/warehouse_model.dart';
import 'package:mj/pages/setor/pengantaran/scan_barcode.dart';
import 'package:mj/widgets/custom_button.dart';
import 'package:page_transition/page_transition.dart';

import '../../../blocs/maps/maps_bloc.dart';
import '../../../shared/const.dart';
import '../../../shared/values.dart';

class TunjukkanRute extends StatefulWidget {
  final WarehouseModel warehouse;
  const TunjukkanRute({super.key, required this.warehouse});

  @override
  State<TunjukkanRute> createState() => _TunjukkanRuteState();
}

class _TunjukkanRuteState extends State<TunjukkanRute> {
  final Completer<GoogleMapController?> controller = Completer();
  GoogleMapPolyline googleMapPolyline = GoogleMapPolyline(apiKey: mapsApi);

  List<LatLng>? routes;
  String distance = '0';
  Position? initialPosition;
  Position? currentPosition;
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentPosition();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }

  void getPolylinesWithLocation() async {
    List<LatLng>? routes = await googleMapPolyline.getCoordinatesWithLocation(
      origin: LatLng(
        currentPosition!.latitude,
        currentPosition!.longitude,
      ),
      destination: LatLng(
        widget.warehouse.latitude!,
        widget.warehouse.longitude!,
      ),
      mode: RouteMode.driving,
    );
    if (mounted) {
      setState(() {
        this.routes = routes;
      });
    }
  }

  Future<void> getCurrentPosition() async {
    currentPosition = await Geolocator.getCurrentPosition();
    if (currentPosition != null) {
      positionStream = Geolocator.getPositionStream().listen((Position? pos) {
        currentPosition = pos;
        distance = Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          widget.warehouse.latitude!,
          widget.warehouse.longitude!,
        ).toStringAsFixed(0);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapsBloc()..add(GetCurrentLocation()),
      child: BlocBuilder<MapsBloc, MapsState>(
        builder: (context, state) {
          if (state is MapsLoaded) {
            getPolylinesWithLocation();

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 72,
                leadingWidth: 68,
                backgroundColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
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
                    child: Text(
                      '$distance m lagi',
                      style:
                          semiboldTS.copyWith(fontSize: 12, color: blackColor),
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
                    currentPosition!.latitude,
                    currentPosition!.longitude,
                  ),
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.terrain,
                onMapCreated: (mapController) {
                  controller.complete(mapController);
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('Initial Location'),
                    position: LatLng(
                      state.position.latitude,
                      state.position.longitude,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('Driver Location'),
                    position: LatLng(
                      widget.warehouse.latitude!,
                      widget.warehouse.longitude!,
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange,
                    ),
                  ),
                },
                polylines: {
                  Polyline(
                    width: 4,
                    polylineId: const PolylineId('Route'),
                    color: blueColor,
                    points: routes ?? [],
                  ),
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      spreadRadius: -30,
                    ),
                  ],
                ),
                child: CustomContinue(
                  text: 'Scan Barcode',
                  action: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ScanBarcode(
                          warehouse: widget.warehouse,
                        ),
                        type: PageTransitionType.rightToLeft,
                      ),
                    );
                    positionStream.cancel();
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
                  'Sedang memuat peta, tunggu sebentar ya...',
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
