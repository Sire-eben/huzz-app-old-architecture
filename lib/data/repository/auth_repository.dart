// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/data/repository/business_repository.dart';
import 'package:huzz/data/repository/file_upload_repository.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/data/api_link.dart';
import 'package:huzz/presentation/auth/enter_otp.dart';
import 'package:huzz/presentation/auth/pin_successful.dart';
import 'package:huzz/presentation/auth/sign_in.dart';
import 'package:huzz/presentation/business/create_business.dart';
import 'package:huzz/presentation/app_scaffold.dart';
import 'package:huzz/presentation/forget_pass/enter_forget_pin.dart';
import 'package:huzz/presentation/reg_home.dart';
import 'package:huzz/presentation/team/team_success.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/business.dart';
import 'package:huzz/data/model/user.dart';
import 'package:huzz/data/model/user_referral_model.dart';
import 'package:huzz/data/sharepreference/share_pref.dart';
import 'package:huzz/data/sqlite/sqlite_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_team_invite_model.dart';
import 'fingerprint_repository.dart';

enum SignupStatus { Empty, Loading, Error, Success }

enum OtpAuthStatus { Empty, Loading, Error, Success }

enum OtpVerifyStatus { Empty, Loading, Error, Success }

enum UpdateProfileStatus { Empty, Loading, Error, Success }

enum OtpForgotVerifyStatus { Empty, Loading, Error, Success }

enum SigninStatus { Empty, Loading, Error, Success, InvalidPinOrPhoneNumber }

enum AuthStatus {
  Loading,
  Authenticated,
  UnAuthenticated,
  Error,
  Unknown_Error,
  Empty,
  IsFirstTime,
  PHONE_EXISTED,
  EMAIL_EXISTED,
  USERNAME_EXISTED,
  TOKEN_EXISTED
}

enum OnlineStatus { Onilne, Offline, Empty }

class AuthRepository extends GetxController {
  var otpController = TextEditingController();
  var pinController;
  final referralCodeController = TextEditingController();
  final teamInviteCodeController = TextEditingController();
  late final emailController = TextEditingController();
  late final lastNameController = TextEditingController();
  late final firstNameController = TextEditingController();
  late final forgotOtpController = TextEditingController();
  late final forgetPinController = TextEditingController();
  late final verifyPinController = TextEditingController();
  var confirmPinController = TextEditingController();
  var phoneNumberController = TextEditingController();
  late final updatePhoneNumberController = TextEditingController();
  late final forgotPhoneNumberController = TextEditingController();

  final _authStatus = AuthStatus.Empty.obs;
  final _signInStatus = SigninStatus.Empty.obs;
  final _signupStatus = SignupStatus.Empty.obs;
  final _otpAuthStatus = OtpAuthStatus.Empty.obs;
  final _otpVerifyStatus = OtpVerifyStatus.Empty.obs;
  final _updateProfileStatus = UpdateProfileStatus.Empty.obs;
  final _otpForgotVerifyStatus = OtpForgotVerifyStatus.Empty.obs;

  AuthStatus get authStatus => _authStatus.value;
  SignupStatus get signupStatus => _signupStatus.value;
  SigninStatus get signInStatus => _signInStatus.value;
  OtpAuthStatus get otpAuthStatus => _otpAuthStatus.value;
  OtpVerifyStatus get otpVerifyStatus => _otpVerifyStatus.value;
  UpdateProfileStatus get updateProfileStatus => _updateProfileStatus.value;
  OtpForgotVerifyStatus get otpForgotVerifyStatus =>
      _otpForgotVerifyStatus.value;

  final hasReferralDeeplink = false.obs;
  final hasTeamInviteDeeplink = false.obs;

  final _connectionStatus = ConnectivityResult.none.obs;
  ConnectivityResult get connectionStatus => _connectionStatus.value;

  // ignore: cancel_subscriptions
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String countryText = "234";
  String countryCodeFLag = "NG";

