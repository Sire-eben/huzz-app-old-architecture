import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:image_picker/image_picker.dart';

class AddMerchant extends StatefulWidget {
  
Customer? item;
 AddMerchant({Key? key,this.item}) : super(key: key);

  @override
  _AddMerchantState createState() => _AddMerchantState();
}

class _AddMerchantState extends State<AddMerchant> {
  final TextEditingController contactName = TextEditingController();
  final TextEditingController contactPhone = TextEditingController();
  final TextEditingController contactMail = TextEditingController();
  final _customerController=Get.find<CustomerRepository>();
  File? image;
  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      print(imageTemporary);
      setState(
        () {
          this.image = imageTemporary;
        },
      );
    } on PlatformException catch (e) {
      print('$e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      print(imageTemporary);
      setState(
        () {
          this.image = imageTemporary;
        },
      );
    } on PlatformException catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor().backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Add Merchant',
          style: TextStyle(
            color: AppColor().backgroundColor,
            fontFamily: "DMSans",
            fontStyle: FontStyle.normal,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body:  Obx(()
        {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.02),
                    child: image != null
                        ? Center(
                            child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: Colors.grey),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(image!), fit: BoxFit.cover),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    image = null;
                                  });
                                },
                                icon: Icon(Icons.no_photography,
                                    color: AppColor().backgroundColor),
                              ),
                            ],
                          ))
                        : Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Image.asset('assets/images/add_photo.png'),
                              InkWell(
                                onTap: () {
                                  Get.bottomSheet(Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0)),
                                    ),
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      crossAxisAlignment: WrapCrossAlignment.end,
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            Icons.camera,
                                            color: AppColor().backgroundColor,
                                          ),
                                          title: Text('Camera'),
                                          onTap: () {
                                            Get.back();
                                            pickImageFromCamera();
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.image,
                                            color: AppColor().backgroundColor,
                                          ),
                                          title: Text('Gallery'),
                                          onTap: () {
                                            Get.back();
                                            pickImageFromGallery();
                                          },
                                        ),
                                      ],
                                    ),
                                  ));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: AppColor().backgroundColor),
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: SvgPicture.asset(
                                    'assets/images/add_a_photo.svg',
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    'Profile Image',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "DMSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CustomTextFieldWithImage(
                    contactName: _customerController.nameController,
                    contactPhone: _customerController.phoneNumberController,
                    contactMail: _customerController.emailController,
                    label: "Merchant name",
                    validatorText: "Merchant name is needed",
                    hint: 'merchant name',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  InkWell(
                    onTap: () {
                      // Get.to(() => IncomeSuccess());
        if (_customerController.addingCustomerStatus !=
                          AddingCustomerStatus.Loading) {
                        if (widget.item == null)
                          _customerController.addBusinnessCustomer("EXPENDITURE");
                        else
                          _customerController.updateBusinesscustomer(widget.item!);
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height * 0.03),
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child:(_customerController.addingCustomerStatus ==
                              AddingCustomerStatus.Loading)
                          ? Container(
                              width: 30,
                              height: 30,
                              child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white)),
                            )
                          :  Center(
                        child: Text(
                      (widget.item==null)?    'Save':"Update",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'DMSans'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
