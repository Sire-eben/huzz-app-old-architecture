import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/ui/widget/custom_drop_field.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/util/colors.dart';
import '../data/repository/auth_respository.dart';
import 'dashboard.dart';

class CreateBusiness extends StatefulWidget {
  _CreateBusinessState createState() => _CreateBusinessState();
}

class _CreateBusinessState extends State<CreateBusiness> {
  @override
  void initState() {
    super.initState();
    _businessController.businessEmail.text = _userController.user!.email ?? "";
    _businessController.businessPhoneNumber.text =
        _userController.user!.phoneNumber ?? "";
  }

  final _businessController = Get.find<BusinessRespository>();
  final _userController = Get.find<AuthRepository>();
  final key = GlobalKey<FormState>();
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
              fontFamily: 'InterRegular',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: key,
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
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: CustomTextField(
                      label: "Phone Number",
                      validatorText: "Phone Number is needed",
                      keyType: TextInputType.phone,
                      maxLength: 13,
                      textEditingController:
                          _businessController.businessPhoneNumber,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: CustomTextField(
                      label: "Email",
                      textEditingController: _businessController.businessEmail,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 115,
                    child: CustomTextField(
                      enabled: false,
                      hint: "Select Currency",
                      AllowClickable: true,
                      onClick: () {
                        showCurrencyPicker(
                          context: context,
                          showFlag: true,
                          showCurrencyName: true,
                          showCurrencyCode: true,
                          onSelect: (Currency currency) {
                            print('Select currency: ${currency.code}');
                            _businessController.businessCurrency.text =
                                currency.code;
                          },
                          favorite: ['USD'],
                        );
                      },
                      label: "Currency ",
                      validatorText: "Currency is required",
                      keyType: TextInputType.phone,
                      maxLength: 13,
                      textEditingController:
                          _businessController.businessCurrency,
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
                      if (_businessController.businessCurrency.text.isEmpty) {
                        Get.snackbar(
                            "Error", "Kindly select currency to proceed");
                        return;
                      }
                      if (_businessController.createBusinessStatus !=
                          CreateBusinessStatus
                              .Loading) if (key.currentState!.validate()) {
                        _businessController.createBusiness();
                      }
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
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
        ),
      );
    });
  }

  _displayLogoutDialog(
      BuildContext context, String title, VoidCallback onContinue) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 55,
              vertical: 250,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '$title',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'InterRegular',
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: SvgPicture.asset(
                    'assets/images/polygon.svg',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColor().whiteColor,
                            border: Border.all(
                              width: 2,
                              color: AppColor().backgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColor().backgroundColor,
                              fontFamily: 'InterRegular',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        _userController.logout();
                        onContinue();
                      },
                      child: Container(
                        height: 45,
                        width: 100,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppColor().backgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'InterRegular',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class BusinessCreatedSuccesful extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  child: SvgPicture.asset('assets/images/Vector.svg'),
                ),
                // Positioned(
                //   top: 50,
                //   left: 20,
                //   child: GestureDetector(
                //     onTap: () {
                //       Get.offAll(() => Dashboard());
                //     },
                //     child: Icon(
                //       Icons.arrow_back,
                //       color: AppColor().backgroundColor,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                "Business Created Successfully",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 30, color: AppColor().backgroundColor),
              )),
          Spacer(),
          Center(
            child: Image.asset(
              'assets/images/checker.png',
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Get.offAll(() => Dashboard());
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
                    'Proceed',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
      ),
    ));
  }
}