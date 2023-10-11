// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mj/services/user_service.dart';
import 'package:mj/widgets/custom_button.dart';
import 'package:page_transition/page_transition.dart';

import '../../shared/const.dart';
import '../../shared/method.dart';
import '../home.dart';

class UploadPicture extends StatefulWidget {
  const UploadPicture({super.key});

  @override
  State<UploadPicture> createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  Uint8List? pickedImage;

  Future<void> handleImageUpload() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final url = await uploadImageToStorage(user!.uid, pickedImage!);

      await user.updatePhotoURL(url);
      await UserService().updateUserPicture(user.uid, url);

      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const Home(),
          type: PageTransitionType.rightToLeft,
        ),
        (route) => false,
      );

      showSnackbar(context, 'Foto profil Anda berhasil diganti!');
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo_vector.png',
                    width: 48,
                  ),

                  const Spacer(),

                  // Skip Upload Profile Picture Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: const Home(),
                          type: PageTransitionType.rightToLeft,
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Skip',
                      style: mediumTS,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),

              // Title
              Text(
                'Bantu kami mengenal Anda!',
                style: semiboldTS.copyWith(fontSize: 32),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Akun anda berhasil dibuat. Selanjutnya pasang foto profil Anda!',
                style: mediumTS.copyWith(height: 1.5),
              ),
              const SizedBox(
                height: 40,
              ),

              // Display Image Widget
              Center(
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: white2Color, width: 10),
                    shape: BoxShape.circle,
                    image: pickedImage != null
                        ? DecorationImage(
                            image: MemoryImage(pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            scale: 3,
                            image: AssetImage('assets/images/profile.jpg'),
                          ),
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              // Insert Image Widget
              Center(
                child: GestureDetector(
                  onTap: () async {
                    Uint8List? img = await pickImage(ImageSource.gallery);
                    setState(() {
                      if (img != null) {
                        pickedImage = img;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: white3Color, width: 1.5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/profile_edit.png',
                            width: 24,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            pickedImage != null
                                ? 'Change Image'
                                : 'Upload Image',
                            style: semiboldTS,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Upload Image Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: pickedImage != null
            ? CustomContinue(
                text: 'Lanjutkan',
                action: handleImageUpload,
              )
            : CustomContinue(
                text: 'Lanjutkan',
                bgColor: white3Color,
              ),
      ),
    );
  }
}
