import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/bank_account_repository.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/data/repository/invoice_repository.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/ui/home/itemCard.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/constants/app_pallete.dart';
import 'package:huzz/data/model/bank.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:huzz/data/model/payment_item.dart';
import 'package:huzz/data/model/product.dart';
import 'package:huzz/ui/widget/loading_widget.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';
import 'package:huzz/core/util/util.dart';

class CreateInvoiceInformationDialog extends StatelessWidget {
  const CreateInvoiceInformationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        const SizedBox(height: 7),
        Text(
          'When you`ve filled the customer, items and payment info, you can generate an invoice you can download and share to your customer.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({Key? key}) : super(key: key);

  @override
  _CreateInvoiceState createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  // final _invoiceController = Get.find<TransactionRespository>();

  final RandomColor _randomColor = RandomColor();

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
  final ScrollController _scrollController = ScrollController();

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
  final _customerController = Get.find<CustomerRepository>();
  final _invoiceController = Get.find<InvoiceRespository>();
  final _productController = Get.find<ProductRepository>();
  final _bankAccountController = Get.find<BankAccountRepository>();
  final _productKey = GlobalKey<FormState>();
  final _customerKey = GlobalKey<FormState>();
  final _bankKey = GlobalKey<FormState>();
  final _createMoreProductKey = GlobalKey<FormState>();

  @override
  void initState() {
    quantityController.text = quantityValue.toString();
    var date = DateTime.now();
    var newDate = DateTime(date.year, date.month, date.day + 7);
    _invoiceController.date = newDate;
    _invoiceController.dateController.text =
        DateFormat("yyyy-MM-dd").format(newDate).toString();
    super.initState();
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: _invoiceController.date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDate == null) return;

    setState(() {
      _invoiceController.dateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      _invoiceController.date = newDate;
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
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Row(
          children: [
            Text(
              'Create Invoice',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontStyle: FontStyle.normal,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                Platform.isIOS
                    ? showCupertinoDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CupertinoAlertDialog(
                          content: const CreateInvoiceInformationDialog(),
                          actions: [
                            CupertinoButton(
                              child: const Text(
                                "OK",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                      )
                    : showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const CreateInvoiceInformationDialog(),
                          actions: [
                            CupertinoButton(
                              child: const Text(
                                "OK",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                      );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                child: SvgPicture.asset(
                  "assets/images/info.svg",
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        return Scrollbar(
          controller: _scrollController,
          child: Theme(
            data: ThemeData(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                    onSurface: Colors.transparent,
                    primary: Palette.primaryColor),
                primarySwatch: Palette.primaryColor,
                canvasColor: Colors.white,
                shadowColor: Colors.white),
            child: Stepper(
              controlsBuilder:
                  (BuildContext context, ControlsDetails controlsDetails) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: controlsDetails.onStepCancel,
                        child: Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                  width: 2, color: AppColors.backgroundColor),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.whiteColor,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Back',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(() {
                        return InkWell(
                          onTap: controlsDetails.onStepContinue,
                          child: Container(
                            height: 40,
                            width: 110,
                            decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: (_invoiceController.addingInvoiceStatus ==
                                    AddingInvoiceStatus.Loading)
                                ? LoadingWidget()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Continue',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: AppColors.backgroundColor,
                                          size: 15,
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
              elevation: 0,
              physics: const ScrollPhysics(),
              type: StepperType.horizontal,
              steps: getSteps(),
              currentStep: currentStep,
              onStepContinue: () async {
                final isLastStep = currentStep == getSteps().length - 1;

                if (isLastStep) {
                  final date = DateTime.now();
                  final dueDate = date.add(const Duration(days: 7));
                  if (_invoiceController.paymentValue == 1) {
                    if (_bankKey.currentState!.validate()) {
                      if (_invoiceController.productList.isEmpty) {
                        _invoiceController.addMoreProduct();
                      }
                      _invoiceController.createBusinessInvoice();
                      setState(() {});
                    }
                  } else {
                    if (_invoiceController.selectedBank != null) {
                      if (_invoiceController.productList.isEmpty) {
                        _invoiceController.addMoreProduct();
                      }
                      _invoiceController.createBusinessInvoice();
                    }
                  }
                } else {
                  if (currentStep == 1) {
                    if (_invoiceController.productList.isEmpty) {
                      if (_invoiceController.selectedValue == 1) {
                        if (_productKey.currentState!.validate()) {
                          setState(() {
                            currentStep += 1;
                          });
                        }
                      } else {
                        if (_invoiceController.selectedProduct != null) {
                          setState(() {
                            currentStep += 1;
                          });
                        }
                      }
                    } else {
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  } else if (currentStep == 0) {
                    if (_invoiceController.customerType == 1) {
                      if (_customerKey.currentState!.validate()) {
                        setState(() {
                          currentStep += 1;
                        });
                      }
                    } else {
                      if (_invoiceController.selectedCustomer != null) {
                        setState(() {
                          currentStep += 1;
                        });
                      }
                    }
                  }
                }
              },
              onStepCancel: () {
                currentStep == 0
                    ? null
                    : setState(() {
                        currentStep -= 1;
                      });
              },
            ),
          ),
        );
      }),
    );
  }

  List<Step> getSteps() => [
        Step(
            isActive: currentStep >= 0,
            title: Text(
              'Customer Info',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: CustomerInfo()),
        Step(
            isActive: currentStep >= 1,
            title: Text(
              'Item Info',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: ItemInfo()),
        Step(
            isActive: currentStep >= 2,
            title: Text(
              'Payment Info',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
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
                onTap: () =>
                    setState(() => _invoiceController.paymentValue = 1),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 1,
                        activeColor: AppColors.backgroundColor,
                        groupValue: _invoiceController.paymentValue,
                        onChanged: (value) => setState(
                            () => _invoiceController.paymentValue = 1)),
                    Text(
                      'New Details',
                      style: GoogleFonts.inter(
                        color: AppColors.backgroundColor,
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () =>
                    setState(() => _invoiceController.paymentValue = 0),
                child: Row(
                  children: [
                    Radio<int>(
                        value: 0,
                        activeColor: AppColors.backgroundColor,
                        groupValue: _invoiceController.paymentValue,
                        onChanged: (value) => setState(
                            () => _invoiceController.paymentValue = 0)),
                    Text(
                      'Existing Details',
                      style: GoogleFonts.inter(
                        color: AppColors.backgroundColor,
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
          _invoiceController.paymentValue == 0
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    vertical: Insets.md / 1.2,
                    horizontal: Insets.md,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2, color: AppColors.backgroundColor)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Bank>(
                      value: _invoiceController.selectedBank,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.backgroundColor,
                      ),
                      iconSize: 30,
                      items: _bankAccountController.offlineBusinessBank
                          .map((value) {
                        return DropdownMenuItem<Bank>(
                          value: value,
                          child: Text(value.bankAccountNumber!),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() {
                        _invoiceController.selectedBank = value;
                      }),
                    ),
                  ),
                )
              : Form(
                  key: _bankKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFieldInvoiceOptional(
                        label: 'Bank Name',
                        hint: 'bank name',
                        validatorText: "Bank Name is required",
                        keyType: TextInputType.name,
                        textEditingController:
                            _bankAccountController.bankNameController,
                      ),
                      CustomTextFieldInvoiceOptional(
                        label: 'Account Name',
                        hint: 'account name',
                        validatorText: "Account Name is required",
                        keyType: TextInputType.name,
                        textEditingController:
                            _bankAccountController.bankAccountNameController,
                      ),
                      CustomTextFieldInvoiceOptional(
                        label: 'Account Number',
                        hint: 'account number',
                        validatorText: "Account Number is required",
                        keyType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                signed: true, decimal: true)
                            : TextInputType.number,
                        textEditingController:
                            _bankAccountController.accoutNumberController,
                      ),
                    ],
                  ),
                ),
          CustomTextField(
            enabled: false,
            AllowClickable: true,
            textEditingController: _invoiceController.dateController,
            label: "Due Date",
            hint: 'Select Date',
            onClick: () {
              pickDate(context);
            },
            prefixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today),
              color: Colors.orange,
            ),
            validatorText: "Select date is needed",
            keyType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  StatefulBuilder ItemInfo() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        ScrollController? controller;
        return Scrollbar(
            // physics: ScrollPhysics(),
            controller: controller,
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (_invoiceController.productList.length < 2)
                    ? Padding(
                        // width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.height * 0.00),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  _invoiceController.amountController.text = "";
                                  _invoiceController.itemNameController.text =
                                      "";
                                  _invoiceController.selectedProduct = null;
                                  myState(() =>
                                      _invoiceController.selectedValue = 1);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Radio<int>(
                                        value: 1,
                                        activeColor: AppColors.backgroundColor,
                                        groupValue:
                                            _invoiceController.selectedValue,
                                        onChanged: (value) {
                                          _invoiceController
                                              .amountController.text = "";
                                          _invoiceController
                                              .itemNameController.text = "";
                                          _invoiceController.selectedProduct =
                                              null;
                                          myState(() => _invoiceController
                                              .selectedValue = 1);
                                        }),
                                    Text(
                                      'Enter Item',
                                      style: GoogleFonts.inter(
                                        color: AppColors.backgroundColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _invoiceController.amountController.text = "";
                                  _invoiceController.itemNameController.text =
                                      "";
                                  _invoiceController.selectedProduct = null;
                                  myState(() =>
                                      _invoiceController.selectedValue = 0);
                                },
                                child: Row(
                                  children: [
                                    Radio<int>(
                                        value: 0,
                                        activeColor: AppColors.backgroundColor,
                                        groupValue:
                                            _invoiceController.selectedValue,
                                        onChanged: (value) {
                                          _invoiceController
                                              .amountController.text = "";
                                          _invoiceController
                                              .itemNameController.text = "";
                                          _invoiceController.selectedProduct =
                                              null;
                                          myState(() => _invoiceController
                                              .selectedValue = 0);
                                          print("item is select");
                                        }),
                                    Text(
                                      'Select Item',
                                      style: GoogleFonts.inter(
                                        color: AppColors.backgroundColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ]))
                    : Container(),
                (_invoiceController.productList.length < 2)
                    ? _invoiceController.selectedValue == 1
                        ? Form(
                            key: _productKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.height *
                                              0.00),
                                  child: CustomTextField(
                                    label: "Item Name",
                                    onChanged: (value) {
                                      print("value is $value");
                                      myState(() {});
                                    },
                                    validatorText: "Item name is needed",
                                    textEditingController:
                                        _invoiceController.itemNameController,
                                    hint: 'E.g. Television',
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.height *
                                              0.00),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                            label: "Amount",
                                            hint: '${Utils.getCurrency()} 0.00',
                                            validatorText: "Amount is needed",
                                            onChanged: (value) {
                                              print("value is $value");
                                              myState(() {});
                                            },
                                            textEditingController:
                                                _invoiceController
                                                    .amountController,
                                            keyType: Platform.isIOS
                                                ? const TextInputType
                                                        .numberWithOptions(
                                                    signed: true, decimal: true)
                                                : TextInputType.number),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      Expanded(
                                        child: CustomTextField(
                                            label: "Quantity",
                                            hint: '4',
                                            keyType: Platform.isIOS
                                                ? const TextInputType
                                                        .numberWithOptions(
                                                    signed: true, decimal: true)
                                                : TextInputType.number,
                                            validatorText: "Quantity is needed",
                                            onChanged: (value) {
                                              print("value is $value");
                                              myState(() {});
                                            },
                                            onSubmited: (value) {
                                              myState(() {});
                                            },
                                            textEditingController:
                                                _invoiceController
                                                    .quantityController),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.height * 0.00),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Select Item',
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "*",
                                      style: GoogleFonts.inter(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 2,
                                            color: AppColors.backgroundColor)),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<Product>(
                                      value: _invoiceController.selectedProduct,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppColors.backgroundColor,
                                      ),
                                      iconSize: 30,
                                      items: _productController
                                          .offlineBusinessProduct
                                          .map((value) {
                                        return DropdownMenuItem<Product>(
                                          value: value,
                                          child: Text(value.productName!),
                                        );
                                      }).toList(),
                                      onChanged: (value) => myState(() {
                                        _invoiceController.selectedProduct =
                                            value;
                                        _invoiceController
                                            .selectedProduct!.quantity = 1;
                                        _invoiceController
                                                .amountController.text =
                                            value!.sellingPrice!.toString();
                                        _invoiceController.quantityController
                                            .text = 1.toString();
                                      }),
                                    ))),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        label: "Amount",
                                        hint: '${Utils.getCurrency()}',
                                        validatorText: "Amount is needed",
                                        textEditingController:
                                            _invoiceController.amountController,
                                        keyType: Platform.isIOS
                                            ? const TextInputType
                                                    .numberWithOptions(
                                                signed: true, decimal: true)
                                            : TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    Expanded(
                                      child: CustomTextField(
                                        label: "Quantity",
                                        hint: '4',
                                        validatorText: "Quantity is needed",
                                        textEditingController:
                                            _invoiceController
                                                .quantityController,
                                        inputformater: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyType: Platform.isIOS
                                            ? const TextInputType
                                                    .numberWithOptions(
                                                signed: true, decimal: true)
                                            : TextInputType.number,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                    : Container(),
                SizedBox(
                    height: _invoiceController.productList.length >= 2
                        ? 0
                        : MediaQuery.of(context).size.height * 0.02),
                (_invoiceController.productList.length >= 2)
                    ? showAllItems()
                    : Container(),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                GestureDetector(
                    onTap: () {
                      print("New Item is selected");

                      if (_invoiceController.productList.length >= 2 ||
                          _invoiceController.selectedProduct != null ||
                          _invoiceController
                                  .itemNameController.text.isNotEmpty &&
                              _invoiceController
                                  .amountController.text.isNotEmpty) {
                        if (_invoiceController.productList.isEmpty) {
                          _invoiceController.addMoreProduct();
                        }
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (context) => buildAddNewItem());
                      }
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                            color:
                                (_invoiceController.productList.length >= 2 ||
                                        _invoiceController.selectedProduct !=
                                            null ||
                                        _invoiceController.itemNameController
                                                .text.isNotEmpty &&
                                            _invoiceController
                                                .quantityController
                                                .text
                                                .isNotEmpty &&
                                            _invoiceController.amountController
                                                .text.isNotEmpty)
                                    ? AppColors.backgroundColor
                                    : AppColors.backgroundColor
                                        .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(45)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: Colors.white),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Text(
                                'Add another item',
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ]))),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldInvoiceOptional(
                          label: 'Tax(%)',
                          hint: '${Utils.getCurrency()} 0.00',
                          // inputformater: [
                          // FilteringTextInputFormatter.digitsOnly
                          // ],
                          keyType: Platform.isIOS
                              ? const TextInputType.numberWithOptions(
                                  signed: true, decimal: true)
                              : TextInputType.number),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFieldInvoiceOptional(
                        label: 'Discount(%)',
                        hint: '0',
                        keyType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                signed: true, decimal: true)
                            : TextInputType.number,
                        textEditingController:
                            _invoiceController.discountController,
                      ),
                    )
                  ],
                ),
              ],
            )));
      });

  // ignore: non_constant_identifier_names
  Container CustomerInfo() {
    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _customerKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => setState(
                              () => _invoiceController.customerType = 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Radio<int>(
                                  value: 1,
                                  activeColor: AppColors.backgroundColor,
                                  groupValue: _invoiceController.customerType,
                                  onChanged: (value) => setState(() =>
                                      _invoiceController.customerType = 1)),
                              Text(
                                'New Customer',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => setState(
                              () => _invoiceController.customerType = 0),
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 0,
                                  activeColor: AppColors.backgroundColor,
                                  groupValue: _invoiceController.customerType,
                                  onChanged: (value) => setState(() =>
                                      _invoiceController.customerType = 0)),
                              Text(
                                'Existing Customer',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
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
                    _invoiceController.customerType == 1
                        ? CustomTextFieldWithImageTransaction(
                            contactName: _customerController.nameController,
                            contactPhone:
                                _customerController.phoneNumberController,
                            contactMail: _customerController.emailController,
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
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "*",
                                    style: GoogleFonts.inter(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2,
                                          color: AppColors.backgroundColor)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Customer>(
                                      value:
                                          _invoiceController.selectedCustomer,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppColors.backgroundColor,
                                      ),
                                      iconSize: 30,
                                      items: _customerController
                                          .customerCustomer
                                          .map((value) {
                                        return DropdownMenuItem<Customer>(
                                          value: value,
                                          child: Text(value.name!),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(
                                        () => _invoiceController
                                            .selectedCustomer = value,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFieldInvoiceOptional(
                label: "Invoice Description",
                validatorText: "",
                hint: 'Add a brief invoice description',
                textEditingController: _invoiceController.noteController,
              ),
            ],
          ),
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
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          const CustomTextFieldOptional(
            label: "Business Name",
            validatorText: "Business name is needed",
          ),
          const CustomTextFieldOptional(
            label: "Email",
            validatorText: "email is needed",
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.backgroundColor, width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    decoration: const BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: AppColors.backgroundColor, width: 2)),
                    ),
                    height: 50,
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        Flag.fromString(countryFlag, height: 30, width: 30),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 24,
                          color: AppColors.backgroundColor.withOpacity(0.5),
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
                    // controller: widget.customerPhone,
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          const CustomTextFieldOption(
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
              decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Text(
                  'Continue',
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
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
      );

  Widget buildAddItem() => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: _productKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 6,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const CustomTextField(
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
                        inputformater: [FilteringTextInputFormatter.digitsOnly],
                        keyType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                signed: true, decimal: true)
                            : TextInputType.number,
                        hint: '0',
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
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
                    height: 50,
                    decoration: const BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        'Add item',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      );

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.inter(fontSize: 14),
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
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                color: AppColors.backgroundColor,
              ),
              controller: _searchcontroller,
              cursorColor: Colors.white,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.backgroundColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search Customers',
                hintStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.only(
                    left: 16, right: 8, top: 8, bottom: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.backgroundColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.backgroundColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(),
                itemCount: customerList.length,
                itemBuilder: (context, index) {
                  var item = customerList[index];
                  return Row(
                    children: [
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
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
                                style: GoogleFonts.inter(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ))),
                        ),
                      )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            '${item.name!}',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            '${item.phone!}',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
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
                decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget showAllItems() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: _invoiceController.productList.length * 80,
        child: Scrollbar(
          controller: _scrollController,
          child: ListView.separated(
              physics: const ScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: _invoiceController.productList.length,
              itemBuilder: (context, index) => ItemCard(
                    item: _invoiceController.productList[index],
                    onDelete: () {
                      var item = _invoiceController.productList[index];
                      _invoiceController.productList.remove(item);
                      if (_invoiceController.productList.length == 1) {
                        _invoiceController
                            .setValue(_invoiceController.productList.first);
                      }
                      setState(() {});
                    },
                    onEdit: () {
                      _invoiceController.selectEditValue(
                          _invoiceController.productList[index]);

                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) => buildEditItem(
                              _invoiceController.productList[index], index));
                    },
                  )),
        ));
  }

