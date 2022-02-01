import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/app/screens/widget/custom_drop_field.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';

class CreateBusiness extends StatelessWidget {
  final _businessController = Get.find<BusinessRespository>();
  @override
  // ignore: dead_code
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            'Create Your Business',
            style: TextStyle(
              color: AppColor().backgroundColor,
              fontFamily: 'DMSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: CustomTextField(
                        label: "Business Name",
                        validatorText: "Business name is required",
                        textEditingController:
                            _businessController.businessName)),
                SizedBox(
                  height: 5,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: CustomTextField(
                      label: "Address (Optional)",
                      textEditingController:
                          _businessController.businessAddressController,
                    )),
                SizedBox(
                  height: 5,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: CustomTextField(
                      label: "Phone Number",
                      validatorText: "Phone Number is needed",
                      keyType: TextInputType.phone,
                      maxLength: 11,
                      textEditingController:
                          _businessController.businessPhoneNumber,
                    )),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: CustomTextField(
                    label: "Email",
                    validatorText: "Email is required",
                    textEditingController: _businessController.businessEmail,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                CustomDropDownField(
                  label: "Business Category",
                  validatorText: "Business Category is required",
                  hintText: "Select business category",
                  values: _businessController.businessCategory,
                  currentSelectedValue: _businessController.selectedCategory,
                ),
                // Expanded(flex: 2, child: SizedBox()),
                SizedBox(
                  height: 100,
                ),
                GestureDetector(
                  onTap: () {
                    // Get.to(Signin());
                    if (_businessController.createBusinessStatus !=
                        CreateBusinessStatus.Loading)
                      _businessController.createBusiness();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    // margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColor().backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: (_businessController.createBusinessStatus ==
                            CreateBusinessStatus.Loading)
                        ? Container(
                            width: 30,
                            height: 30,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Icon(
                                  Icons.add,
                                  color: AppColor().backgroundColor,
                                  size: 16,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Continue',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