  final monLineStatus = OnlineStatus.Empty.obs;
  OnlineStatus get onlineStatus => monLineStatus.value;

  User? user;
  Business? business;
  SharePref? pref;

  Rx<String> mToken = Rx("");
  String get token => mToken.value;

  SqliteDb sqliteDb = SqliteDb();
  bool tokenExpired = false;
  Rx<File?> profileImage = Rx(null);
  @override
  void onInit() async {
    super.onInit();
    pref = SharePref();
    await pref!.init();
    if (pref!.getFirstTimeOpen()) {
      // print("My First Time Using this app");
      _authStatus(AuthStatus.IsFirstTime);
    } else {
      // print("Not my First Time Using this app");
      /**
        print(
            "expired date token ${pref!.getDateTokenExpired()} token expired $tokenExpired");
      */

      if (pref!.getUser() != null &&
          !DateTime.now().isAfter(pref!.getDateTokenExpired()) &&
          !tokenExpired) {
        // print("gotten here is value");
        user = pref!.getUser()!;

        mToken(pref!.read());
        // print("result of token is ${Mtoken.value}");

        _authStatus(AuthStatus.Authenticated);
        if (connectionStatus == ConnectivityResult.mobile ||
            connectionStatus == ConnectivityResult.wifi) {
          checkIfTokenStillValid();
        }
        if (mToken.value == "0") {
          _authStatus(AuthStatus.UnAuthenticated);
        }
      } else {
        _authStatus(AuthStatus.UnAuthenticated);
      }
    }
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _updateConnectionStatus(result);

      // print("result is $result");
    });
    final PendingDynamicLinkData? deepLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (deepLink != null) {
      checkIfReferralLinkIsAvailableFromDeeplink(deepLink);
    }
    FirebaseDynamicLinks.instance.onLink.listen((deepLink) {
      checkIfReferralLinkIsAvailableFromDeeplink(deepLink);
    });

    final PendingDynamicLinkData? teamInviteDeepLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (teamInviteDeepLink != null) {
      checkIfTeamInviteLinkIsAvailableFromDeeplink(teamInviteDeepLink);
    }
    FirebaseDynamicLinks.instance.onLink.listen((teamInviteDeepLink) {
      checkIfTeamInviteLinkIsAvailableFromDeeplink(teamInviteDeepLink);
    });
  }

  void checkIfReferralLinkIsAvailableFromDeeplink(
      PendingDynamicLinkData deepLink) {
    final String? refCode = deepLink.link.queryParameters['referralCode'];
    if (refCode != null) {
      referralCodeController.text = refCode;
      hasReferralDeeplink(true);
    }
  }

  void checkIfTeamInviteLinkIsAvailableFromDeeplink(
      PendingDynamicLinkData deepLink) {
    final String? teamInviteCode = deepLink.link.queryParameters['businessId'];
    if (teamInviteCode != null) {
      teamInviteCodeController.text = teamInviteCode;
      hasTeamInviteDeeplink(true);
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus(result);
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
//checking pending job for insertion,deletion and updating
      Get.snackbar("Internet Status", "Device is online now");
      monLineStatus(OnlineStatus.Onilne);
    } else {
      Get.snackbar("Internet Status", "Device is offline now");
      monLineStatus(OnlineStatus.Offline);
    }
  }

  Future sendSmsOtp({bool isResend = false}) async {
    // print("phone number ${user!.phoneNumber}");
    try {
      _otpAuthStatus(OtpAuthStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.sendSmsOtp),
          body: jsonEncode({"phoneNumber": "${user!.phoneNumber}"}),
          headers: {"Content-Type": "application/json"});
      // print("response is ${response.body}");
      if (response.statusCode == 200) {
        _otpAuthStatus(OtpAuthStatus.Success);
        Get.snackbar("Success", "Otp sent successfully",
            titleText: Text(
              'Success',
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            messageText: Text(
              'Otp sent successfully',
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.normal),
            ),
            icon: const Icon(Icons.check, color: AppColors.backgroundColor));

        if (!isResend) Get.to(() => const EnterOtp());
        // if (!isresend) _homeController.selectOnboardSelectedNext();
      } else {
        _otpAuthStatus(OtpAuthStatus.Error);
        Get.snackbar("Error", "Unable to send Otp",
            titleText: Text(
              'Error',
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            messageText: Text(
              'Unable to send Otp',
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.normal),
            ),
            icon: const Icon(Icons.info, color: AppColors.orangeBorderColor));
      }
    } catch (ex) {
      // print("error otp send ${ex.toString()}");
      _otpAuthStatus(OtpAuthStatus.Error);
    }
  }

  Future sendForgetOtp() async {
    // print("phone number $countryText${phoneNumberController.text}");
    try {
      _otpAuthStatus(OtpAuthStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.sendSmsOtp),
          body: jsonEncode({
            "phoneNumber": countryText + forgotPhoneNumberController.text.trim()
          }),
          headers: {"Content-Type": "application/json"});
      // print("response is ${response.body}");
      if (response.statusCode == 200) {
        _otpAuthStatus(OtpAuthStatus.Success);
        Get.snackbar("Success", "Otp sent successfully",
            titleText: Text(
              'Success',
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            messageText: Text(
              'Otp sent successfully',
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.normal),
            ),
            icon: const Icon(Icons.check, color: AppColors.backgroundColor));
        Timer(const Duration(milliseconds: 2000), () {
          Get.off(const EnterForgotPIN());
        });
      } else {
        _otpAuthStatus(OtpAuthStatus.Error);
        Get.snackbar("Error", "User with phone number not found",
            titleText: Text(
              'Error',
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            messageText: Text(
              'User with phone number not found',
              style: GoogleFonts.inter(
                  color: Colors.black, fontWeight: FontWeight.normal),
            ),
            icon: const Icon(Icons.info, color: AppColors.orangeBorderColor));
      }
    } catch (ex) {
      // print("error otp send ${ex.toString()}");
      _otpAuthStatus(OtpAuthStatus.Error);
    }
  }

  Future sendVoiceOtp() async {
    // _Otpauthstatus(OtpAuthStatus.Loading);
    final response = await http.post(Uri.parse(ApiLink.sendVoiceOtp),
        body: jsonEncode({"phoneNumber": "${user!.phoneNumber}"}),
        headers: {"Content-Type": "application/json"});
    // print("otp sent voice ${response.body}");
    if (response.statusCode == 200) {
      Get.snackbar("Success", "Otp sent successfully",
          titleText: Text(
            'Success',
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.w600),
          ),
          messageText: Text(
            'Otp sent successfully',
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.normal),
          ),
          icon: const Icon(Icons.check, color: AppColors.backgroundColor));
    } else {
      Get.snackbar("Error", "Unable to send Otp",
          titleText: Text(
            'Error',
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.w600),
          ),
          messageText: Text(
            'Unable to send Otp',
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.normal),
          ),
          icon: const Icon(Icons.info, color: AppColors.orangeBorderColor));
    }
  }

  Future verifyOpt() async {
    // print("otp value ${otpController.text}");
    try {
      _otpVerifyStatus(OtpVerifyStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.verifyOtp),
          body: jsonEncode({
            "phoneNumber": "${user!.phoneNumber}",
            "otp": otpController.text
          }),
          headers: {"Content-Type": "application/json"});

      // print("response of verify otp ${resposne.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          // _homeController.selectOnboardSelectedNext();

          _otpVerifyStatus(OtpVerifyStatus.Success);
          Get.snackbar("Success", "Otp sent successfully",
              titleText: Text(
                'Success',
                style: GoogleFonts.inter(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
              messageText: Text(
                'Otp sent successfully',
                style: GoogleFonts.inter(
                    color: Colors.black, fontWeight: FontWeight.normal),
              ),
              icon: const Icon(Icons.check, color: AppColors.backgroundColor));

          getUser();
        } else {
          _otpVerifyStatus(OtpVerifyStatus.Error);
          Get.snackbar("Error", "Unable to send Otp",
              titleText: Text(
                'Error',
                style: GoogleFonts.inter(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
              messageText: Text(
                'Unable to send Otp',
                style: GoogleFonts.inter(
                    color: Colors.black, fontWeight: FontWeight.normal),
              ),
              icon: const Icon(Icons.info, color: AppColors.orangeBorderColor));
        }
      }
    } catch (ex) {
      // print("error from verify otp ${ex.toString()}");
      Get.snackbar("Error", "Error verifying Otp",
          titleText: Text(
            'Error',
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.w600),
          ),
          messageText: Text(
            'Error verifying Otp',
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.normal),
          ),
          icon: const Icon(Icons.info, color: AppColors.orangeBorderColor));
      _otpVerifyStatus(OtpVerifyStatus.Error);
    }
  }

  Future verifyForgotOpt() async {
    try {
      _otpForgotVerifyStatus(OtpForgotVerifyStatus.Loading);
      // print("otp value ${otpController.text}");

      final response = await http.put(Uri.parse(ApiLink.forgetPin),
          body: jsonEncode({
            "phoneNumber":
                countryText + forgotPhoneNumberController.text.trim(),
            "otp": forgotOtpController.text,
            "pin": forgetPinController.text
          }),
          headers: {"Content-Type": "application/json"}).timeout(
        const Duration(seconds: 30),
        onTimeout: (() {
          throw TimeoutException('Connection timeout, Please try again!');
        }),
      );

      // print("response of verify forgot pass otp ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          _otpForgotVerifyStatus(OtpForgotVerifyStatus.Success);
          Get.snackbar(
            "PIN successfully changed.",
            "Proceed to Login.",
          );
          Timer(const Duration(milliseconds: 2000), () {
            Get.offAll(const SignIn());
          });
        } else {
          _otpForgotVerifyStatus(OtpForgotVerifyStatus.Error);
          Get.snackbar("Error", "Unable to change PIN");
        }
      }
    } catch (ex) {
      // print("error from PIN changing ${ex.toString()}");
      Get.snackbar("Error", "Unable to change PIN");
      _otpForgotVerifyStatus(OtpForgotVerifyStatus.Error);
    }
  }

  Future updateProfileImage() async {
    try {
      _updateProfileStatus(UpdateProfileStatus.Loading);
      // print("otp value ${otpController.text}");
      final uploadController = Get.find<FileUploadRepository>();
      String? imageId;
      if (profileImage.value != null) {
        imageId = await uploadController.uploadFile(profileImage.value!.path);
      }
      // print("image url is $imageId");
      final response = await http.put(Uri.parse(ApiLink.updateProfile),
          body: jsonEncode({
            // "profileImageFileStoreId": imageId,
            "profileImageUrl": imageId
            // "phoneNumber": countryText + updatePhoneNumberController.text.trim()
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });

      // print("response of update personal profile info ${resposne.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        // print("user detail $json");
        var user = User.fromJsonSettngs(json);
        user.businessList = this.user!.businessList;
        this.user = user;
        pref!.setUser(user);

        _updateProfileStatus(UpdateProfileStatus.Success);
        Get.snackbar(
          "Success",
          "Personal Profile Image",
        );
        Timer(const Duration(milliseconds: 2000), () {
          Get.back();
        });
        // } else {

        //   Get.snackbar(
        //     "Error",
        //     "Failed to update Personal Information",
        //   );
        // }
      } else {
        _updateProfileStatus(UpdateProfileStatus.Error);
        var json = jsonDecode(response.body);
        Get.snackbar("${json['error']}", "${json['message']}");
      }
    } catch (ex) {
      _updateProfileStatus(UpdateProfileStatus.Error);
      // print("error from updating personal information ${ex.toString()}");
      Get.snackbar(
        "Error",
        "Failed to update Personal Profile Image",
      );
      _updateProfileStatus(UpdateProfileStatus.Error);
    }
  }

  Future updateProfile() async {
    try {
      _updateProfileStatus(UpdateProfileStatus.Loading);
      // print("otp value ${otpController.text}");
      final uploadController = Get.find<FileUploadRepository>();
      String? imageId;
      if (profileImage.value != null) {
        imageId = await uploadController.uploadFile(profileImage.value!.path);
      }
      final response = await http.put(Uri.parse(ApiLink.updateProfile),
          body: jsonEncode({
            "firstName": firstNameController.text,
            "lastName": lastNameController.text,
            "email": emailController.text,
            // "profileImageFileStoreId": imageId,
            // "phoneNumber": countryText + updatePhoneNumberController.text.trim()
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });

      // print("response of update personal info ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        // print("user detail $json");
        var user = User.fromJsonSettngs(json);
        user.businessList = this.user!.businessList;
        this.user = user;
        pref!.setUser(user);

        _updateProfileStatus(UpdateProfileStatus.Success);
        Get.snackbar(
          "Success",
          "Personal Information Updated",
        );
        Timer(const Duration(milliseconds: 2000), () {
          Get.back();
        });
        // } else {

        //   Get.snackbar(
        //     "Error",
        //     "Failed to update Personal Information",
        //   );
        // }
      } else {
        _updateProfileStatus(UpdateProfileStatus.Error);
        var json = jsonDecode(response.body);
        Get.snackbar("${json['error']}", "${json['message']}");
      }
    } catch (ex) {
      _updateProfileStatus(UpdateProfileStatus.Error);
      // print("error from updating personal information ${ex.toString()}");
      Get.snackbar(
        "Error",
        "Failed to update Personal Information",
      );
      _updateProfileStatus(UpdateProfileStatus.Error);
    }
  }

  Future getUser() async {
    try {
      _updateProfileStatus(UpdateProfileStatus.Loading);
      // print("getting user data");

      final response = await http.get(Uri.parse(ApiLink.getUser), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      // print("response of update personal info ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        // print("user detail $json");
        var user = User.fromJsonSettngs(json);
        user.businessList = this.user!.businessList;
        this.user = user;
        pref!.setUser(user);
        Get.offAll(() => Dashboard());

        _updateProfileStatus(UpdateProfileStatus.Success);
      }
    } catch (ex) {
      _updateProfileStatus(UpdateProfileStatus.Error);
      // print("error from updating personal information ${ex.toString()}");
    }
  }

  Future signUp() async {
    try {
      _signupStatus(SignupStatus.Loading);
      final signupDto = {
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "pin": pinController.text,
        "phoneNumber": countryText + phoneNumberController.text.trim()
      };
      if (referralCodeController.text.isNotEmpty) {
        signupDto.putIfAbsent(
          "referralCode",
          () => referralCodeController.text.trim(),
        );
      }
      final response = await http.post(Uri.parse(ApiLink.signupUser),
          body: jsonEncode(signupDto),
          headers: {"Content-Type": "application/json"});
      // print("sign up response ${response.body} ${response.statusCode}");
      if (response.statusCode == 201) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          _signupStatus(SignupStatus.Success);

          var token = json['data']['accessToken'];
          var user = User.fromJson(json['data']);
          mToken(token);
          pref!.saveToken(token);
          this.user = user;
          pref!.setUser(user);
          DateTime date = DateTime.now();
          DateTime expireToken = DateTime(date.year, date.month + 1, date.day);
          pref!.setDateTokenExpired(expireToken);
          _authStatus(AuthStatus.Authenticated);
          Get.off(const PinSuccessful());
        }
      } else if (response.statusCode == 406) {
        var json = jsonDecode(response.body);
        Get.snackbar("SignUp Error", json['message']);
        _signupStatus(SignupStatus.Error);
      } else {
        Get.snackbar("SignUp Error", "Something have occurred try again later");
        _signupStatus(SignupStatus.Error);
      }
    } catch (ex) {
      // print("error occurred ${ex.toString()}");
      Get.snackbar("SignUp Error", "Something have occurred try again later");
      _signupStatus(SignupStatus.Error);
    }
  }

  Future signIn() async {
    /**
      print(
          "phone number ${phoneNumberController.text}  country code $countryText");
    */
    // print("pin is ${pinController.text}");
    try {
      _signInStatus(SigninStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.signInUser),
          body: jsonEncode({
            "phoneNumber": countryText + phoneNumberController.text.trim(),
            "pin": pinController.text,
            // "pin":"3152"
          }),
          headers: {"Content-Type": "application/json"});
      // print("sign in response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        _signInStatus(SigninStatus.Success);

        var token = json['accessToken'];
        var user = User.fromJson(json);
        // print("token from mtoken is $Mtoken");
        mToken(token);
        pref!.saveToken(token);
        pref!.setUser(user);
        //  Mtoken=Rx(token);

        // print("user to json ${user.toJson()}");
        this.user = user;

        DateTime date = DateTime.now();

        DateTime expireToken = DateTime(date.year, date.month + 1, date.day);

        pref!.setDateTokenExpired(expireToken);

        _authStatus(AuthStatus.Authenticated);
        final _businessController = Get.find<BusinessRepository>();
        _businessController.setBusinessList(user.businessList!);
        mToken(token);
        // print("user business length ${user.businessList!.length}");
        if (user.businessList!.isEmpty || user.businessList == null) {
          Get.off(() => const CreateBusiness());
        } else {
          Get.offAll(() => Dashboard());
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Login Error", "Invalid Credential ");
        _signInStatus(SigninStatus.Error);
      } else {
        Get.snackbar(
            "Login Error", "Something have occurred try again later.. ");
        _signInStatus(SigninStatus.Error);
      }
    } catch (ex) {
      _signInStatus(SigninStatus.Error);
      // print("Sign in Error ${ex.toString()}");
    }
  }

  Future getUserData() async {
    /**
      print(
          "phone number ${phoneNumberController.text}  country code $countryText");
    */
    // print("pin is ${pinController.text}");
    try {
      // _signinStatus(SigninStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.signInUser),
          body: jsonEncode({
            "phoneNumber": countryText + phoneNumberController.text.trim(),
            "pin": pinController.text,
            // "pin":"3152"
          }),
          headers: {"Content-Type": "application/json"});
      // print("sign in response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        // _signinStatus(SigninStatus.Success);

        var token = json['accessToken'];
        var user = User.fromJson(json);
        // print("token from mtoken is $Mtoken");
        mToken(token);
        pref!.saveToken(token);
        pref!.setUser(user);
        //  Mtoken=Rx(token);

        // print("user to json ${user.toJson()}");
        this.user = user;

        // DateTime date = DateTime.now();

        // DateTime expireToken = DateTime(date.year, date.month + 1, date.day);

        // pref!.setDateTokenExpired(expireToken);

        // _authStatus(AuthStatus.Authenticated);

        // final _businessController = Get.find<BusinessRespository>();
        // _businessController.setBusinessList(user.businessList!);
        // Mtoken(token);
        // print("user business length ${user.businessList!.length}");
        // if (user.businessList!.isEmpty || user.businessList == null) {
        //   Get.off(() => CreateBusiness());
        // } else {
        //   Get.offAll(() => Dashboard());
        // }
      }

      // else if (response.statusCode == 401) {
      //   Get.snackbar("Login Error", "Invalid Credential ");
      //   _signinStatus(SigninStatus.Error);
      // } else {
      //   Get.snackbar(
      //       "Login Error", "Something have occurred try again later.. ");
      //   _signinStatus(SigninStatus.Error);
      // }
    } catch (ex) {
      _signInStatus(SigninStatus.Error);
      // print("Sign in Error ${ex.toString()}");
    }
  }

  Future fingerPrintSignIn() async {
    _signInStatus(SigninStatus.Loading);
    try {
      final isAuthenticated = await LocalAuthApi.authenticate();

      if (isAuthenticated) {
        _signInStatus(SigninStatus.Success);

        pref!.saveToken(token);
        pref!.setUser(user!);
        mToken(token);
        user = user;
        DateTime date = DateTime.now();
        DateTime expireToken = DateTime(date.year, date.month + 30, date.day);
        pref!.setDateTokenExpired(expireToken);
        _authStatus(AuthStatus.Authenticated);
        Get.off(() => Dashboard());
      } else if (!isAuthenticated) {
        Get.snackbar("Login Error", "Invalid Credential ");
        _signInStatus(SigninStatus.Error);
      } else {
        Get.snackbar(
            "Login Error", "Something have occurred try again later.. ");
        _signInStatus(SigninStatus.Error);
      }
    } catch (ex) {
      _signInStatus(SigninStatus.Error);
    }
  }

  Future<UserReferralModel> getUserReferralData() async {
    try {
      final response = await http.get(Uri.parse(ApiLink.userReferral),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      final json = jsonDecode(response.body);
      if (response.statusCode != 200 || !json['status']) {
        throw json['message'] ?? "Unexpected error occurred";
      }
      return UserReferralModel.fromMap(json['data']);
    } on SocketException catch (_) {
      throw "Network not available, connect to the internet and try again";
    } catch (e) {
      rethrow;
    }
  }

  Future<UserTeamInviteModel> getUserTeamInviteData() async {
    try {
      final response = await http.get(Uri.parse(ApiLink.userReferral),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      final json = jsonDecode(response.body);
      if (response.statusCode != 200 || !json['status']) {
        throw json['message'] ?? "Unexpected error occurred";
      }
      return UserTeamInviteModel.fromMap(json['data']);
    } on SocketException catch (_) {
      throw "Network not available, connect to the internet and try again";
    } catch (e) {
      rethrow;
    }
  }

  void deleteUsersAccounts() async {
    _authStatus(AuthStatus.Loading);
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final key = 'token';
      // final value = prefs.get(key) ?? 0;

      String myUrl = ApiLink.deleteUser;
      var response = await http.delete(Uri.parse(myUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

      // ignore: unnecessary_null_comparison
      // print("delete account response ${response.body}");
      if (response.statusCode != null) {
        // ignore: unnecessary_null_comparison
        if (response != null) {
          _authStatus(AuthStatus.Empty);
          Get.snackbar("Success", "Your account have been deleted");
          logout();
          accountDeleteLogout();
        }
      } else {
        _authStatus(AuthStatus.Empty);
      }
    } catch (error) {
      _authStatus(AuthStatus.Error);
    }
  }

  void deleteBusinessAccounts() async {
    _authStatus(AuthStatus.Loading);
    try {
      final _businessController = Get.find<BusinessRepository>();
      /**
        print(
            'deleting business ${_businessController.selectedBusiness.value!.businessName}');
      */
      final prefs = await SharedPreferences.getInstance();
      const key = 'token';
      final value = prefs.get(key) ?? 0;
      String? id = _businessController.selectedBusiness.value!.businessId;

      String myUrl = ApiLink.deleteBusiness + '$id';
      var response = await http.delete(Uri.parse(myUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $value'
      });

      // ignore: unnecessary_null_comparison
      // print('deleting business response: ' + response.body);
      if (response.statusCode == 200) {
        _authStatus(AuthStatus.Authenticated);

        // ignore: unnecessary_null_comparison
        if (response != null) {
          Get.snackbar("Success", "Your Business account have been deleted");

          logout();
        }
      } else {
        Get.snackbar("Error",
            "Error occurred while deleting your business, try again!.");
        _authStatus(AuthStatus.Empty);
      }
    } catch (error) {
      _authStatus(AuthStatus.Error);
    }
  }

  void accountDeleteLogout() {
    _authStatus(AuthStatus.UnAuthenticated);
    pref!.saveToken("0");
    clearDatabase();
    pref!.logout();
    Get.offAll(() => const RegHome());
  }

  void checkTeamInvite() {
    if (onlineStatus == OnlineStatus.Onilne) {
      try {
        final _businessController = Get.find<BusinessRepository>();
        if (kDebugMode) {
          // print('Team Invite deeplink: ${hasTeamInviteDeeplink.value}');
          // print('Referral Invite deeplink: ${hasReferralDeeplink.value}');
        }
        if (hasTeamInviteDeeplink.value == true) {
          hasTeamInviteDeeplink(false);
          Get.to(() => const TeamSuccess());
          _businessController.OnlineBusiness();
          // Get.snackbar("Success", "You've been invited to a team successfully");
        }
      } catch (error) {
        if (kDebugMode) {
          // print('Team Invite error: $error');
          //  Get.snackbar("Error", "An error occurred ");
        }
      }
    }
  }

  void checkDeletedTeamBusiness() async {
    try {
      final _businessController = Get.find<BusinessRepository>();
      // _businessController.checkOnlineBusiness();
      /**
        if (kDebugMode) {
          print(
              'Online business: ${_businessController.onlineBusinessLength.value}');
          print(
              'Offline business: ${_businessController.offlineBusinessLength.value}');
        }
      */
      if (_businessController.onlineBusinessLength.value !=
          _businessController.offlineBusinessLength.value) {
        // print('update business...');
        // logout();
      }
    } catch (error) {
      /**
        if (kDebugMode) {
          // print('check deleted business: $error');
        }
      */
    }
  }

  void logout() {
    _authStatus(AuthStatus.UnAuthenticated);
    pref!.saveToken("0");
    clearDatabase();
    mToken("0");
    pref!.logout();
    phoneNumberController.text = '';
    Get.offAll(const SignIn());
    final businessController = Get.find<BusinessRepository>();
    businessController.selectedBusiness = Rx(Business(businessId: null));
  }

  void clearDatabase() async {
    pref!.setLastSelectedBusiness("");
    await sqliteDb.openDatabae();
    await sqliteDb.deleteAllOfflineBusiness();
    await sqliteDb.deleteAllOfflineTransaction();
    await sqliteDb.deleteAllProducts();
    await sqliteDb.deleteAllCustomers();
    // await sqliteDb.deleteAllTeam();
    await sqliteDb.deleteAllOfflineDebtors();
    await sqliteDb.deleteAllInvoice();
    await sqliteDb.deleteAllBanks();
  }

  void clearProduct() async {
    final _productController = Get.find<ProductRepository>();
    final _businessController = Get.find<BusinessRepository>();

    // print('clearing products...');
    await sqliteDb.openDatabae();
    await sqliteDb.deleteAllProducts();
    // print('products cleared!');

    _productController.getOfflineProduct(
        _businessController.selectedBusiness.value!.businessId!);
    _productController.getOnlineProduct(
        _businessController.selectedBusiness.value!.businessId!);
  }

  void checkIfTokenStillValid() async {
    var response = await http.get(Uri.parse(ApiLink.getUserBusiness),
        headers: {"Authorization": "Bearer $token"});

    // print("online business result ${response.body}");
    if (response.statusCode == 401) {
      _authStatus(AuthStatus.TOKEN_EXISTED);
      Get.snackbar("Error", "Your Login token is expired.");
      Get.offAll(const SignIn());
    }
  }
}
