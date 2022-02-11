// ignore_for_file: non_constant_identifier_names, unused_field, must_call_super, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/file_upload_respository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/create_business.dart';
import 'package:huzz/app/screens/dashboard.dart';
import 'package:huzz/app/screens/forget_pass/enter_forget_pin.dart';
import 'package:huzz/app/screens/pin_successful.dart';
import 'package:huzz/app/screens/sign_in.dart';
import 'package:huzz/app/screens/sign_up.dart';
import 'package:huzz/model/business.dart';
import 'package:huzz/model/user.dart';
import 'package:huzz/sharepreference/sharepref.dart';
import 'package:huzz/sqlite/sqlite_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fingerprint_repository.dart';
import 'home_respository.dart';

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
  USERNAME_EXISTED
}
enum OnlineStatus { Onilne, Offline, Empty }

class AuthRepository extends GetxController {
  final _homeController = Get.find<HomeRespository>();

  late final otpController = TextEditingController();
  var pinController = TextEditingController();
  late final emailController = TextEditingController();
  late final lastNameController = TextEditingController();
  late final firstNameController = TextEditingController();
  late final forgotOtpController = TextEditingController();
  late final forgetpinController = TextEditingController();
  late final verifypinController = TextEditingController();
  late final confirmPinController = TextEditingController();
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

  final Mtoken = "".obs;
  String get token => Mtoken.value;

