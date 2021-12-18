import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/transaction_respository.dart';
import 'package:huzz/app/screens/invoice/preview_invoice.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/core/constants/app_pallete.dart';
import 'package:huzz/model/bank_model.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/invoice_receipt_model.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';
import 'package:huzz/model/service_model.dart';
import 'invoice_pdf.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({Key? key}) : super(key: key);

  @override
  _CreateInvoiceState createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final _transactionController = Get.find<TransactionRespository>();

  RandomColor _randomColor = RandomColor();

  final TextEditingController customerName = TextEditingController();
  final TextEditingController customerPhone = TextEditingController();
  final TextEditingController customerMail = TextEditingController();
  final TextEditingController customerAddress = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController itemName = TextEditingController();
  final TextEditingController unitPrice = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController accountName = TextEditingController();
  final TextEditingController accountNo = TextEditingController();
  final TextEditingController _searchcontroller = TextEditingController();

  final payments = ['Select payment mode', 'item1', 'item2'];
  String? value;
  int quantityValue = 0;
  String countryFlag = "NG";
  String countryCode = "234";
  int currentStep = 0;
  int customerValue = 0;
  int itemValue = 0;
  int paymentValue = 0;
  bool showService = false;

  @override
  void initState() {
    quantityController.text = quantityValue.toString();
    _transactionController.dateController.text =
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    super.initState();
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: _transactionController.date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      _transactionController.dateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      _transactionController.date = newDate;
      // print(dateController.text);
    });
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
            colorScheme: Theme.of(context).colorScheme.copyWith(
                onSurface: Colors.transparent, primary: Palette.primaryColor),
            primarySwatch: Palette.primaryColor,
            canvasColor: Colors.white,
            shadowColor: Colors.white),
        child: Stepper(
          elevation: 0,
          physics: NeverScrollableScrollPhysics(),
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () async {
            final isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep) {
              final date = DateTime.now();
              final dueDate = date.add(Duration(days: 7));

              final invoice = Invoice(
                supplier: Supplier(
                  name: 'Business Name',
                  mail: 'tunmisehassan@gmail.com',
                  phone: '+234 8123 456 789',
                ),
                bankDetails: BankDetails(
                    name: accountName.text,
                    no: accountNo.text,
                    mode: 'BANK TRANSFER'),
                customer: InvoiceCustomer(
                  name: 'Joshua Olatunde',
                  phone: '+234 903 872 6495',
                ),
                info: InvoiceInfo(
                  date: date,
                  dueDate: dueDate,
                  description: 'My description...',
                  number: '${DateTime.now().year}-9999',
                ),
                items: [
                  InvoiceItem(
                    item: 'MacBook',
                    quantity: 3,
                    amount: 500000,
                  ),
                  InvoiceItem(
                    item: 'MacBook',
                    quantity: 3,
                    amount: 500000,
                  ),
                  InvoiceItem(
                    item: 'MacBook',
                    quantity: 3,
                    amount: 500000,
                  ),
                  InvoiceItem(
                    item: 'MacBook',
                    quantity: 3,
                    amount: 500000,
                  ),
                ],
              );
              final invoiceReceipt = await PdfInvoiceApi.generate(invoice);
              Get.to(() => PreviewInvoice(file: invoiceReceipt));
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
                onTap: () => setState(() => paymentValue = 1),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 1,
                        activeColor: AppColor().backgroundColor,
                        groupValue: paymentValue,
                        onChanged: (value) => setState(() => paymentValue = 1)),
                    Text(
                      'New Details',
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
                onTap: () => setState(() => paymentValue = 0),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 0,
                        activeColor: AppColor().backgroundColor,
                        groupValue: paymentValue,
                        onChanged: (value) => setState(() => paymentValue = 0)),
                    Text(
                      'Existing Details',
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
          paymentValue == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Select Details',
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
                    GestureDetector(
                      onTap: () {
                        // showModalBottomSheet(
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.vertical(
                        //             top: Radius.circular(20))),
                        //     context: context,
                        //     builder: (context) => buildSelectService());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 3, color: AppColor().backgroundColor)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            buildMenuItem("Select existing account details"),
                            Expanded(child: SizedBox()),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColor().backgroundColor,
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank Name',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'DMSans'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (context) => buildSelectBank());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 3, color: AppColor().backgroundColor)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            buildMenuItem("Bank Name"),
                            Expanded(child: SizedBox()),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColor().backgroundColor,
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    CustomTextFieldInvoiceOptional(
                      label: 'Account Name',
                      hint: 'account name',
                      keyType: TextInputType.name,
                    ),
                    CustomTextFieldInvoiceOptional(
                      label: 'Account Number',
                      hint: 'account number',
                      keyType: TextInputType.phone,
                    ),
                    CustomTextField(
                      enabled: false,
                      AllowClickable: true,
                      textEditingController:
                          _transactionController.dateController,
                      label: "Select Date",
                      hint: 'Select Date',
                      onClick: () {
                        pickDate(context);
                      },
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.calendar_today),
                        color: Colors.orange,
                      ),
                      validatorText: "Select date is needed",
                      keyType: TextInputType.phone,
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
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (context) => buildSelectService());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 3, color: AppColor().backgroundColor)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            buildMenuItem("Select services"),
                            Expanded(child: SizedBox()),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColor().backgroundColor,
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
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
                        Expanded(child: Container()),
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
                                size: 15,
                                color: Colors.white,
                              )),
                        ),
                        Expanded(
                          flex: 2,
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
                                size: 15,
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
      child: SingleChildScrollView(
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            customerValue == 1
                ? CustomTextFieldInvoice(
                    contactName: customerName,
                    contactPhone: customerPhone,
                    contactMail: customerMail,
                    contactAddress: customerAddress,
                    label: "Customer name",
                    validatorText: "Customer name is needed",
                    hint: 'customer name',
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Select Customer',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              context: context,
                              builder: (context) => buildSelectCustomer());
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 3, color: AppColor().backgroundColor)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              buildMenuItem("Select existing customer"),
                              Expanded(child: SizedBox()),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColor().backgroundColor,
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
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
                    // controller: widget.customerPhone,
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 14),
        ),
      );

  Widget buildSelectService() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.04),
        child: Column(
          children: [
            TextField(
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColor().backgroundColor,
                  fontFamily: 'DMSans'),
              controller: _searchcontroller,
              cursorColor: Colors.white,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor().backgroundColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search Customers',
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'DMSans'),
                contentPadding:
                    EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(),
                itemCount: serviceList.length,
                itemBuilder: (context, index) {
                  var item = serviceList[index];
                  return Center(
                      child: Text(
                    '${item.name}',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold),
                  ));
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            InkWell(
              onTap: () {
                // Get.to(() => AddNewSale());
              },
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

  Widget buildSelectBank() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.04),
        child: Column(
          children: [
            TextField(
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColor().backgroundColor,
                  fontFamily: 'DMSans'),
              controller: _searchcontroller,
              cursorColor: Colors.white,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor().backgroundColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search Bank',
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'DMSans'),
                contentPadding:
                    EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(),
                itemCount: bankList.length,
                itemBuilder: (context, index) {
                  var item = bankList[index];
                  return Center(
                      child: Text(
                    '${item.name}',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold),
                  ));
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSelectCustomer() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColor().backgroundColor,
                  fontFamily: 'DMSans'),
              controller: _searchcontroller,
              cursorColor: Colors.white,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor().backgroundColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search Customers',
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'DMSans'),
                contentPadding:
                    EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(),
                itemCount: customerList.length,
                itemBuilder: (context, index) {
                  var item = customerList[index];
                  return Row(
                    children: [
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _randomColor.randomColor()),
                              child: Center(
                                  child: Text(
                                '${item.name![0]}',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold),
                              ))),
                        ),
                      )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            '${item.name!}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            '${item.phone!}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            InkWell(
              onTap: () {
                // Get.to(() => AddNewSale());
              },
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