  Widget buildEditItem(PaymentItem item, int index) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 6,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              CustomTextField(
                label: 'Item Name',
                hint: 'Television',
                keyType: TextInputType.name,
                validatorText: 'Item name is needed',
                enabled: item.productId == null || item.productId!.isEmpty,
                textEditingController: _invoiceController.itemNameController,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Amount",
                      hint: '${Utils.getCurrency()} 0.00',
                      validatorText: "Amount name is needed",
                      // enabled:
                      //     item.productId == null || item.productId!.isEmpty,
                      textEditingController:
                          _invoiceController.amountController,
                      keyType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.height * 0.03),
                  Expanded(
                    child: CustomTextField(
                        label: "Quantity",
                        hint: '4',
                        keyType: TextInputType.phone,
                        validatorText: "Quantity name is needed",
                        textEditingController:
                            _invoiceController.quantityController),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  _invoiceController.updatePaymetItem(item, index);
                  setState(() {});
                  Get.back();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Update',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });

  Widget buildAddNewItem() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
            ),
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: _createMoreProductKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 6,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          myState(() {
                            _invoiceController.selectedValue = 1;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<int>(
                              value: 1,
                              activeColor: AppColors.backgroundColor,
                              groupValue: _invoiceController.selectedValue,
                              onChanged: (value) {
                                myState(() {
                                  _invoiceController.selectedValue = 1;
                                });
                              },
                            ),
                            Text(
                              'Enter Item',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          myState(() {
                            _invoiceController.selectedValue = 0;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<int>(
                                value: 0,
                                activeColor: AppColors.backgroundColor,
                                groupValue: _invoiceController.selectedValue,
                                onChanged: (value) {
                                  myState(() {
                                    value = 0;
                                    _invoiceController.selectedValue = 0;
                                  });
                                }),
                            Text(
                              'Select Item',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
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
                  _invoiceController.selectedValue == 1
                      ? CustomTextField(
                          label: 'Item Name',
                          hint: 'Television',
                          keyType: TextInputType.name,
                          validatorText: 'Item name is needed',
                          textEditingController:
                              _invoiceController.itemNameController,
                        )
                      : Container(),
                  _invoiceController.selectedValue == 1
                      ? Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: "Amount",
                                hint: '${Utils.getCurrency()} 0.00',
                                validatorText: "Amount name is needed",
                                textEditingController:
                                    _invoiceController.amountController,
                                keyType: TextInputType.phone,
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.03),
                            Expanded(
                              child: CustomTextField(
                                  label: "Quantity",
                                  hint: '4',
                                  keyType: TextInputType.phone,
                                  validatorText: "Quantity name is needed",
                                  textEditingController:
                                      _invoiceController.quantityController),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  _invoiceController.selectedValue == 1
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select product/services',
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 2,
                                      color: AppColors.backgroundColor)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Product>(
                                  value: _invoiceController.selectedProduct,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.backgroundColor,
                                  ),
                                  iconSize: 30,
                                  items: _productController
                                      .offlineBusinessProduct
                                      .map((value) {
                                    return DropdownMenuItem<Product>(
                                      value: value,
                                      child: Text(value.productName!),
                                    );
                                  }).toList(),
                                  onChanged: (value) => myState(() {
                                    _invoiceController.selectedProduct = value;
                                    _invoiceController
                                        .selectedProduct!.quantity = 1;
                                    _invoiceController.amountController.text =
                                        value!.sellingPrice!.toString();
                                    _invoiceController.quantityController.text =
                                        1.toString();
                                  }),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: "Amount",
                                    hint: '${Utils.getCurrency()} 0.00',
                                    validatorText: "Amount name is needed",
                                    textEditingController:
                                        _invoiceController.amountController,
                                    keyType: TextInputType.phone,
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.03),
                                Expanded(
                                  child: CustomTextField(
                                      label: "Quantity",
                                      hint: '4',
                                      keyType: TextInputType.phone,
                                      validatorText: "Quantity name is needed",
                                      textEditingController: _invoiceController
                                          .quantityController),
                                ),
                              ],
                            )
                          ],
                        ),
                  _invoiceController.selectedValue == 1
                      ? Container()
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                  InkWell(
                    onTap: () {
                      if (_invoiceController.selectedValue == 1) {
                        if (_createMoreProductKey.currentState!.validate()) {
                          _invoiceController.addMoreProduct();
                          Get.back();
                        }
                      } else {
                        _invoiceController.addMoreProduct();
                        Get.back();
                      }
                      setState(() {});
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          'Save',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        );
      });
}
