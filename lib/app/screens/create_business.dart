import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/app/screens/widget/custom_drop_field.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';
import '../../Repository/auth_respository.dart';
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
                  ),
                ),
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
                "Account Created Successfully",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 30, color: AppColor().backgroundColor),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Center(
            child: Image.asset(
              'assets/images/checker.png',
            ),
          ),
          Expanded(child: SizedBox()),
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
