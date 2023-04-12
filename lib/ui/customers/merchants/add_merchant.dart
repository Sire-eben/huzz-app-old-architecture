import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/widgets/button/button.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey();
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
      setState(
        () {
          this.image = imageTemporary;
        },
      );
    } on PlatformException catch (e) {
      Get.snackbar("Error", e.message.toString());
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(
        () {
          this.image = imageTemporary;
        },
      );
    } on PlatformException catch (e) {
      Get.snackbar("Error", e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        return SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
                  child: Button(
                    action: () {
                      if (_formKey.currentState!.validate() &&
                          _customerController.addingCustomerStatus !=
                              AddingCustomerStatus.Loading) {
                        if (_customerController.phoneNumberController.text ==
                            '') {
                          Get.snackbar(
                              'Alert', 'Select phone number from your contact');
                        } else {
                          if (widget.item == null) {
                            _customerController.addBusinnessCustomer(
                                "EXPENDITURE", 'Merchant');
                          } else {
                            _customerController
                                .updateBusinesscustomer(widget.item!);
                          }
                        }
                      }
                    },
                    showLoading: (_customerController.addingCustomerStatus ==
                            AddingCustomerStatus.Loading)
                        ? true
                        : false,
                    label: (widget.item == null) ? 'Save' : "Update",
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
        );
      }),
    );
  }
}
