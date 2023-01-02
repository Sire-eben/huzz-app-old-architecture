import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/presentation/settings/business_info.dart';
import 'package:huzz/presentation/settings/referral_bottom_sheet.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'notification.dart';
import 'personal_info.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final controller = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  final teamController = Get.find<TeamRepository>();

  late String email;
  late String phone;
  late String? lastName;
  late String firstName;

  final users = Rx(User());
  User? get usersData => users.value;

  @override
  void initState() {
    firstName = controller.user!.firstName!;
    lastName = controller.user!.lastName!;
    // print("user json ${controller.user!.toJson()}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            color: AppColors.backgroundColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 100,
            right: 100,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(
                  width: 2,
                  color: AppColors.backgroundColor,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: (controller.profileImage.value != null)
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(
                            controller.profileImage.value!,
                          ))
                      : (controller.user!.profileImageFileStoreUrl!.isEmpty)
                          ? const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
                                "assets/images/profileImg.png",
                              ))
                          : CircleAvatar(
                              radius: 50.0,
                              backgroundImage: NetworkImage(
                                  controller.user!.profileImageFileStoreUrl!),
                              backgroundColor: Colors.transparent,
                            )),
            ),
          ),
          Positioned(
            top: 90,
            left: 200,
            right: 115,
            child: GestureDetector(
              onTap: () => showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  context: context,
                  builder: (context) => buildAddImage()),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  border: Border.all(
                    width: 2,
                    color: AppColors.backgroundColor,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/addcamera.svg",
                    height: 15,
                    width: 15,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 10,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.user!.firstName == null
                            ? 'First Name'
                            : firstName,
                        style: GoogleFonts.inter(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        controller.user!.lastName == null
                            ? 'Last Name'
                            : lastName!,
                        style: GoogleFonts.inter(
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Personal Account
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xffE6F4F2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColors.whiteColor,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/images/user.svg",
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Personal Account',
                          style: GoogleFonts.inter(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(const PersonalInfo());
                          },
                          child: SvgPicture.asset(
                            "assets/images/setting.svg",
                            height: 20,
                            width: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _displayProfileDialog(
                                context,
                                'You are about to delete your Huzz account and all associated data. This is an irreversible action. Are you sure you want to continue?',
                                () {});
                          },
                          child: SvgPicture.asset(
                            "assets/images/delete.svg",
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Business Account
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xffE6F4F2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColors.whiteColor,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/images/business.svg",
                              height: 15,
                              width: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Business Account',
                          style: GoogleFonts.inter(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(const BusinessInfo());
                          },
                          child: SvgPicture.asset(
                            "assets/images/setting.svg",
                            height: 20,
                            width: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Obx(() {
                          return InkWell(
                            onTap: () {
                              _displayBusinessDialog(
                                context,
                                'You are about to delete ${_businessController.selectedBusiness.value!.businessName} business and all associated data. This is an irreversible action. Are you sure you want to continue?',
                                () {},
                              );
                            },
                            child: controller.authStatus == AuthStatus.Loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: AppColors.orangeBorderColor),
                                  )
                                : SvgPicture.asset(
                                    "assets/images/delete.svg",
                                    height: 20,
                                    width: 20,
                                  ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Notification
                  GestureDetector(
                    onTap: () {
                      Get.to(const Notifications());
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xffE6F4F2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                width: 2,
                                color: AppColors.whiteColor,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/images/bell.svg",
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Notification Settings',
                            style: GoogleFonts.inter(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            "assets/images/setting.svg",
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Referral
                  GestureDetector(
                    onTap: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => const ReferralBottomSheet(),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xffE6F4F2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                width: 2,
                                color: AppColors.whiteColor,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/images/gift.png",
                                height: 18,
                                width: 18,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Referrals',
                            style: GoogleFonts.inter(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // LogOut
                  InkWell(
                    onTap: () {
                      _displayLogoutDialog(
                          context, "Are you sure you want to log out.?", () {
                        // controller.logout();
                      });
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xffE6F4F2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            "assets/images/logout.svg",
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Logout',
                            style: GoogleFonts.inter(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  // LogOut
                  controller.user!.phoneNumberVerified == true
                      ? Container()
                      : Obx(() {
                          return InkWell(
                            onTap: () {
                              _displayVerifyPhoneDialog(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              height: 55,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: AppColors.orangeBorderColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: (controller.Otpauthstatus ==
                                      OtpAuthStatus.Loading)
                                  ? const SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white)),
                                    )
                                  : Center(
                                      child: Text(
                                        'Verify your Phone Number',
                                        style: GoogleFonts.inter(
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddImage() => Obx(() {
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 3,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xffE6F4F2),
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'Upload Image',
                style: GoogleFonts.inter(
                  color: AppColors.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  controller.profileImage(File(image!.path));
                  // print("image path ${image.path}");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (controller.profileImage.value != null)
                        ? Container(
                            height: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: FileImage(
                                  controller.profileImage.value!,
                                ))),
                          )
                        : SvgPicture.asset(
                            'assets/images/camera.svg',
                            height: 80,
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  'Select from Device',
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await controller.updateProfileImage();
                  Get.back();
                  setState(() {});
                },
                child: Container(
                  height: 55,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: (controller.updateProfileStatus ==
                          UpdateProfileStatus.Loading)
                      ? const Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                          ),
                        )
                      : Center(
                          child: Text(
                            'Done',
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      });

  _displayProfileDialog(
      BuildContext context, String title, VoidCallback onContinue) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 55,
              vertical: 240,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: SvgPicture.asset(
                    'assets/images/polygon.svg',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColors.backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Get.back();
                        controller.deleteUsersAccounts();
                        onContinue();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Delete',
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _displayVerifyPhoneDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 280,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Text(
                    'Verify your phone number?',
                    style: GoogleFonts.inter(
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              'Please click continue if you want to proceed',
              style: GoogleFonts.inter(
                color: AppColors.blackColor,
                fontWeight: FontWeight.normal,
                fontSize: 11,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColors.backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.sendSmsOtp();
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _displayLogoutDialog(
      BuildContext context, String title, VoidCallback onContinue) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 55,
              vertical: 250,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: SvgPicture.asset(
                    'assets/images/polygon.svg',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColors.backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        controller.logout();
                        onContinue();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Logout',
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _displayBusinessDialog(
      BuildContext context, String title, VoidCallback onContinue) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 55,
              vertical: 240,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              children: [
                Expanded(
                  child: SvgPicture.asset(
                    'assets/images/polygon.svg',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColors.backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: AppColors.backgroundColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // print('deleting business...');
                        controller.deleteBusinessAccounts();
                        onContinue();
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Delete',
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
