import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/Repository/transaction_respository.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:huzz/model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'itemCard.dart';

class MoneyIn extends StatefulWidget {
  const MoneyIn({Key? key}) : super(key: key);

  @override
  _MoneyInState createState() => _MoneyInState();
}

class _MoneyInState extends State<MoneyIn> {
  final _transactionController = Get.find<TransactionRespository>();
  final _customerController = Get.find<CustomerRepository>();
  final _productController = Get.find<ProductRepository>();
  @override
  void initState() {
    _transactionController.clearValue();
    _transactionController.date = DateTime.now();
    _transactionController.dateController.text =
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    _transactionController.time = TimeOfDay.now();
    _transactionController.timeController.text =
        '${_transactionController.time!.hour.toString().padLeft(2, '0')}:${_transactionController.time!.minute.toString().padLeft(2, '0')} ${_transactionController.time!.period.index == 0 ? am : pm}';
    // timeController.text =
    // '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')} ${time!.period.index == 0 ? am : pm}';
    super.initState();
  }

  final paymentMode = ['FULLY_PAID', 'DEPOSIT'];
  final products = ['Shoe', 'Bag', 'Clothes'];
  final customers = ['Customer 1', 'Customer 2', 'Customer 3'];
  final paymentSource = ["POS", "CASH", "TRANSFER", "OTHERS"];
  

  String? value;

  String countryFlag = "NG";
  String countryCode = "234";
  String am = 'AM';
  String pm = "PM";

