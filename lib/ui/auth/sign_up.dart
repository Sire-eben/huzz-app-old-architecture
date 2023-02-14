import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_svg/svg.dart';
=======
>>>>>>> 1d838468783131dda717d077445733e6aa6aba0b
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/mixins/form_mixin.dart';
import 'package:huzz/core/util/validators.dart';
import 'package:huzz/core/widgets/app_bar.dart';
<<<<<<< HEAD
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/button/continue_btn.dart';
import 'package:huzz/core/widgets/textfield/textfield.dart';
import 'package:huzz/core/widgets/unfocus_scope.dart';
=======
import 'package:huzz/core/widgets/button/continue_btn.dart';
import 'package:huzz/core/widgets/textfield/textfield.dart';
>>>>>>> 1d838468783131dda717d077445733e6aa6aba0b
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/ui/auth/create_pin.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<Signup> with FormMixin {
  final _authController = Get.find<AuthRepository>();

<<<<<<< HEAD
=======
  // final _formKey = GlobalKey<FormState>();
>>>>>>> 1d838468783131dda717d077445733e6aa6aba0b
  String countryFlag = "NG";
  String countryCode = "234";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteColor,
<<<<<<< HEAD
      extendBodyBehindAppBar: true,
      appBar: Appbar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: UnfocusScope(
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Positioned(
                            top: 20,
                            child:
                                SvgPicture.asset('assets/images/Vector.svg')),
                      ],
                    ),
                  ),
                  Center(
                    child: Text('Personal Details',
                        style: GoogleFonts.inter(
                            color: AppColors.backgroundColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Center(
                    child: Text(
                      'let’s get to know you better',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Gap(Insets.md),
                  TextInputField(
                    inputType: TextInputType.name,
                    labelText: "First Name",
                    validator: Validators.validateString(
                        error: "First name is needed"),
                    controller: _authController.firstNameController,
                  ),
                  TextInputField(
                    inputType: TextInputType.name,
                    labelText: "Last Name",
                    validator:
                        Validators.validateString(error: "Last name is needed"),
                    controller: _authController.lastNameController,
                  ),
                  TextInputField(
                    inputType: TextInputType.emailAddress,
                    labelText: "Email",
                    controller: _authController.emailController,
                  ),
                  Text(
                    "Phone Number",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: AppColors.backgroundColor, width: 2.0),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // showCountryCode(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      color: AppColors.backgroundColor,
                                      width: 2)),
                            ),
                            height: 60,
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 10),
                                Flag.fromString(countryFlag,
                                    height: 30, width: 30),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 24,
                                  color: AppColors.backgroundColor
                                      .withOpacity(0.5),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: _authController.phoneNumberController,
                            // ${_authController.phoneNumberController.value}
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "8123456789",
                                hintStyle: GoogleFonts.inter(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                prefixText: "+$countryCode ",
                                prefixStyle: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  if (!_authController.hasReferralDeeplink.value) ...[
                    SizedBox(
                      height: 10,
                    ),
                    TextInputField(
                      controller: _authController.referralCodeController,
                      labelText: "Refferal Code (Optional)",
                    )
                  ],
                  SizedBox(height: 24),
                  ContinueButton(
                    action: () {
                      if (formKey.currentState!.validate()) {
                        Get.to(() => CreatePin());
                      }
                    },
                  ),
                  SizedBox(height: 50),
                ],
              ),
=======
      appBar: Appbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text('Personal Details',
                      style: GoogleFonts.inter(
                          color: AppColors.backgroundColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w500)),
                ),
                const Gap(Insets.md),
                Center(
                  child: Text(
                    'let’s get to know you better',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                const Gap(Insets.md),
                TextInputField(
                  controller: _authController.firstNameController,
                  labelText: "First Name",
                  validator: Validators.validateString(
                    error: "First name is needed",
                  ),
                ),
                TextInputField(
                  controller: _authController.lastNameController,
                  labelText: "Last Name",
                  validator: Validators.validateString(
                    error: "Last name is needed",
                  ),
                ),
                TextInputField(
                  inputType: TextInputType.emailAddress,
                  controller: _authController.emailController,
                  labelText: "Email",
                  validator: (input) => Validators.validateEmail(input),
                ),
                // PhoneNumberTextInputField(
                //   labelText: "Phone Number",
                //   controller: _authController.phoneNumberController,
                // ),
                Text(
                  "Phone Number",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 58,
                  margin: const EdgeInsets.only(bottom: Insets.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.backgroundColor, width: 1.2),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // showCountryCode(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: AppColors.backgroundColor,
                                    width: 2)),
                          ),
                          height: 50,
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              Flag.fromString(countryFlag,
                                  height: 30, width: 30),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 24,
                                color:
                                    AppColors.backgroundColor.withOpacity(0.5),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          enabled: false,
                          controller: _authController.phoneNumberController,
                          // ${_authController.phoneNumberController.value}
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "8123456789",
                              hintStyle: GoogleFonts.inter(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              prefixText: "+$countryCode ",
                              prefixStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),

                if (!_authController.hasReferralDeeplink.value) ...[
                  // Gap(Insets.md),
                  TextInputField(
                    labelText: "Referral Code (Optional)",
                    controller: _authController.referralCodeController,
                    // validator: Validators.validateString(),
                  )
                ],
                const Gap(Insets.lg),
                ContinueButton(
                  label: 'Continue',
                  action: () {
                    if (formKey.currentState!.validate()) {
                      Get.to(() => CreatePin());
                    }
                  },
                )
              ],
>>>>>>> 1d838468783131dda717d077445733e6aa6aba0b
            ),
          ),
        ),
      ),
    );
  }

  Future showCountryCode(BuildContext context) async {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        countryCode = country.toJson()['e164_cc'];
        countryFlag = country.toJson()['iso2_cc'];

        country.toJson();
        setState(() {});

        print('Select country: ${country.toJson()}');
      },
    );
  }
}
