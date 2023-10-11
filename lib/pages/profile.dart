// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mj/pages/home.dart';
import 'package:mj/shared/const.dart';
import 'package:mj/widgets/custom_form.dart';
import 'package:page_transition/page_transition.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../services/user_service.dart';
import '../shared/method.dart';
import '../widgets/custom_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // User Profile Picture
            Center(
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: white2Color, width: 10),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: user!.photoURL != null
                        ? NetworkImage(user.photoURL.toString())
                            as ImageProvider
                        : const AssetImage('assets/images/profile.jpg'),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // User Display Name
            Text(
              '${user.displayName}',
              style: semiboldTS.copyWith(fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              '${user.email}',
              style: mediumTS.copyWith(color: blackBlur50Color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),

            // // User Joined Time
            // Text(
            //   'Joined in ${user.metadata.creationTime != null ? DateFormat('MMMM y').format(user.metadata.creationTime!) : 'unknown'}',
            //   style: mediumTS.copyWith(
            //     color: greyColor,
            //   ),
            //   textAlign: TextAlign.center,
            // ),

            const SizedBox(
              height: 40,
            ),

            // Profile Menu
            ProfileMenu(
              title: 'Edit Profile',
              iconUrl: 'assets/icons/profile_edit.png',
              action: () {
                Navigator.of(context).push(
                  PageTransition(
                    child: const EditProfile(),
                    type: PageTransitionType.rightToLeft,
                    childCurrent: this,
                  ),
                );
              },
            ),

            Divider(
              thickness: 1,
              color: blackBlur40Color,
            ),

            ProfileMenu(
              title: 'Help Center',
              iconUrl: 'assets/icons/profile_help.png',
              action: () {},
            ),

            Divider(
              thickness: 1,
              color: blackBlur40Color,
            ),

            ProfileMenu(
              title: 'Log Out',
              iconUrl: 'assets/icons/profile_logout.png',
              color: Colors.redAccent,
              isRouted: false,
              action: () {
                handleConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void handleConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            alignment: Alignment.center,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Apakah anda yakin ingin keluar?',
                    style: boldTS,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
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
                          width: 24,
                        ),
                        Expanded(
                          child: CustomContinue(
                            text: 'Ya',
                            action: () async {
                              context.read<AuthBloc>().add(AuthSignOut());
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

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final user = FirebaseAuth.instance.currentUser;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final currentPasswordController = TextEditingController();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();
  final currentPasswordFocusNode = FocusNode();

  bool _newPasswordVisible = true;
  bool _currentPasswordVisible = true;
  String recentEmail = '';
  Uint8List? pickedImage;

  Future<void> handleUpdateProfile() async {
    try {
      await user!.reauthenticateWithCredential(EmailAuthProvider.credential(
          email: recentEmail, password: currentPasswordController.text));

      if (newPasswordController.text.isNotEmpty) {
        await user!.updatePassword(newPasswordController.text);
      }

      if (recentEmail != emailController.text) {
        await user!.updateEmail(emailController.text);
      }

      if (pickedImage != null) {
        final url = await uploadImageToStorage(user!.uid, pickedImage!);
        await user!.updatePhotoURL(url);
        await UserService().updateUserPicture(user!.uid, url);
      }

      await user!.updateDisplayName(nameController.text);

      Navigator.pop(context);

      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(child: const Home(), type: PageTransitionType.fade),
        (route) => false,
      );

      showSnackbar(context, 'Profil berhasil diupdate!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'channel-error') {
        showSnackbar(context, 'Please insert your current password!');
      } else {
        showSnackbar(context, e.code);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = user!.displayName.toString();
    emailController.text = user!.email.toString();
    recentEmail = user!.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: blackColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    border: Border.all(color: white2Color, width: 10),
                    shape: BoxShape.circle,
                    image: pickedImage != null
                        ? DecorationImage(
                            image: MemoryImage(pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: NetworkImage(user!.photoURL.toString()),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
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
                          vertical: 10,
                          horizontal: 18,
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
                                width: 22,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Change Image',
                                style: semiboldTS,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // Name Form
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: semiboldTS.copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomFormField(
                      focusNode: nameFocusNode,
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      hintText: 'Type your name',
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // Email Form
                    Text(
                      'Email',
                      style: semiboldTS.copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomFormField(
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      hintText: 'Type your email',
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // New Password Form
                    Text(
                      'New Password',
                      style: semiboldTS.copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomFormField(
                      focusNode: newPasswordFocusNode,
                      controller: newPasswordController,
                      obscureText: _newPasswordVisible,
                      isPassword: true,
                      action: () {
                        setState(() {
                          _newPasswordVisible = !_newPasswordVisible;
                        });
                      },
                      hintText: 'Leave blank if won\'t change your password',
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // Current Password Form
                    Text(
                      'Current Password',
                      style: semiboldTS.copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomFormField(
                      focusNode: currentPasswordFocusNode,
                      controller: currentPasswordController,
                      obscureText: _currentPasswordVisible,
                      isPassword: true,
                      action: () {
                        setState(() {
                          _currentPasswordVisible = !_currentPasswordVisible;
                        });
                      },
                      hintText: 'Type your current password',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomContinue(
          text: 'Update',
          action: handleUpdateProfile,
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final String title, iconUrl;
  final Color? color;
  final bool? isRouted;
  final VoidCallback? action;
  const ProfileMenu({
    super.key,
    required this.title,
    required this.iconUrl,
    this.action,
    this.color = Colors.black,
    this.isRouted = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            ImageIcon(
              AssetImage(iconUrl),
              size: 24,
              color: color,
            ),
            const SizedBox(
              width: 18,
            ),
            Text(
              title,
              style: semiboldTS.copyWith(
                fontSize: 16,
                color: color,
              ),
            ),
            const Spacer(),
            if (isRouted == true)
              const Icon(
                Icons.navigate_next,
                size: 25,
              ),
          ],
        ),
      ),
    );
  }
}
