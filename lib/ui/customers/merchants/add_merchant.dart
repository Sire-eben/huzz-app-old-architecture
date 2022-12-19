import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class AddMerchant extends StatefulWidget {
  Customer? item;
  AddMerchant({Key? key, this.item}) : super(key: key);

  @override
  _AddMerchantState createState() => _AddMerchantState();
}

class _AddMerchantState extends State<AddMerchant> {
  GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController contactName = TextEditingController();
  final TextEditingController contactPhone = TextEditingController();
  final TextEditingController contactMail = TextEditingController();
  final _customerController = Get.find<CustomerRepository>();
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
            color: AppColors.backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Add Merchant',
          style: GoogleFonts.inter(
            color: AppColors.backgroundColor,
           
            fontStyle: FontStyle.normal,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                      if (_formKey.currentState!.validate() &&
                          _customerController.addingCustomerStatus !=
                              AddingCustomerStatus.Loading) {
                        if (_customerController.phoneNumberController.text ==
                            '') {
                          Get.snackbar(
                              'Alert', 'Select phone number from your contact');
                        } else {
                          if (widget.item == null)
                            _customerController.addBusinnessCustomer(
                                "EXPENDITURE", 'Merchant');
                          else
                            _customerController
                                .updateBusinesscustomer(widget.item!);
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: (_customerController.addingCustomerStatus ==
                              AddingCustomerStatus.Loading)
                          ? Container(
                              width: 30,
                              height: 30,
                              child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white)),
                            )
                          : Center(
                              child: Text(
                                (widget.item == null) ? 'Save' : "Update",
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 18,
                                   ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