  SqliteDb sqliteDb = SqliteDb();
  bool tokenExpired = false;
  Rx<File?> profileImage = Rx(null);
  @override
  void onInit() async {
    pref = SharePref();
    await pref!.init();
    if (pref!.getFirstTimeOpen()) {
      print("My First Time Using this app");
      _authStatus(AuthStatus.IsFirstTime);
    } else {
      print("Not my First Time Using this app");
      print(
          "expired date token ${pref!.getDateTokenExpired()} token expired $tokenExpired");

      if (pref!.getUser() != null &&
          !DateTime.now().isAfter(pref!.getDateTokenExpired()) &&
          !tokenExpired) {
        print("gotten here is value");
        user = pref!.getUser()!;

        Mtoken(pref!.read());
        print("result of token is ${Mtoken.value}");

        _authStatus(AuthStatus.Authenticated);
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
      print("result is $result");
    });
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
    print("phone number ${countryText}${phoneNumberController.text}");
    try {
      _Otpauthstatus(OtpAuthStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.send_smsOtp),
          body: jsonEncode(
              {"phoneNumber": countryText + phoneNumberController.text}),
          headers: {"Content-Type": "application/json"});
      print("response is ${response.body}");
      if (response.statusCode == 200) {
        _Otpauthstatus(OtpAuthStatus.Success);
        if (!isresend) _homeController.selectOnboardSelectedNext();
      } else {
        _Otpauthstatus(OtpAuthStatus.Error);
      }
    } catch (ex) {
      print("errror otp send ${ex.toString()}");
      _Otpauthstatus(OtpAuthStatus.Error);
    }
  }

  Future sendForgetOtp() async {
    print("phone number ${countryText}${phoneNumberController.text}");
    try {
      _Otpauthstatus(OtpAuthStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.send_smsOtp),
          body: jsonEncode({
            "phoneNumber": countryText + forgotPhoneNumberController.text.trim()
          }),
          headers: {"Content-Type": "application/json"});
      print("response is ${response.body}");
      if (response.statusCode == 200) {
        _Otpauthstatus(OtpAuthStatus.Success);

        Timer(Duration(milliseconds: 2000), () {
          Get.to(EnterForgotPIN());
        });
      } else {
        _Otpauthstatus(OtpAuthStatus.Error);
      }
    } catch (ex) {
      print("errror otp send ${ex.toString()}");
      _Otpauthstatus(OtpAuthStatus.Error);
    }
  }

  Future sendVoiceOtp() async {
    // _Otpauthstatus(OtpAuthStatus.Loading);
    final response = await http.post(Uri.parse(ApiLink.send_voiceOtp),
        body: jsonEncode(
            {"phoneNumber": countryText + phoneNumberController.text.trim()}),
        headers: {"Content-Type": "application/json"});
    print("otp sent voice ${response.body}");
    if (response.statusCode == 200) {
    } else {
      Get.snackbar("Error", "Unable to send Otp");
    }
  }

  Future verifyOpt() async {
    print("otp value ${otpController.text}");
    try {
      _Otpverifystatus(OtpVerifyStatus.Loading);
      final resposne = await http.post(Uri.parse(ApiLink.verify_otp),
          body: jsonEncode({
            "phoneNumber": countryText + phoneNumberController.text.trim(),
            "otp": otpController.text
          }),
          headers: {"Content-Type": "application/json"});

      print("response of verify otp ${resposne.body}");
      if (resposne.statusCode == 200) {
        var json = jsonDecode(resposne.body);
        if (json['success']) {
          _homeController.selectOnboardSelectedNext();

          _Otpverifystatus(OtpVerifyStatus.Success);
          Get.snackbar("Success", "Otp verified successfully");
        } else {
          _Otpverifystatus(OtpVerifyStatus.Error);
          Get.snackbar("Error", "Unable to verify Otp");
        }
      }
    } catch (ex) {
      print("error from verify otp ${ex.toString()}");
      Get.snackbar("Error", "Error verifying Otp");
      _Otpverifystatus(OtpVerifyStatus.Error);
    }
  }

  Future verifyForgotOpt() async {
    try {
      _Otpforgotverifystatus(OtpForgotVerifyStatus.Loading);
      print("otp value ${otpController.text}");
      final resposne = await http.put(Uri.parse(ApiLink.forget_pin),
          body: jsonEncode({
            "phoneNumber":
                countryText + forgotPhoneNumberController.text.trim(),
            "otp": forgotOtpController.text,
            "pin": forgetpinController.text
          }),
          headers: {"Content-Type": "application/json"});

      print("response of verify forgot pass otp ${resposne.body}");
      if (resposne.statusCode == 200) {
        var json = jsonDecode(resposne.body);
        if (json['success']) {
          _Otpforgotverifystatus(OtpForgotVerifyStatus.Success);
          Get.snackbar(
            "PIN successfully changed.",
            "Proceed to Login.",
          );
          Timer(Duration(milliseconds: 2000), () {
            Get.offAll(Signin());
          });
        } else {
          _Otpforgotverifystatus(OtpForgotVerifyStatus.Error);
          Get.snackbar("Error", "Unable to change PIN");
        }
      }
    } catch (ex) {
      print("error from PIN changing ${ex.toString()}");
      Get.snackbar("Error", "Unable to change PIN");
      _Otpforgotverifystatus(OtpForgotVerifyStatus.Error);
    }
  }

  Future updateProfileImage() async {
    try {
      _updateProfileStatus(UpdateProfileStatus.Loading);
      print("otp value ${otpController.text}");
      final uploadController = Get.find<FileUploadRespository>();
      String? imageId;
      if (profileImage.value != null) {
        imageId = await uploadController.uploadFile(profileImage.value!.path);
      }
      print("image url is $imageId");
      final resposne = await http.put(Uri.parse(ApiLink.update_profile),
          body: jsonEncode({
            // "profileImageFileStoreId": imageId,
            "profileImageUrl":imageId
            // "phoneNumber": countryText + updatePhoneNumberController.text.trim()
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}"
          });

      print("response of update personal profile info ${resposne.body}");
      if (resposne.statusCode == 200) {
        var json = jsonDecode(resposne.body);
        print("user detail ${json}");
        var user = User.fromJsonSettngs(json);
        user.businessList = this.user!.businessList;
        this.user = user;
        pref!.setUser(user);

        _updateProfileStatus(UpdateProfileStatus.Success);
        Get.snackbar(
          "Success",
          "Personal Profile Image",
        );
        Timer(Duration(milliseconds: 2000), () {
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
      print("error from updating personal information ${ex.toString()}");
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
      print("otp value ${otpController.text}");
      final uploadController = Get.find<FileUploadRespository>();
      String? imageId;
      if (profileImage.value != null) {
        imageId = await uploadController.uploadFile(profileImage.value!.path);
      }
      final resposne = await http.put(Uri.parse(ApiLink.update_profile),
          body: jsonEncode({
            "firstName": firstNameController.text,
            "lastName": lastNameController.text,
            "email": emailController.text,
            // "profileImageFileStoreId": imageId,
            // "phoneNumber": countryText + updatePhoneNumberController.text.trim()
          }),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}"
          });

      print("response of update personal info ${resposne.body}");
      if (resposne.statusCode == 200) {
        var json = jsonDecode(resposne.body);
        print("user detail ${json}");
        var user = User.fromJsonSettngs(json);
        user.businessList = this.user!.businessList;
        this.user = user;
        pref!.setUser(user);

        _updateProfileStatus(UpdateProfileStatus.Success);
        Get.snackbar(
          "Success",
          "Personal Information Updated",
        );
        Timer(Duration(milliseconds: 2000), () {
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
      print("error from updating personal information ${ex.toString()}");
      Get.snackbar(
        "Error",
        "Failed to update Personal Information",
      );
      _updateProfileStatus(UpdateProfileStatus.Error);
    }
  }

  Future signUp() async {
    try {
      _signupStatus(SignupStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.signup_user),
          body: jsonEncode({
            "firstName": firstNameController.text.trim(),
            "lastName": lastNameController.text.trim(),
            "email": emailController.text.trim(),
            "pin": pinController.text,
            "phoneNumber": countryText + phoneNumberController.text.trim()
          }),
          headers: {"Content-Type": "application/json"});
      print("sign up response ${response.body} ${response.statusCode}");
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
      print("error occurred ${ex.toString()}");
      Get.snackbar("SignUp Error", "Something have occurred try again later");
      _signupStatus(SignupStatus.Error);
    }
  }

  Future signIn() async {
    print(
        "phone number ${phoneNumberController.text}  country code ${countryText}");
    try {
      _signinStatus(SigninStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.signin_user),
          body: jsonEncode({
            "phoneNumber": countryText + phoneNumberController.text,
            "pin": pinController.text
          }),
          headers: {"Content-Type": "application/json"});
      print("sign in response ${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        _signinStatus(SigninStatus.Success);

        var token = json['accessToken'];
        var user = User.fromJson(json);
        pref!.saveToken(token);
        pref!.setUser(user);
        Mtoken(token);
        this.user = user;
        DateTime date = DateTime.now();
        DateTime expireToken = DateTime(date.year, date.month + 1, date.day);
        pref!.setDateTokenExpired(expireToken);
        _authStatus(AuthStatus.Authenticated);
        final _businessController = Get.find<BusinessRespository>();
        _businessController.setBusinessList(user.businessList!);
        print("user business lenght ${user.businessList!.length}");
        if (user.businessList!.isEmpty) {
          Get.off(() => CreateBusiness());
        } else {
          Get.offAll(() => Dashboard());
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Login Error", "Invalid Crediential ");
        _signinStatus(SigninStatus.Error);
      } else {
        Get.snackbar(
            "Login Error", "Something have occurred try again later.. ");
        _signinStatus(SigninStatus.Error);
      }
    } catch (ex) {
      _signinStatus(SigninStatus.Error);
      print("Sign in Error ${ex.toString()}");
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

  void deleteUsersAccounts() async {
    _authStatus(AuthStatus.Loading);
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'token';
      final value = prefs.get(key) ?? 0;

      String myUrl = ApiLink.delete_user;
      var response = await http.delete(Uri.parse(myUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $value'
      });

      // ignore: unnecessary_null_comparison
      if (response.statusCode != null) {
        // ignore: unnecessary_null_comparison
        if (response != null) {
          _authStatus(AuthStatus.Authenticated);

          Get.offAll(() => Signup());
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
      final prefs = await SharedPreferences.getInstance();
      final key = 'token';
      final value = prefs.get(key) ?? 0;
      String? id;

      String myUrl = ApiLink.delete_business + '$id';
      var response = await http.delete(Uri.parse(myUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $value'
      });

      // ignore: unnecessary_null_comparison
      if (response.statusCode != null) {
        // ignore: unnecessary_null_comparison
        if (response != null) {
          _authStatus(AuthStatus.Authenticated);

          Get.offAll(() => Signup());
        }
      } else {
        _authStatus(AuthStatus.Empty);
      }
    } catch (error) {
      _authStatus(AuthStatus.Error);
    }
  }

  void logout() {
    _authStatus(AuthStatus.UnAuthenticated);
    pref!.saveToken("0");
    clearDatabase();
    pref!.logout();
    Get.offAll(Signin());
  }

  void clearDatabase() async {
    await sqliteDb.openDatabae();
    await sqliteDb.deleteAllOfflineBusiness();
    await sqliteDb.deleteAllOfflineTransaction();
    await sqliteDb.deleteAllProducts();
    await sqliteDb.deleteAllCustomers();
    await sqliteDb.deleteAllOfflineDebtors();
    await sqliteDb.deleteAllInvoice();
    await sqliteDb.deleteAllBanks();
  }
}
