import 'dart:math';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
    boxShadows: const [
      BoxShadow(
        blurRadius: 10,
        spreadRadius: -20,
      )
    ],
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.all(20),
    borderRadius: BorderRadius.circular(10),
  ).show(context);
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: blackBlur40Color,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: yellowColor,
        ),
        padding: const EdgeInsets.all(28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: blackColor,
            ),
            const SizedBox(width: 20),
            Text(
              'Tunggu ya...',
              style: mediumTS.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );
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
