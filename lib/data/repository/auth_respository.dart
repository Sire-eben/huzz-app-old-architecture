// ignore_for_file: constant_identifier_names, non_constant_identifier_names

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
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/file_upload_respository.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/data/api_link.dart';
import 'package:huzz/ui/auth/enter_otp.dart';
import 'package:huzz/ui/auth/pin_successful.dart';
import 'package:huzz/ui/auth/sign_in.dart';
import 'package:huzz/ui/business/create_business.dart';
import 'package:huzz/ui/app_scaffold.dart';
import 'package:huzz/ui/forget_pass/enter_forget_pin.dart';
import 'package:huzz/ui/more/more.dart';
import 'package:huzz/ui/reg_home.dart';
import 'package:huzz/ui/team/join_team.dart';
import 'package:huzz/ui/team/team_success.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/business.dart';
import 'package:huzz/data/model/user.dart';
import 'package:huzz/data/model/user_referral_model.dart';
import 'package:huzz/data/sharepreference/sharepref.dart';
import 'package:huzz/data/sqlite/sqlite_db.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_teamInvite_model.dart';
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
  late final forgetpinController = TextEditingController();
  late final verifypinController = TextEditingController();
  var confirmPinController = TextEditingController();
  var phoneNumberController = TextEditingController();
  late final updatePhoneNumberController = TextEditingController();
  late final forgotPhoneNumberController = TextEditingController();

  final _authStatus = AuthStatus.Empty.obs;
  final _signinStatus = SigninStatus.Empty.obs;
  final _signupStatus = SignupStatus.Empty.obs;
  final _Otpauthstatus = OtpAuthStatus.Empty.obs;
  final _Otpverifystatus = OtpVerifyStatus.Empty.obs;
  final _updateProfileStatus = UpdateProfileStatus.Empty.obs;
  final _Otpforgotverifystatus = OtpForgotVerifyStatus.Empty.obs;

  AuthStatus get authStatus => _authStatus.value;
  SignupStatus get signupStatus => _signupStatus.value;
  SigninStatus get signinStatus => _signinStatus.value;
  OtpAuthStatus get Otpauthstatus => _Otpauthstatus.value;
  OtpVerifyStatus get Otpverifystatus => _Otpverifystatus.value;
  UpdateProfileStatus get updateProfileStatus => _updateProfileStatus.value;
  OtpForgotVerifyStatus get Otpforgotverifystatus =>
      _Otpforgotverifystatus.value;

  final hasReferralDeeplink = false.obs;
  final hasTeamInviteDeeplink = false.obs;

  final _connectionStatus = ConnectivityResult.none.obs;
  ConnectivityResult get connectionStatus => _connectionStatus.value;

  // ignore: cancel_subscriptions
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String countryText = "234";
  String countryCodeFLag = "NG";

  final MonlineStatus = OnlineStatus.Empty.obs;
  OnlineStatus get onlineStatus => MonlineStatus.value;

  User? user;
  Business? business;
  SharePref? pref;

  Rx<String> Mtoken = Rx("");
  String get token => Mtoken.value;

  SqliteDb sqliteDb = SqliteDb();
  bool tokenExpired = false;
  Rx<File?> profileImage = Rx(null);

  @override
  void onInit() async {
    super.onInit();
    pref = SharePref();
    await pref!.init();
    if (pref!.getFirstTimeOpen()) {
      _authStatus(AuthStatus.IsFirstTime);
    } else {
      if (pref!.getUser() != null &&
          !DateTime.now().isAfter(pref!.getDateTokenExpired()) &&
          !tokenExpired) {
        user = pref!.getUser()!;

        Mtoken(pref!.read());

        _authStatus(AuthStatus.Authenticated);
        if (connectionStatus == ConnectivityResult.mobile ||
            connectionStatus == ConnectivityResult.wifi) {
          checkIfTokenStillValid();
        }
        if (Mtoken.value == "0") {
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

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus(result);
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
//checking pending job for insertion,deletion and updating
      Get.snackbar("Internet Status", "Device is online now");
      MonlineStatus(OnlineStatus.Onilne);
    } else {
      Get.snackbar("Internet Status", "Device is offline now");
      MonlineStatus(OnlineStatus.Offline);
    }
  }

  Future sendSmsOtp({bool isresend = false}) async {
    try {
      _Otpauthstatus(OtpAuthStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.sendSmsOtp),
          body: jsonEncode({"phoneNumber": "${user!.phoneNumber}"}),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        _Otpauthstatus(OtpAuthStatus.Success);
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

        if (!isresend) Get.to(() => EnterOtp());
        // if (!isresend) _homeController.selectOnboardSelectedNext();
      } else {
        _Otpauthstatus(OtpAuthStatus.Error);
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
      _Otpauthstatus(OtpAuthStatus.Error);
    }
  }

  Future sendForgetOtp() async {
    try {
      _Otpauthstatus(OtpAuthStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.sendSmsOtp),
          body: jsonEncode({
            "phoneNumber": countryText + forgotPhoneNumberController.text.trim()
          }),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        _Otpauthstatus(OtpAuthStatus.Success);
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
        _Otpauthstatus(OtpAuthStatus.Error);
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
      _Otpauthstatus(OtpAuthStatus.Error);
    }
  }

  Future sendVoiceOtp() async {
    // _Otpauthstatus(OtpAuthStatus.Loading);
    final response = await http.post(Uri.parse(ApiLink.sendVoiceOtp),
        body: jsonEncode({"phoneNumber": "${user!.phoneNumber}"}),
        headers: {"Content-Type": "application/json"});
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
    try {
      _Otpverifystatus(OtpVerifyStatus.Loading);
      final resposne = await http.post(Uri.parse(ApiLink.verifyOtp),
          body: jsonEncode({
            "phoneNumber": "${user!.phoneNumber}",
            "otp": otpController.text
          }),
          headers: {"Content-Type": "application/json"});

      if (resposne.statusCode == 200) {
        var json = jsonDecode(resposne.body);
        if (json['success']) {
          // _homeController.selectOnboardSelectedNext();

          _Otpverifystatus(OtpVerifyStatus.Success);
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
          _Otpverifystatus(OtpVerifyStatus.Error);
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
      _Otpverifystatus(OtpVerifyStatus.Error);
    }
  }

  Future verifyForgotOpt() async {
    try {
      _Otpforgotverifystatus(OtpForgotVerifyStatus.Loading);

      final response = await http.put(Uri.parse(ApiLink.forgetPin),
          body: jsonEncode({
            "phoneNumber":
                countryText + forgotPhoneNumberController.text.trim(),
            "otp": forgotOtpController.text,
            "pin": forgetpinController.text
          }),
          headers: {"Content-Type": "application/json"}).timeout(
        const Duration(seconds: 30),
        onTimeout: (() {
          throw TimeoutException('Connection timeout, Please try again!');
        }),
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          _Otpforgotverifystatus(OtpForgotVerifyStatus.Success);
          Get.snackbar(
            "PIN successfully changed.",
            "Proceed to Login.",
          );
          Timer(const Duration(milliseconds: 2000), () {
            Get.offAll(const Signin());
          });
        } else {
          _Otpforgotverifystatus(OtpForgotVerifyStatus.Error);
          Get.snackbar("Error", "Unable to change PIN");
        }
      }
    } catch (ex) {
      Get.snackbar("Error", "Unable to change PIN");
      _Otpforgotverifystatus(OtpForgotVerifyStatus.Error);
    }
  }

  Future updateProfileImage() async {
    try {
      _updateProfileStatus(UpdateProfileStatus.Loading);
      final uploadController = Get.find<FileUploadRespository>();
      String? imageId;
      if (profileImage.value != null) {
        imageId = await uploadController.uploadFile(profileImage.value!.path);
      }
      final resposne = await http.put(Uri.parse(ApiLink.updateProfile),
          body: jsonEncode({
            // "profileImageFileStoreId": imageId,
            "profileImageUrl": imageId
            // "phoneNumber": countryText + updatePhoneNumberController.text.trim()
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });

      if (resposne.statusCode == 200) {
        var json = jsonDecode(resposne.body);
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
        var json = jsonDecode(resposne.body);
        Get.snackbar("${json['error']}", "${json['message']}");
      }
    } catch (ex) {
      _updateProfileStatus(UpdateProfileStatus.Error);
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
      final uploadController = Get.find<FileUploadRespository>();
      String? imageId;
      if (profileImage.value != null) {
        imageId = await uploadController.uploadFile(profileImage.value!.path);
      }
      final resposne = await http.put(Uri.parse(ApiLink.updateProfile),
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

      if (resposne.statusCode == 200) {
        var json = jsonDecode(resposne.body);
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
        var json = jsonDecode(resposne.body);
        Get.snackbar("${json['error']}", "${json['message']}");
      }
    } catch (ex) {
      _updateProfileStatus(UpdateProfileStatus.Error);
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

      final response = await http.get(Uri.parse(ApiLink.getUser), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var user = User.fromJsonSettngs(json);
        user.businessList = this.user!.businessList;
        this.user = user;
        pref!.setUser(user);
        Get.offAll(() => Dashboard());

        _updateProfileStatus(UpdateProfileStatus.Success);
      }
    } catch (ex) {
      _updateProfileStatus(UpdateProfileStatus.Error);
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
      if (response.statusCode == 201) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          _signupStatus(SignupStatus.Success);

          var token = json['data']['accessToken'];
          var user = User.fromJson(json['data']);
          Mtoken(token);
          pref!.saveToken(token);
          this.user = user;
          pref!.setUser(user);
          DateTime date = DateTime.now();
          DateTime expireToken = DateTime(date.year, date.month + 1, date.day);
          pref!.setDateTokenExpired(expireToken);
          _authStatus(AuthStatus.Authenticated);
          Get.off(PinSuccesful());
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
      Get.snackbar("SignUp Error", "Something have occurred try again later");
      _signupStatus(SignupStatus.Error);
    }
  }

  Future signIn() async {
    try {
      _signinStatus(SigninStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.signinUser),
          body: jsonEncode({
            "phoneNumber": countryText + phoneNumberController.text.trim(),
            "pin": pinController.text,
            // "pin":"3152"
          }),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        _signinStatus(SigninStatus.Success);

        var token = json['accessToken'];
        var user = User.fromJson(json);
        Mtoken(token);
        pref!.saveToken(token);
        pref!.setUser(user);
        //  Mtoken=Rx(token);

        this.user = user;

        DateTime date = DateTime.now();

        DateTime expireToken = DateTime(date.year, date.month + 1, date.day);

        pref!.setDateTokenExpired(expireToken);

        _authStatus(AuthStatus.Authenticated);
        final _businessController = Get.find<BusinessRespository>();
        _businessController.setBusinessList(user.businessList!);
        Mtoken(token);
        if (user.businessList!.isEmpty || user.businessList == null) {
          Get.off(() => const CreateBusiness());
        } else {
          Get.offAll(() => Dashboard());
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Login Error", "Invalid Credential ");
        _signinStatus(SigninStatus.Error);
      } else {
        Get.snackbar(
            "Login Error", "Something have occurred try again later.. ");
        _signinStatus(SigninStatus.Error);
      }
    } catch (ex) {
      _signinStatus(SigninStatus.Error);
    }
  }

  Future getUserData() async {
    try {
      // _signinStatus(SigninStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.signinUser),
          body: jsonEncode({
            "phoneNumber": countryText + phoneNumberController.text.trim(),
            "pin": pinController.text,
            // "pin":"3152"
          }),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        // _signinStatus(SigninStatus.Success);

        var token = json['accessToken'];
        var user = User.fromJson(json);
        Mtoken(token);
        pref!.saveToken(token);
        pref!.setUser(user);
        //  Mtoken=Rx(token);

        this.user = user;
      }
    } catch (ex) {
      _signinStatus(SigninStatus.Error);
    }
  }

  Future fingerPrintSignIn() async {
    _signinStatus(SigninStatus.Loading);
    try {
      final isAuthenticated = await LocalAuthApi.authenticate();

      if (isAuthenticated) {
        _signinStatus(SigninStatus.Success);

        pref!.saveToken(token);
        pref!.setUser(user!);
        Mtoken(token);
        this.user = user;
        DateTime date = DateTime.now();
        DateTime expireToken = DateTime(date.year, date.month + 30, date.day);
        pref!.setDateTokenExpired(expireToken);
        _authStatus(AuthStatus.Authenticated);
        Get.off(() => Dashboard());
      } else if (!isAuthenticated) {
        Get.snackbar("Login Error", "Invalid Crediential ");
        _signinStatus(SigninStatus.Error);
      } else {
        Get.snackbar(
            "Login Error", "Something have occurred try again later.. ");
        _signinStatus(SigninStatus.Error);
      }
    } catch (ex) {
      _signinStatus(SigninStatus.Error);
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
      throw e;
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
      if (response.statusCode != null) {
        // ignore: unnecessary_null_comparison
        if (response != null) {
          _authStatus(AuthStatus.Empty);
          Get.snackbar("Success", "Your account have been deleted");
          logout();
          accountDeletelogout();
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
      final _businessController = Get.find<BusinessRespository>();
      final prefs = await SharedPreferences.getInstance();
      final key = 'token';
      final value = prefs.get(key) ?? 0;
      String? id = _businessController.selectedBusiness.value!.businessId;

      String myUrl = ApiLink.deleteBusiness + '$id';
      var response = await http.delete(Uri.parse(myUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $value'
      });

      // ignore: unnecessary_null_comparison
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

  void accountDeletelogout() {
    _authStatus(AuthStatus.UnAuthenticated);
    pref!.saveToken("0");
    clearDatabase();
    pref!.logout();
    Get.offAll(() => RegHome());
  }

  void checkDeletedTeamBusiness() async {
    try {
      final _businessController = Get.find<BusinessRespository>();
      // _businessController.checkOnlineBusiness();
      if (kDebugMode) {
        print(
            'Online business: ${_businessController.onlineBusinessLength.value}');
        print(
            'Offline business: ${_businessController.offlineBusinessLength.value}');
      }
      if (_businessController.onlineBusinessLength.value !=
          _businessController.offlineBusinessLength.value) {
        // logout();
      }
    } catch (error) {
      if (kDebugMode) {
        print('check deleted business: $error');
      }
    }
  }

  void logout() {
    _authStatus(AuthStatus.UnAuthenticated);
    pref!.saveToken("0");
    clearDatabase();
    Mtoken("0");
    pref!.logout();
    phoneNumberController.text = '';
    Get.offAll(const Signin());
    final businessController = Get.find<BusinessRespository>();
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
    final _businessController = Get.find<BusinessRespository>();

    await sqliteDb.openDatabae();
    await sqliteDb.deleteAllProducts();

    _productController.getOfflineProduct(
        _businessController.selectedBusiness.value!.businessId!);
    _productController.getOnlineProduct(
        _businessController.selectedBusiness.value!.businessId!);
  }

  void checkIfTokenStillValid() async {
    var response = await http.get(Uri.parse(ApiLink.getUserBusiness),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 401) {
      _authStatus(AuthStatus.TOKEN_EXISTED);
      Get.snackbar("Error", "Your Login token is expired.");
      Get.offAll(const Signin());
    }
  }
}
