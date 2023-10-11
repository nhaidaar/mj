import 'dart:math';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mj/shared/const.dart';

int hitungPoin(int integerPart, int decimalPart) {
  return ((integerPart + decimalPart * 0.1) * 2000).toInt();
}

void showSnackbar(BuildContext context, String message) {
  Flushbar(
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: orangeColor,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(10),
    borderRadius: BorderRadius.circular(41),
  ).show(context);
}

String generateOrderId() {
  final Random random = Random();
  const String charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String result = "";

  for (int i = 0; i < 10; i++) {
    result += charset[random.nextInt(charset.length)];
  }

  return result;
}

// LatLngBounds boundsFromLatLngList(List<LatLng> list) {
//   double? x0, x1, y0, y1;
//   for (LatLng latLng in list) {
//     if (x0 == null || x1 == null || y0 == null || y1 == null) {
//       x0 = x1 = latLng.latitude;
//       y0 = y1 = latLng.longitude;
//     } else {
//       if (latLng.latitude > x1) x1 = latLng.latitude;
//       if (latLng.latitude < x0) x0 = latLng.latitude;
//       if (latLng.longitude > y1) y1 = latLng.longitude;
//       if (latLng.longitude < y0) y0 = latLng.longitude;
//     }
//   }

//   return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
// }

Future pickImage(ImageSource source) async {
  XFile? img = await ImagePicker().pickImage(source: source);
  if (img != null) {
    return await img.readAsBytes();
  }
}

Future<String> uploadImageToStorage(String uid, Uint8List image) async {
  final storageRef =
      FirebaseStorage.instance.ref().child('profilePictures/$uid.jpg');

  // Upload the file to Firebase Storage
  final uploadTask = storageRef.putData(image);

  // Get the download URL
  final snapshot = await uploadTask;
  final downloadURL = await snapshot.ref.getDownloadURL();

  // Return the download URL
  return downloadURL;
}
