import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/presentation/widget/custom_drop_field.dart';
import 'package:huzz/presentation/widget/custom_form_field.dart';
import 'package:huzz/core/constants/app_themes.dart';
import '../../data/repository/auth_respository.dart';
import '../app_scaffold.dart';

class CreateBusiness extends StatefulWidget {
  const CreateBusiness({super.key});

  @override
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
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.backgroundColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'Create Your Business',
            style: GoogleFonts.inter(
              color: AppColors.backgroundColor,
              fontWeight: FontWeight.w600,
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
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: CustomTextField(
                          label: "Business Name",
                          validatorText: "Business name is required",
                          textEditingController:
                              _businessController.businessName)),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: CustomTextField(
                      label: "Address (Optional)",
                      textEditingController:
                          _businessController.businessAddressController,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
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
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: CustomTextField(
                      label: "Email",
                      textEditingController: _businessController.businessEmail,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  SizedBox(
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
                            // print('Select currency: ${currency.code}');
                            _businessController.businessCurrency.text =
                                currency.code;
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          favorite: ['NGN'],
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
                  const SizedBox(
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
                  const SizedBox(
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
                      decoration: const BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: (_businessController.createBusinessStatus ==
                              CreateBusinessStatus.Loading)
                          ? const SizedBox(
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
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: const Icon(
                                    Icons.add,
                                    color: AppColors.backgroundColor,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Continue',
                                  style: GoogleFonts.inter(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(
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

}

class BusinessCreatedSuccesful extends StatelessWidget {
  const BusinessCreatedSuccesful({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(
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
                //       color: AppColors.backgroundColor,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                "Business Created Successfully",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 30, color: AppColors.backgroundColor),
              )),
          const Spacer(),
          Center(
            child: Image.asset(
              'assets/images/checker.png',
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Get.offAll(() => Dashboard());
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 50, right: 50),
              height: 50,
              decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Proceed',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(width: 10),
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
