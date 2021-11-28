import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/app/screens/create_business.dart';
import 'package:huzz/app/screens/pin_successful.dart';
import 'package:huzz/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CreatePin extends StatefulWidget {
  _CreatePinState createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin>{
  final _authController=Get.find<AuthRepository>();

class _CreatePinState extends State<CreatePin> {
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
    return Container(

width: MediaQuery.of(context).size.width,
height: MediaQuery.of(context).size.height,
child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
children:[

SizedBox(height: MediaQuery.of(context).size.height*0.1),
Container(

  margin: EdgeInsets.only(left: 20,),
child: Text("Create a 4 digit pin",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400,),)

),
SizedBox(height: 10,),
Center(
  child:   Container(
 width: MediaQuery.of(context).size.width*0.5,
  margin: EdgeInsets.only(top:5),
  child: PinCodeTextField(
    length: 4,
    obscureText: true,
    animationType: AnimationType.fade,
    controller: _authController.pinController,
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
    }, appContext: context,
  ),
  ),
),

SizedBox(height: 20,),
Container(

  margin: EdgeInsets.only(left: 20,),
child: Text("Confirm a 4 digit pin",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400,),)

),


Container(
  width: MediaQuery.of(context).size.width*0.5,
  margin: EdgeInsets.only(top:5),
  child:   PinCodeTextField(
      length: 4,
      obscureText: true,
      animationType: AnimationType.fade,
      controller: _authController.confirmPinController,
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
      // errorAnimationController: errorController,
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
      }, appContext: context,
    ),
),
Expanded(child: SizedBox()),
Obx(
 (){
    return     GestureDetector(
      onTap: (){
        if(_authController.confirmPinController.text==_authController.pinController.text){
        //  if(_authController.signupStatus!=SignupStatus.Loading) 
    _authController.signUp();
        }else{
      errorController!.add(ErrorAnimationType
                                .shake);
        }
    
        // Get.to(PinSuccesful());
      },
      child:   Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 50,right: 50),
          height: 50,
          decoration: BoxDecoration(
             color: AppColor().backgroundColor,
             borderRadius: BorderRadius.all(Radius.circular(10))
      
          ),
          child:  (_authController.signupStatus==SignupStatus.Loading)?Container(
                width: 30,
                height: 30,
                child:Center(child: CircularProgressIndicator(color: Colors.white)),
              ):Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Text('Create User',style: TextStyle(color: Colors.white,fontSize: 18),),
               SizedBox(width: 10,),
              //  Container(padding: EdgeInsets.all(3),
              //    decoration:BoxDecoration(
              //      color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))
      
              //    ),
              //    child: Icon(Icons.arrow_forward,color: AppColor().backgroundColor,size: 16,),
              //  )
      
      
            ],
          ),
        ),
    );
  }
),
  SizedBox(height: MediaQuery.of(context).size.height*0.1,)

]

),

      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Container(
          margin: EdgeInsets.only(
            left: 20,
          ),
          child: Text(
            "Create a 4 digit pin",
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
          margin: EdgeInsets.only(top: 5),
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
        Container(
          margin: EdgeInsets.only(
            left: 20,
          ),
          child: Text(
            "Confirm a 4 digit pin",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          margin: EdgeInsets.only(top: 5),
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
            // errorAnimationController: errorController,
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
        Expanded(child: SizedBox()),
        InkWell(
          onTap: () {
            Get.to(PinSuccesful());
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
                  'Create User',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                //  Container(padding: EdgeInsets.all(3),
                //    decoration:BoxDecoration(
                //      color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))

                //    ),
                //    child: Icon(Icons.arrow_forward,color: AppColor().backgroundColor,size: 16,),
                //  )
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        )
      ]),

    );
  }
}
