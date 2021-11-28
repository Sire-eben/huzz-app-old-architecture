import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/home_respository.dart';
import 'package:huzz/colors.dart';
import 'widget/custom_form_field.dart';

class Signup extends StatefulWidget {
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends  State<Signup>{
final _homeController=Get.find<HomeRespository>();
// final controller=TextEditingController();
final _authController=Get.find<AuthRepository>();
final _formKey=GlobalKey<FormState>();


class _SignUpState extends State<Signup> {
  final _homeController = Get.find<HomeRespository>();

  @override
  Widget build(BuildContext context) {
    
    // TODO: implement build

    
    return Form(
      key: _formKey,
      child: Container(
       width: MediaQuery.of(context).size.width,
       height: MediaQuery.of(context).size.height,
       child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
       children: [
    CustomTextField(label: "First Name",validatorText: "First name is needed",textEditingController:_authController.firstNameController),
    SizedBox(height: 5,),
    CustomTextField(label: "Last Name",validatorText: "Last name is needed",textEditingController: _authController.lastNameController,),
    SizedBox(height: 5,),
    CustomTextField(label: "Email",validatorText: "Email is needed",textEditingController: _authController.emailController,),
    SizedBox(height: 5,),
    CustomTextField(label: "Phone Number",enabled: false,initialValue: "${_authController.countryText}${_authController.phoneNumberController.text}",),
    SizedBox(height: 5,),
    
    Expanded(child: SizedBox()),
    
    SizedBox(height: 20,),
    GestureDetector(
      onTap: (){
    if(_formKey.currentState!.validate())
    
      _homeController.selectOnboardSelectedNext();
      },
      child:   Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 50,right: 50),
        height: 50,
        decoration: BoxDecoration(
           color: AppColor().backgroundColor,
           borderRadius: BorderRadius.all(Radius.circular(10))
      
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Text('Continue',style: TextStyle(color: Colors.white,fontSize: 18),),
             SizedBox(width: 10,),
             Container(padding: EdgeInsets.all(3),
               decoration:BoxDecoration(
                 color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))
      
               ),
               child: Icon(Icons.arrow_forward,color: AppColor().backgroundColor,size: 16,),
             )
      
      
          ],
        ),
      ),
    ),
      SizedBox(height: MediaQuery.of(context).size.height*0.1,)
    
    
       ],
       ),
    
      ),


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: "First Name",
              validatorText: "First name is needed",
            ),
            SizedBox(
              height: 3,
            ),
            CustomTextField(
              label: "Last Name",
              validatorText: "Last name is needed",
            ),
            SizedBox(
              height: 3,
            ),
            CustomTextField(
              label: "Email",
              validatorText: "Email is needed",
            ),
            SizedBox(
              height: 3,
            ),
            CustomTextField(
              label: "Phone Number",
              validatorText: "Phone Number is needed",
            ),
            SizedBox(
              height: 3,
            ),
            Expanded(child: SizedBox()),
            SizedBox(
              height: 10,
            ),
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
              height: MediaQuery.of(context).size.height * 0.08,
            ),
          ],
        ),
      ),
    );
  }
}