  int paymentType = 0;
  int paymentModes = 0;

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      print(imageTemporary);
      setState(
        () {
          _transactionController.image = imageTemporary;
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
          _transactionController.image = imageTemporary;
        },
      );
    } on PlatformException catch (e) {
      print('$e');
    }
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

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final newTime = await showTimePicker(
      context: context,
      initialTime: _transactionController.time ?? initialTime,
    );

    if (newTime == null) return;

    setState(() {
      _transactionController.time = newTime;
      _transactionController.timeController.text =
          '${_transactionController.time!.hour.toString().padLeft(2, '0')}:${_transactionController.time!.minute.toString().padLeft(2, '0')} ${_transactionController.time!.period.index == 0 ? am : pm}';
      print(_transactionController.timeController.text);
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
        title: Text(
          'Money In',
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (_transactionController.productList.length < 2)
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _transactionController.amountController.text = "";
                              _transactionController.itemNameController.text =
                                  "";
                              _transactionController.selectedProduct = null;
                              setState(() =>
                                  _transactionController.selectedValue = 1);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Radio<int>(
                                    value: 1,
                                    activeColor: AppColor().backgroundColor,
                                    groupValue:
                                        _transactionController.selectedValue,
                                    onChanged: (value) {
                                      _transactionController
                                          .amountController.text = "";
                                      _transactionController
                                          .itemNameController.text = "";
                                      _transactionController.selectedProduct =
                                          null;
                                      setState(() => _transactionController
                                          .selectedValue = 1);
                                    }),
                                Text(
                                  'Enter Item',
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
                            onTap: () {
                              _transactionController.amountController.text = "";
                              _transactionController.itemNameController.text =
                                  "";
                              _transactionController.selectedProduct = null;
                              setState(() =>
                                  _transactionController.selectedValue = 0);
                            },
                            child: Row(
                              children: [
                                Radio<int>(
                                    value: 0,
                                    activeColor: AppColor().backgroundColor,
                                    groupValue:
                                        _transactionController.selectedValue,
                                    onChanged: (value) {
                                      _transactionController
                                          .amountController.text = "";
                                      _transactionController
                                          .itemNameController.text = "";
                                      _transactionController.selectedProduct =
                                          null;
                                      setState(() => _transactionController
                                          .selectedValue = 0);
                                      print("item is select");
                                    }),
                                Text(
                                  'Select Product',
                                  style: TextStyle(
                                    color: AppColor().backgroundColor,
                                    fontFamily: "DMSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              (_transactionController.productList.length < 2)
                  ? _transactionController.selectedValue == 1
                      ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.height *
                                          0.03),
                              child: CustomTextField(
                                label: "Item Name",
                                onChanged: (value) {
                                  print("value is $value");
                                  setState(() {});
                                },
                                validatorText: "Item name is needed",
                                textEditingController:
                                    _transactionController.itemNameController,
                                hint: 'E.g. Television',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.height *
                                          0.03),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: "Amount",
                                      hint: 'N 0.00',
                                      validatorText: "Amount is needed",
                                      onChanged: (value) {
                                        print("value is $value");
                                        setState(() {});
                                      },
                                      textEditingController:
                                          _transactionController
                                              .amountController,
                                      keyType: TextInputType.phone,
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
                                        keyType: TextInputType.phone,
                                        validatorText: "Quantity is needed",
                                        onChanged: (value) {
                                          print("value is $value");
                                          setState(() {});
                                        },
                                        onSubmited: (value) {
                                          setState(() {});
                                        },
                                        textEditingController:
                                            _transactionController
                                                .quantityController),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.height * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Select Product',
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 2,
                                        color: AppColor().backgroundColor)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Product>(
                                    value:
                                        _transactionController.selectedProduct,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColor().backgroundColor,
                                    ),
                                    iconSize: 30,
                                    items: _productController.productGoods
                                        .map((value) {
                                      return DropdownMenuItem<Product>(
                                        value: value,
                                        child: Text(value.productName!),
                                      );
                                    }).toList(),
                                    onChanged: (value) => setState(() {
                                      _transactionController.selectedProduct =
                                          value;
                                      _transactionController
                                          .selectedProduct!.quantity = 1;
                                      _transactionController
                                              .amountController.text =
                                          value!.sellingPrice!.toString();
                                      _transactionController.quantityController
                                          .text = 1.toString();
                                    }),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: "Amount",
                                      hint: 'N 0.00',
                                      validatorText: "Amount is needed",
                                      textEditingController:
                                          _transactionController
                                              .amountController,
                                      keyType: TextInputType.phone,
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
                                        keyType: TextInputType.phone,
                                        validatorText: "Quantity is needed",
                                        onChanged: (value) {
                                          print("value is $value");
                                          setState(() {});
                                        },
                                        onSubmited: (value) {
                                          setState(() {});
                                        },
                                        textEditingController:
                                            _transactionController
                                                .quantityController),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                  : Container(),
              SizedBox(
                  height: _transactionController.selectedValue == 1
                      ? 0
                      : MediaQuery.of(context).size.height * 0.02),
              SizedBox(
                  height: _transactionController.productList.length >= 2
                      ? MediaQuery.of(context).size.height * 0.02
                      : 0),
              (_transactionController.productList.length >= 2)
                  ? showAllItems()
                  : Container(),
              SizedBox(
                  height: _transactionController.productList.length >= 2
                      ? MediaQuery.of(context).size.height * 0.02
                      : 0),
              GestureDetector(
                onTap: () {
                  print("New Item is selected");

                  if (_transactionController.productList.length >= 2 ||
                      _transactionController.selectedProduct != null ||
                      _transactionController
                              .itemNameController.text.isNotEmpty &&
                          _transactionController
                              .amountController.text.isNotEmpty) {
                    if (_transactionController.productList.isEmpty) {
                      _transactionController.addMoreProduct();
                    }
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        context: context,
                        builder: (context) => buildAddNewItem());
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.03),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.055,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color:
                            (_transactionController.productList.length >= 2 ||
                                    _transactionController.selectedProduct !=
                                        null ||
                                    _transactionController.itemNameController
                                            .text.isNotEmpty &&
                                        _transactionController
                                            .quantityController
                                            .text
                                            .isNotEmpty &&
                                        _transactionController
                                            .amountController.text.isNotEmpty)
                                ? AppColor().backgroundColor
                                : AppColor().backgroundColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(45)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
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
                        // validatorText: "Select date is needed",
                        keyType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.03),
                    Expanded(
                      child: CustomTextField(
                        enabled: false,
                        AllowClickable: true,
                        textEditingController:
                            _transactionController.timeController,
                        label: "Select Time",
                        hint: 'Select Time',
                        onClick: () {
                          print("trying to pick time");
                          pickTime(context);
                        },
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.lock_clock),
                          color: Colors.orange,
                        ),
                        keyType: TextInputType.phone,
                        // validatorText: "Select time is needed",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Payment Mode',
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
                          value: _transactionController.selectedPaymentMode,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColor().backgroundColor,
                          ),
                          iconSize: 30,
                          items: _transactionController.paymentMode
                              .map(buildPaymentItem)
                              .toList(),
                          onChanged: (value) => setState(() =>
                              _transactionController.selectedPaymentMode =
                                  value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              (_transactionController.selectedPaymentMode != null &&
                      _transactionController.selectedPaymentMode == "DEPOSIT")
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      child: CustomTextField(
                        label: "Amount Paid",
                        hint: 'N 0.00',
                        validatorText: "Amount Paid is needed",
                        keyType: TextInputType.number,
                        textEditingController:
                            _transactionController.amountPaidController,
                      ),
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Payment Source',
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
                          value: _transactionController.selectedPaymentSource,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColor().backgroundColor,
                          ),
                          iconSize: 30,
                          items: _transactionController.paymentSource
                              .map(buildPaymentItem)
                              .toList(),
                          onChanged: (value) => setState(() =>
                              _transactionController.selectedPaymentSource =
                                  value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0)),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.camera,
                              color: AppColor().backgroundColor,
                            ),
                            title: Text('Camera'),
                            onTap: () {
                              Get.back();
                              pickImageFromCamera();
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.image,
                              color: AppColor().backgroundColor,
                            ),
                            title: Text('Gallery'),
                            onTap: () {
                              Get.back();
                              pickImageFromGallery();
                            },
                          ),
                        ],
                      ),
                    ));
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    color: AppColor().backgroundColor,
                    strokeWidth: _transactionController.image != null ? 0 : 2,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _transactionController.image != null
                            ? AppColor().backgroundColor.withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        // border: _transactionController.image != null
                        //     ? null
                        //     : Border.all(
                        //         width: 2, color: AppColor().backgroundColor)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Image.asset(
                                  'assets/images/image.png',
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: AutoSizeText(
                              _transactionController.image != null
                                  ? _transactionController.image!.path
                                      .toString()
                                  : 'Add any supporting image (Optional)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: _transactionController.image != null
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'DMSans'),
                            ),
                          ),
                          _transactionController.image != null
                              ? Expanded(
                                  child: SvgPicture.asset(
                                    'assets/images/edit.svg',
                                  ),
                                )
                              : Container(),
                          _transactionController.image != null
                              ? Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _transactionController.image = null;
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/delete.svg',
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Customer',
                      style: TextStyle(
                          color: _transactionController.addCustomer == true
                              ? AppColor().backgroundColor
                              : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DMSans'),
                    ),
                    Switch.adaptive(
                        activeColor: AppColor().backgroundColor,
                        value: _transactionController.addCustomer,
                        onChanged: (newValue) => setState(() =>
                            _transactionController.addCustomer = newValue))
                  ],
                ),
              ),
              _transactionController.addCustomer == true
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.03),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => setState(() =>
                                    _transactionController.customerType = 1),
                                child: Row(
                                  children: [
                                    Radio<int>(
                                        value: 1,
                                        activeColor: AppColor().backgroundColor,
                                        groupValue:
                                            _transactionController.customerType,
                                        onChanged: (value) => setState(() =>
                                            _transactionController
                                                .customerType = 1)),
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
                                onTap: () => setState(() =>
                                    _transactionController.customerType = 0),
                                child: Row(
                                  children: [
                                    Radio<int>(
                                        value: 0,
                                        activeColor: AppColor().backgroundColor,
                                        groupValue:
                                            _transactionController.customerType,
                                        onChanged: (value) => setState(() =>
                                            _transactionController
                                                .customerType = 0)),
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
                          _transactionController.customerType == 1
                              ? CustomTextFieldWithImageTransaction(
                                  contactName:
                                      _customerController.nameController,
                                  contactPhone:
                                      _customerController.phoneNumberController,
                                  contactMail:
                                      _customerController.emailController,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 2,
                                                color: AppColor()
                                                    .backgroundColor)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<Customer>(
                                            value: _transactionController
                                                .selectedCustomer,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: AppColor().backgroundColor,
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
                                              () => _transactionController
                                                  .selectedCustomer = value,
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Obx(() {
                return InkWell(
                  onTap: () {
                    if (_transactionController.addingTransactionStatus !=
                        AddingTransactionStatus.Loading) {
                      if (_transactionController.productList.isEmpty) {
                        _transactionController.addMoreProduct();
                      }
                      if (_transactionController.productList.isNotEmpty) {
                        if (_transactionController.selectedPaymentMode !=
                                null &&
                            _transactionController.selectedPaymentSource !=
                                null) {
                          if (_transactionController.addCustomer) {
                            if (_transactionController.selectedCustomer !=
                                    null ||
                                _customerController
                                        .nameController.text.isNotEmpty &&
                                    _customerController.phoneNumberController
                                        .text.isNotEmpty) {
                            } else {
                              Get.snackbar(
                                  "Error", "Fill up your contact details");
                              return;
                            }
                          }

                          //  _transactionController.createTransaction("INCOME");
                          _transactionController
                              .createBusinessTransaction("INCOME");
                        } else {
                          Get.snackbar(
                              "Error", "Fill up important information");
                        }
                      } else {
                        Get.snackbar("Error",
                            "You need to have at least one product to proceed");
                      }
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
                    child: (_transactionController.addingTransactionStatus ==
                            AddingTransactionStatus.Loading)
                        ? Container(
                            width: 30,
                            height: 30,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                          )
                        : Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'DMSans'),
                            ),
                          ),
                  ),
                );
              }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddNewItem() =>
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      myState(() {
                        _transactionController.selectedValue = 1;
                      });
                    },
                    child: Row(
                      children: [
                        Radio<int>(
                          value: 1,
                          activeColor: AppColor().backgroundColor,
                          groupValue: _transactionController.selectedValue,
                          onChanged: (value) {
                            myState(() {
                              _transactionController.selectedValue = 1;
                            });
                          },
                        ),
                        Text(
                          'Enter Item',
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
                    onTap: () {
                      myState(() {
                        _transactionController.selectedValue = 0;
                      });
                    },
                    child: Row(
                      children: [
                        Radio<int>(
                            value: 0,
                            activeColor: AppColor().backgroundColor,
                            groupValue: _transactionController.selectedValue,
                            onChanged: (value) {
                              myState(() {
                                value = 0;
                                _transactionController.selectedValue = 0;
                              });
                            }),
                        Text(
                          'Select Product',
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
              _transactionController.selectedValue == 1
                  ? CustomTextField(
                      label: 'Item Name',
                      hint: 'Television',
                      keyType: TextInputType.name,
                      validatorText: 'Item name is needed',
                      textEditingController:
                          _transactionController.itemNameController,
                    )
                  : Container(),
              _transactionController.selectedValue == 1
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "Amount",
                            hint: 'N 0.00',
                            validatorText: "Amount name is needed",
                            textEditingController:
                                _transactionController.amountController,
                            keyType: TextInputType.phone,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.height * 0.03),
                        Expanded(
                          child: CustomTextField(
                              label: "Quantity",
                              hint: '4',
                              keyType: TextInputType.phone,
                              validatorText: "Quantity name is needed",
                              textEditingController:
                                  _transactionController.quantityController),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _transactionController.selectedValue == 1
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Product',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'DMSans'),
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
                            child: DropdownButton<Product>(
                              value: _transactionController.selectedProduct,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColor().backgroundColor,
                              ),
                              iconSize: 30,
                              items:
                                  _productController.productGoods.map((value) {
                                return DropdownMenuItem<Product>(
                                  value: value,
                                  child: Text(value.productName!),
                                );
                              }).toList(),
                              onChanged: (value) => myState(() {
                                _transactionController.selectedProduct = value;
                                _transactionController
                                    .selectedProduct!.quantity = 1;
                                _transactionController.amountController.text =
                                    value!.sellingPrice!.toString();
                                _transactionController.quantityController.text =
                                    1.toString();
                              }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: "Amount",
                                hint: 'N 0.00',
                                onChanged: (value) {
                                  print("value is $value");
                                  setState(() {});
                                },
                                validatorText: "Amount is needed",
                                textEditingController:
                                    _transactionController.amountController,
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
                                  onChanged: (value) {
                                    print("value is $value");
                                    setState(() {});
                                  },
                                  keyType: TextInputType.phone,
                                  validatorText: "Quantity is needed",
                                  textEditingController: _transactionController
                                      .quantityController),
                            ),
                          ],
                        ),
                      ],
                    ),
              _transactionController.selectedValue == 1
                  ? Container()
                  : SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  _transactionController.addMoreProduct();
                  setState(() {});
                  Get.back();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Save',
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
      });

  DropdownMenuItem<String> buildPaymentItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 14, fontFamily: 'DMSans'),
        ),
      );

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

  Widget showAllItems() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: _transactionController.productList.length * 100,
        child: ListView.builder(
            itemCount: _transactionController.productList.length,
            itemBuilder: (context, index) => ItemCard(
                  item: _transactionController.productList[index],
                  onDelete: () {
                    var item = _transactionController.productList[index];
                    _transactionController.productList.remove(item);
                    if (_transactionController.productList.length == 1) {
                      _transactionController
                          .setValue(_transactionController.productList.first);
                    }
                    setState(() {});
                  },
                  onEdit: () {
                    _transactionController.selectEditValue(
                        _transactionController.productList[index]);

                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        context: context,
                        builder: (context) => buildEditItem(
                            _transactionController.productList[index], index));
                  },
                )));
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
                textEditingController:
                    _transactionController.itemNameController,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Amount",
                      hint: 'N 0.00',
                      validatorText: "Amount name is needed",
                      enabled:
                          item.productId == null || item.productId!.isEmpty,
                      textEditingController:
                          _transactionController.amountController,
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
                            _transactionController.quantityController),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  _transactionController.updatePaymetItem(item, index);
                  setState(() {});
                  Get.back();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Update',
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
      });
}
