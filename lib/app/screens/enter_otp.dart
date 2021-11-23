import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/home_respository.dart';
import 'package:huzz/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterOtp extends StatefulWidget {
  _EnterOtpState createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  final _homeController = Get.find<HomeRespository>();
  StreamController<ErrorAnimationType>? errorController;
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Container(
            margin: EdgeInsets.only(
              left: 20,
            ),
            child: Text(
              "Enter OTP sent to your phone",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: PinCodeTextField(
              length: 4,
              obscureText: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                inactiveColor: AppColor().backgroundColor,
                activeColor: AppColor().backgroundColor,
                selectedColor: AppColor().backgroundColor,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: Colors.white,
              ),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.white,
              enableActiveFill: true,
              errorAnimationController: errorController,
              // controller: textEditingController,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                print(value);
                // setState(() {
                //   currentText = value;
                // });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
              appContext: context,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Send as Voice Call",
            style: TextStyle(color: AppColor().backgroundColor, fontSize: 12),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Resend via sms",
            style: TextStyle(color: Color(0xffEF6500), fontSize: 12),
          ),
          Expanded(child: SizedBox()),
          InkWell(
            onTap: () {
              _homeController.selectOnboardSelectedNext();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 50, right: 50),
              height: 50,
              decoration: BoxDecoration(
                  color: AppColor().backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppColor().backgroundColor,
                      size: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ]),
      ),
    );
  }
}
