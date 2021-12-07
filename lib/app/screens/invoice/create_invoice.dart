import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/core/constants/app_pallete.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({Key? key}) : super(key: key);

  @override
  _CreateInvoiceState createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final TextEditingController contactName = TextEditingController();
  final TextEditingController contactPhone = TextEditingController();
  final TextEditingController contactMail = TextEditingController();
  final TextEditingController contactAddress = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final payments = ['Select payment mode', 'item1', 'item2'];
  String? value;
  int quantityValue = 0;
  String countryFlag = "NG";
  String countryCode = "234";
  int currentStep = 0;
  int customerValue = 0;
  int itemValue = 0;

  @override
  void initState() {
    quantityController.text = quantityValue.toString();
    super.initState();
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
        title: Row(
          children: [
            Text(
              'Create Invoice',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: "DMSans",
                fontStyle: FontStyle.normal,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '(#00000001)',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "DMSans",
                fontStyle: FontStyle.normal,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Theme(
        data: ThemeData(
            primarySwatch: Palette.primaryColor,
            canvasColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child: Stepper(
          physics: NeverScrollableScrollPhysics(),
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            final isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep) {
              print('Completed');
            } else {
              setState(() {
                currentStep += 1;
              });
            }
          },
          onStepCancel: () {
            currentStep == 0
                // ignore: unnecessary_statements
                ? null
                : setState(() {
                    currentStep -= 1;
                  });
          },
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
            isActive: currentStep >= 0,
            title: Text(
              'Customer Info',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'DMSans'),
            ),
            content: CustomerInfo()),
        Step(
            isActive: currentStep >= 1,
            title: Text(
              'Item Info',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'DMSans'),
            ),
            content: ItemInfo()),
        Step(
            isActive: currentStep >= 2,
            title: Text(
              'Payment Info',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'DMSans'),
            ),
            content: PaymentInfo()),
      ];

  // ignore: non_constant_identifier_names
  Container PaymentInfo() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() => itemValue = 1),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 1,
                        activeColor: AppColor().backgroundColor,
                        groupValue: itemValue,
                        onChanged: (value) => setState(() => itemValue = 1)),
                    Text(
                      'New Item',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: "DMSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => setState(() => itemValue = 0),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 0,
                        activeColor: AppColor().backgroundColor,
                        groupValue: itemValue,
                        onChanged: (value) => setState(() => itemValue = 0)),
                    Text(
                      'Existing Item',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: "DMSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          itemValue == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Select Customer',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'DMSans'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily: 'DMSans'),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 2, color: AppColor().backgroundColor)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: value,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColor().backgroundColor,
                          ),
                          iconSize: 30,
                          items: payments.map(buildPaymentItem).toList(),
                          onChanged: (value) =>
                              setState(() => this.value = value),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFieldInvoiceOptional(
                      label: 'Item Name',
                      hint: 'item name',
                      keyType: TextInputType.name,
                    ),
                    CustomTextFieldInvoiceOptional(
                      label: 'Unit Price',
                      hint: 'unit price',
                      keyType: TextInputType.phone,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            if (quantityValue < 1) {
                              setState(() {
                                quantityValue = 0;
                                quantityController.text =
                                    quantityValue.toString();

                                print(quantityValue);
                              });
                            } else {
                              setState(() {
                                quantityValue--;
                                quantityController.text =
                                    quantityValue.toString();

                                print(quantityValue);
                              });
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.005),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor().backgroundColor),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              )),
                        ),
                        Expanded(
                          child: CustomTextFieldOnly(
                            label: '0',
                            hint: '0',
                            textEditingController: quantityController,
                            keyType: TextInputType.phone,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              quantityValue++;
                              quantityController.text =
                                  quantityValue.toString();

                              print(quantityValue);
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.005),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor().backgroundColor),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    InkWell(
                      onTap: () => showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) => buildAddItem()),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                            color: itemValue == 1
                                ? AppColor().backgroundColor
                                : AppColor().backgroundColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(45)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            Text(
                              'Add another item',
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFieldInvoiceOptional(
                            label: 'Tax(%)',
                            hint: '0',
                            keyType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomTextFieldInvoiceOptional(
                            label: 'Discount(%)',
                            hint: '0',
                            keyType: TextInputType.phone,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container ItemInfo() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() => itemValue = 1),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 1,
                        activeColor: AppColor().backgroundColor,
                        groupValue: itemValue,
                        onChanged: (value) => setState(() => itemValue = 1)),
                    Text(
                      'New Item',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: "DMSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => setState(() => itemValue = 0),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 0,
                        activeColor: AppColor().backgroundColor,
                        groupValue: itemValue,
                        onChanged: (value) => setState(() => itemValue = 0)),
                    Text(
                      'Existing Item',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: "DMSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          itemValue == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Select Customer',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'DMSans'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily: 'DMSans'),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 2, color: AppColor().backgroundColor)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: value,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColor().backgroundColor,
                          ),
                          iconSize: 30,
                          items: payments.map(buildPaymentItem).toList(),
                          onChanged: (value) =>
                              setState(() => this.value = value),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFieldInvoiceOptional(
                      label: 'Item Name',
                      hint: 'item name',
                      keyType: TextInputType.name,
                    ),
                    CustomTextFieldInvoiceOptional(
                      label: 'Unit Price',
                      hint: 'unit price',
                      keyType: TextInputType.phone,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            if (quantityValue < 1) {
                              setState(() {
                                quantityValue = 0;
                                quantityController.text =
                                    quantityValue.toString();

                                print(quantityValue);
                              });
                            } else {
                              setState(() {
                                quantityValue--;
                                quantityController.text =
                                    quantityValue.toString();

                                print(quantityValue);
                              });
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.005),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor().backgroundColor),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              )),
                        ),
                        Expanded(
                          child: CustomTextFieldOnly(
                            label: '0',
                            hint: '0',
                            textEditingController: quantityController,
                            keyType: TextInputType.phone,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              quantityValue++;
                              quantityController.text =
                                  quantityValue.toString();

                              print(quantityValue);
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.005),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor().backgroundColor),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    InkWell(
                      onTap: () => showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) => buildAddItem()),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                            color: itemValue == 1
                                ? AppColor().backgroundColor
                                : AppColor().backgroundColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(45)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            Text(
                              'Add another item',
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFieldInvoiceOptional(
                            label: 'Tax(%)',
                            hint: '0',
                            keyType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomTextFieldInvoiceOptional(
                            label: 'Discount(%)',
                            hint: '0',
                            keyType: TextInputType.phone,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container CustomerInfo() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() => customerValue = 1),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 1,
                        activeColor: AppColor().backgroundColor,
                        groupValue: customerValue,
                        onChanged: (value) =>
                            setState(() => customerValue = 1)),
                    Text(
                      'New Customer',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: "DMSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => setState(() => customerValue = 0),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 0,
                        activeColor: AppColor().backgroundColor,
                        groupValue: customerValue,
                        onChanged: (value) =>
                            setState(() => customerValue = 0)),
                    Text(
                      'Existing Customer',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: "DMSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          customerValue == 1
              ? CustomTextFieldInvoice(
                  contactName: contactName,
                  contactPhone: contactPhone,
                  contactMail: contactMail,
                  contactAddress: contactAddress,
                  label: "Customer name",
                  validatorText: "Customer name is needed",
                  hint: 'customer name',
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFieldInvoiceOptional(
                      label: 'Customer Name',
                      hint: 'customer name',
                      keyType: TextInputType.name,
                    ),
                    CustomTextFieldInvoiceOptional(
                      label: 'Email',
                      hint: 'yourmail@mail.com',
                      keyType: TextInputType.emailAddress,
                    ),
                    CustomTextFieldInvoiceOptional(
                      label: 'Phone',
                      hint: '08123456789',
                      keyType: TextInputType.emailAddress,
                    ),
                    CustomTextFieldInvoiceOptional(
                      label: 'Address',
                      hint: 'your address',
                      keyType: TextInputType.emailAddress,
                    )
                  ],
                ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container BusinessInfo(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          SvgPicture.asset('assets/images/pick_business_image.svg'),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            'Business Logo',
            style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'DMSans'),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          CustomTextFieldOptional(
            label: "Business Name",
            validatorText: "Business name is needed",
          ),
          CustomTextFieldOptional(
            label: "Email",
            validatorText: "email is needed",
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColor().backgroundColor, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showCountryCode(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: AppColor().backgroundColor, width: 2)),
                    ),
                    height: 50,
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 10),
                        Flag.fromString(countryFlag, height: 30, width: 30),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 24,
                          color: AppColor().backgroundColor.withOpacity(0.5),
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
                    // controller: widget.contactPhone,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "9034678966",
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.w500),
                        prefixText: "+$countryCode ",
                        prefixStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DMSans',
                            color: Colors.black)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          CustomTextFieldOption(
            label: "Address",
            validatorText: "email is needed",
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          InkWell(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              height: 50,
              decoration: BoxDecoration(
                  color: AppColor().backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Text(
                  'Continue',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'DMSans'),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ],
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

  DropdownMenuItem<String> buildPaymentItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 14, fontFamily: 'DMSans'),
        ),
      );

  Widget buildAddItem() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 6,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            CustomTextField(
              label: "Item Name",
              validatorText: "Item name is needed",
              hint: 'E.g. Television',
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: "Amount",
                    validatorText: "amount is needed",
                    hint: '0',
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    label: "Quantity",
                    validatorText: "quantity is needed",
                    hint: '0',
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            InkWell(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    'Add item',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'DMSans'),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
