import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/dashboard.dart';
import 'package:huzz/app/screens/pin_successful.dart';
import 'package:huzz/app/screens/sign_in.dart';
import 'package:huzz/model/user.dart';
import 'package:huzz/sharepreference/sharepref.dart';

import 'fingerprint_repository.dart';
import 'home_respository.dart';

enum OtpAuthStatus { Empty, Loading, Error, Success }
enum OtpVerifyStatus { Empty, Loading, Error, Success }
enum SignupStatus { Empty, Loading, Error, Success }
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

class AuthRepository extends GetxController {
  final _Otpauthstatus = OtpAuthStatus.Empty.obs;
  OtpAuthStatus get Otpauthstatus => _Otpauthstatus.value;
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final pinController = TextEditingController();
  final confirmPinController = TextEditingController();
  final _Otpverifystatus = OtpVerifyStatus.Empty.obs;
  final _signupStatus = SignupStatus.Empty.obs;
  final _authStatus = AuthStatus.Empty.obs;
  final _signinStatus = SigninStatus.Empty.obs;
  SigninStatus get signinStatus => _signinStatus.value;

  AuthStatus get authStatus => _authStatus.value;
  SignupStatus get signupStatus => _signupStatus.value;
  OtpVerifyStatus get Otpverifystatus => _Otpverifystatus.value;
  String countryText = "234";
  String countryCodeFLag = "NG";
  final _homeController = Get.find<HomeRespository>();

  SharePref? pref;
  final Mtoken = "".obs;
  String get token => Mtoken.value;

  User? user;
  @override
  void onInit() async {
    pref = SharePref();
    await pref!.init();
    if (pref!.getFirstTimeOpen()) {
      print("My First Time Using this app");
      _authStatus(AuthStatus.IsFirstTime);
    } else {
      print("Not my First Time Using this app");
      if (pref!.getUser() != null) {
        user = pref!.getUser()!;
        Mtoken(pref!.read());
        // print("token is ${token.value}");

        _authStatus(AuthStatus.Authenticated);
        if (Mtoken.value == "0") {
          _authStatus(AuthStatus.UnAuthenticated);
        }
      } else {
        _authStatus(AuthStatus.UnAuthenticated);
      }
    }
  }

  Future sendSmsOtp() async {
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
        _homeController.selectOnboardSelectedNext();
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
            {"phoneNumber": countryText + phoneNumberController.text}),
        headers: {"Content-Type": "application/json"});
    print("otp sent voice ${response.body}");
    if (response.statusCode == 200) {
    } else {
      Get.snackbar("Error", "Unable to send Otp");
    }
  }

  Future verifyOpt() async {
    try {
      _Otpverifystatus(OtpVerifyStatus.Loading);
      print("otp value ${otpController.text}");
      final resposne = await http.post(Uri.parse(ApiLink.verify_otp),
          body: jsonEncode({
            "phoneNumber": countryText + phoneNumberController.text,
            "otp": otpController.text
          }),
          headers: {"Content-Type": "application/json"});

      print("response of verify otp ${resposne.body}");
      if (resposne.statusCode == 200) {
        var json = jsonDecode(resposne.body);
        if (json['success']) {
          _homeController.selectOnboardSelectedNext();

          _Otpverifystatus(OtpVerifyStatus.Success);
          Get.snackbar("Success", "Otp is sent successfully");
        } else {
          _Otpverifystatus(OtpVerifyStatus.Error);
          Get.snackbar("Error", "Unable to send Otp");
        }
      }
    } catch (ex) {
      print("error from verify otp ${ex.toString()}");
      Get.snackbar("Error", "Error sending Otp");
      _Otpverifystatus(OtpVerifyStatus.Error);
    }
  }

  Future signUp() async {
// emailController.text="pelumi40@gmail.com";
// phoneNumberController.text="8147179396";
    try {
      _signupStatus(SignupStatus.Loading);
      final response = await http.post(Uri.parse(ApiLink.signup_user),
          body: jsonEncode({
            "firstName": firstNameController.text,
            "lastName": lastNameController.text,
            "email": emailController.text,
            "pin": pinController.text,
            "phoneNumber": countryText + phoneNumberController.text
          }),
          headers: {"Content-Type": "application/json"});
      print("sign up response ${response.body} ${response.statusCode}");
      if (response.statusCode == 201) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          _signupStatus(SignupStatus.Success);

          var token = json['data']['accessToken'];
          var user = User.fromJson(json['data']['user']);
          Mtoken(token);
          pref!.saveToken(token);
          this.user = user;
          pref!.setUser(user);
          DateTime date = DateTime.now();
          DateTime expireToken = DateTime(date.year, date.month + 30, date.day);
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
        var user = User.fromJson(json['user']);
        pref!.saveToken(token);
        pref!.setUser(user);
        Mtoken(token);
        this.user = user;
        DateTime date = DateTime.now();
        DateTime expireToken = DateTime(date.year, date.month + 30, date.day);
        pref!.setDateTokenExpired(expireToken);
        _authStatus(AuthStatus.Authenticated);
        Get.off(() => Dashboard());
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

  void logout() {
    _authStatus(AuthStatus.UnAuthenticated);
    pref!.logout();
    Get.off(Signin());
  }
}
