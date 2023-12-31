import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapsService {
  Future<Position> getUserCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Akses lokasi anda tidak aktif!');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi anda telah ditolak!');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi anda telah ditolak permanen!');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getFullAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String street = placemark.street ?? '';
        String subLocality = placemark.subLocality ?? '';
        String locality = placemark.locality ?? '';
        String administrativeArea = placemark.subAdministrativeArea ?? '';
        String postalCode = placemark.postalCode ?? '';

        // Construct the full address
        String fullAddress =
            '$street, $subLocality, $locality, $administrativeArea $postalCode';
        return fullAddress;
      } else {
        return 'Address not found';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> getShortAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks[0].street ?? '';
      } else {
        return 'Address not found';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> getShortAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks[0].street ?? '';
      } else {
        return 'Address not found';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // LatLngBounds calculateLatLngBounds(LatLng position1, LatLng position2) {
  //   double minLat = position1.latitude < position2.latitude
  //       ? position1.latitude
  //       : position2.latitude;

  //   double minLng = position1.longitude < position2.longitude
  //       ? position1.longitude
  //       : position2.longitude;

  //   double maxLat = position1.latitude > position2.latitude
  //       ? position1.latitude
  //       : position2.latitude;

  //   double maxLng = position1.longitude > position2.longitude
  //       ? position1.longitude
  //       : position2.longitude;

  //   LatLng southwest = LatLng(minLat, minLng);
  //   LatLng northeast = LatLng(maxLat, maxLng);

  //   return LatLngBounds(southwest: southwest, northeast: northeast);
  // }
}
