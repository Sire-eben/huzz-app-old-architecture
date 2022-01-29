import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:image_picker/image_picker.dart';

class AddCustomer extends StatefulWidget {
  Customer? item;
  AddCustomer({Key? key, this.item}) : super(key: key);

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
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
            color: AppColor().backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          widget.item == null ? 'Add Customer' : "Edit Customer",
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
      body: Obx(() {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomTextFieldWithImage(
                  contactName: _customerController.nameController,
                  contactPhone: _customerController.phoneNumberController,
                  contactMail: _customerController.emailController,
                  label: "Customer name",
                  validatorText: "Customer name is needed",
                  hint: 'customer name',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                InkWell(
                  onTap: () {
                    // Get.to(() => IncomeSuccess());
                    if (_customerController.addingCustomerStatus !=
                        AddingCustomerStatus.Loading) {
                      if (widget.item == null)
                        _customerController.addBusinnessCustomer(
                            "INCOME", 'Customer');
                      else
                        _customerController
                            .updateBusinesscustomer(widget.item!);
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
      }),
    );
  }
}
