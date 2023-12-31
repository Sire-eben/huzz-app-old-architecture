import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/data/repository/transaction_respository.dart';
import 'package:huzz/generated/assets.gen.dart';
import 'package:huzz/ui/widget/custom_form_field.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:huzz/data/model/payment_item.dart';
import 'package:huzz/data/model/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:huzz/core/util/util.dart';
import 'itemCard.dart';

class MoneyInInformationDialog extends StatelessWidget {
  const MoneyInInformationDialog({super.key});

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
          'This is where you can log your income for a product sold or service rendered.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class MoneyIn extends StatefulWidget {
  const MoneyIn({super.key});

  @override
  _MoneyInState createState() => _MoneyInState();
}

class _MoneyInState extends State<MoneyIn> {
  final ScrollController _scrollController = ScrollController();
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

  final paymentMode = ['Yes', 'No'];
  final products = ['Shoe', 'Bag', 'Clothes'];
  final customers = ['Customer 1', 'Customer 2', 'Customer 3'];
  final paymentSource = ["Cash", "POS", "Transfer"];

  String? value, paidInFullValue, value1, paymentSourceValue;

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
      setState(
        () {
          _transactionController.image = imageTemporary;
        },
      );
    } on PlatformException catch (e) {}
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(
        () {
          _transactionController.image = imageTemporary;
        },
      );
    } on PlatformException catch (e) {}
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: _transactionController.date ?? initialDate,
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
      initialTime: _transactionController.time ?? initialTime,
    );

    if (newTime == null) return;

    setState(() {
      _transactionController.time = newTime;
      _transactionController.timeController.text =
          '${_transactionController.time!.hour.toString().padLeft(2, '0')}:${_transactionController.time!.minute.toString().padLeft(2, '0')} ${_transactionController.time!.period.index == 0 ? am : pm}';
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
              'Money In',
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
                          content: const MoneyInInformationDialog(),
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
                          content: const MoneyInInformationDialog(),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(
          Insets.lg,
          0,
          Insets.lg,
          Insets.lg,
        ),
        child: Scrollbar(
          trackVisibility: false,
          controller: _scrollController,
          child: ListView(
            children: [
              (_transactionController.productList.length < 2)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            _transactionController.amountController!.text = "";
                            _transactionController.itemNameController.text = "";
                            _transactionController.selectedProduct = null;
                            setState(
                                () => _transactionController.selectedValue = 1);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Radio<int>(
                                  value: 1,
                                  activeColor: AppColors.backgroundColor,
                                  groupValue:
                                      _transactionController.selectedValue,
                                  onChanged: (value) {
                                    _transactionController
                                        .amountController!.text = "";
                                    _transactionController
                                        .itemNameController.text = "";
                                    _transactionController.selectedProduct =
                                        null;
                                    setState(() => _transactionController
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
                            _transactionController.amountController!.text = "";
                            _transactionController.itemNameController.text = "";
                            _transactionController.selectedProduct = null;
                            setState(
                                () => _transactionController.selectedValue = 0);
                          },
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 0,
                                  activeColor: AppColors.backgroundColor,
                                  groupValue:
                                      _transactionController.selectedValue,
                                  onChanged: (value) {
                                    _transactionController
                                        .amountController!.text = "";
                                    _transactionController
                                        .itemNameController.text = "";
                                    _transactionController.selectedProduct =
                                        null;
                                    setState(() => _transactionController
                                        .selectedValue = 0);
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
                      ],
                    )
                  : Container(),
              (_transactionController.productList.length < 2)
                  ? _transactionController.selectedValue == 1
                      ? Column(
                          children: [
                            CustomTextField(
                              label: "Item Name",
                              onChanged: (value) {
                                setState(() {});
                              },
                              validatorText: "Item name is needed",
                              textEditingController:
                                  _transactionController.itemNameController,
                              hint: 'E.g. Television',
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: "Amount",
                                    hint: '${Utils.getCurrency()}0.00',
                                    validatorText: "Amount is needed",
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    textEditingController:
                                        _transactionController
                                            .amountController!,
                                    inputformater: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyType: Platform.isIOS
                                        ? const TextInputType.numberWithOptions(
                                            signed: true, decimal: true)
                                        : TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.03),
                                Expanded(
                                  child: CustomTextField(
                                      label: "Quantity",
                                      hint: '1',
                                      inputformater: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyType: Platform.isIOS
                                          ? const TextInputType
                                                  .numberWithOptions(
                                              signed: true, decimal: true)
                                          : TextInputType.number,
                                      validatorText: "Quantity is needed",
                                      onChanged: (value) {
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
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Select product/services',
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
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 2,
                                      color: AppColors.backgroundColor)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<Product>(
                                  value: _transactionController.selectedProduct,
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
                                  onChanged: (value) => setState(() {
                                    _transactionController.selectedProduct =
                                        value;
                                    _transactionController
                                        .selectedProduct!.quantity = 1;
                                    _transactionController.amountController!
                                        .text = value!.sellingPrice!.toString();
                                    _transactionController
                                        .quantityController.text = 1.toString();
                                  }),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: "Amount",
                                    hint: '${Utils.getCurrency()}0.00',
                                    validatorText: "Amount is needed",
                                    textEditingController:
                                        _transactionController
                                            .amountController!,
                                    inputformater: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyType: Platform.isIOS
                                        ? const TextInputType.numberWithOptions(
                                            signed: true, decimal: true)
                                        : TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.03),
                                Expanded(
                                  child: CustomTextField(
                                      label: "Quantity",
                                      hint: '1',
                                      inputformater: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyType: Platform.isIOS
                                          ? const TextInputType
                                                  .numberWithOptions(
                                              signed: true, decimal: true)
                                          : TextInputType.number,
                                      validatorText: "Quantity is needed",
                                      onChanged: (value) {
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
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: (_transactionController
                                      .productList.length >=
                                  2 ||
                              _transactionController.selectedProduct != null ||
                              _transactionController
                                      .itemNameController.text.isNotEmpty &&
                                  _transactionController
                                      .quantityController.text.isNotEmpty &&
                                  _transactionController
                                      .amountController!.text.isNotEmpty)
                          ? AppColors.backgroundColor
                          : AppColors.backgroundColor.withOpacity(0.3),
                    ),
                    onPressed: () {
                      if (_transactionController.productList.length >= 2 ||
                          _transactionController.selectedProduct != null ||
                          _transactionController
                                  .itemNameController.text.isNotEmpty &&
                              _transactionController
                                  .amountController!.text.isNotEmpty) {
                        if (_transactionController.productList.isEmpty) {
                          _transactionController.addMoreProduct();
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
                    icon: LocalSvgIcon(
                      Assets.icons.linear.add,
                      color: AppColors.whiteColor,
                    ),
                    label: const Text("Add another item")),
              ),
              const Gap(Insets.sm),
              Row(
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
                        icon: const Icon(Icons.calendar_today),
                        color: Colors.orange,
                      ),
                      // validatorText: "Select date is needed",
                      inputformater: [FilteringTextInputFormatter.digitsOnly],
                      keyType: Platform.isIOS
                          ? const TextInputType.numberWithOptions(
                              signed: true, decimal: true)
                          : TextInputType.number,
                    ),
                  ),
                  const Gap(Insets.lg),
                  Expanded(
                    child: CustomTextField(
                      enabled: false,
                      AllowClickable: true,
                      textEditingController:
                          _transactionController.timeController,
                      label: "Select Time",
                      hint: 'Select Time',
                      onClick: () {
                        pickTime(context);
                      },
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.lock_clock),
                        color: Colors.orange,
                      ),
                      inputformater: [FilteringTextInputFormatter.digitsOnly],
                      keyType: Platform.isIOS
                          ? const TextInputType.numberWithOptions(
                              signed: true, decimal: true)
                          : TextInputType.number,
                      // validatorText: "Select time is needed",
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Paid in full?',
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 2, color: AppColors.backgroundColor)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          value: _transactionController.valuePaymentMode,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.backgroundColor,
                          ),
                          iconSize: 30,
                          items: paymentMode.map(buildPaymentItem).toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value == 'Yes') {
                                paidInFullValue = 'FULLY_PAID';
                              } else {
                                paidInFullValue = 'DEPOSIT';
                              }
                              _transactionController.valuePaymentMode = value;
                              _transactionController.selectedPaymentMode =
                                  paidInFullValue;
                            });
                          }),
                    ),
                  ),
                ],
              ),
              (_transactionController.selectedPaymentMode != null &&
                      _transactionController.selectedPaymentMode == "DEPOSIT")
                  ? CustomTextField(
                      label: "Amount Paid",
                      hint: '${Utils.getCurrency()} 0.00',
                      validatorText: "Amount Paid is needed",
                      inputformater: [FilteringTextInputFormatter.digitsOnly],
                      keyType: Platform.isIOS
                          ? const TextInputType.numberWithOptions(
                              signed: true, decimal: true)
                          : TextInputType.number,
                      textEditingController:
                          _transactionController.amountPaidController,
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Payment Mode',
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 2, color: AppColors.backgroundColor)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _transactionController.selectedPaymentSource,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.backgroundColor,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  Get.bottomSheet(Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.camera,
                            color: AppColors.backgroundColor,
                          ),
                          title: const Text('Camera'),
                          onTap: () {
                            Get.back();
                            pickImageFromCamera();
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.image,
                            color: AppColors.backgroundColor,
                          ),
                          title: const Text('Gallery'),
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
                  radius: const Radius.circular(10),
                  color: AppColors.backgroundColor,
                  strokeWidth: _transactionController.image != null ? 0 : 2,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _transactionController.image != null
                          ? AppColors.backgroundColor.withOpacity(0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      // border: _transactionController.image != null
                      //     ? null
                      //     : Border.all(
                      //         width: 2, color: AppColors.backgroundColor)
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
                                ? _transactionController.image!.path.toString()
                                : 'Add any supporting image (Optional)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: _transactionController.image != null
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Customer',
                    style: GoogleFonts.inter(
                      color: _transactionController.addCustomer == true
                          ? AppColors.backgroundColor
                          : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch.adaptive(
                      activeColor: AppColors.backgroundColor,
                      value: _transactionController.addCustomer,
                      onChanged: (newValue) => setState(
                          () => _transactionController.addCustomer = newValue))
                ],
              ),
              _transactionController.addCustomer == true
                  ? Column(
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
                                      activeColor: AppColors.backgroundColor,
                                      groupValue:
                                          _transactionController.customerType,
                                      onChanged: (value) => setState(() =>
                                          _transactionController.customerType =
                                              1)),
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
                            InkWell(
                              onTap: () => setState(() =>
                                  _transactionController.customerType = 0),
                              child: Row(
                                children: [
                                  Radio<int>(
                                      value: 0,
                                      activeColor: AppColors.backgroundColor,
                                      groupValue:
                                          _transactionController.customerType,
                                      onChanged: (value) => setState(() =>
                                          _transactionController.customerType =
                                              0)),
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
                        _transactionController.customerType == 1
                            ? CustomTextFieldWithImageTransaction(
                                contactName: _customerController.nameController,
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
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 2,
                                              color:
                                                  AppColors.backgroundColor)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<Customer>(
                                          value: _transactionController
                                              .selectedCustomer,
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
                                            () => _transactionController
                                                .selectedCustomer = value,
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                      ],
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Obx(
                () {
                  return Button(
                    label: "Save",
                    action: () {
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
                    showLoading:
                        (_transactionController.addingTransactionStatus ==
                                AddingTransactionStatus.Loading)
                            ? true
                            : false,
                  );
                },
              ),
              const Gap(Insets.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddNewItem() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
            ),
            padding: MediaQuery.of(context).viewInsets,
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
                          _transactionController.selectedValue = 1;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<int>(
                            value: 1,
                            activeColor: AppColors.backgroundColor,
                            groupValue: _transactionController.selectedValue,
                            onChanged: (value) {
                              myState(() {
                                _transactionController.selectedValue = 1;
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
                          _transactionController.selectedValue = 0;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<int>(
                              value: 0,
                              activeColor: AppColors.backgroundColor,
                              groupValue: _transactionController.selectedValue,
                              onChanged: (value) {
                                myState(() {
                                  value = 0;
                                  _transactionController.selectedValue = 0;
                                });
                              }),
                          Text(
                            'Select product/services',
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
                              hint: '${Utils.getCurrency()}0.00',
                              validatorText: "Amount name is needed",
                              textEditingController:
                                  _transactionController.amountController!,
                              inputformater: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyType: Platform.isIOS
                                  ? const TextInputType.numberWithOptions(
                                      signed: true, decimal: true)
                                  : TextInputType.number,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.height * 0.03),
                          Expanded(
                            child: CustomTextField(
                                label: "Quantity",
                                hint: '1',
                                inputformater: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyType: Platform.isIOS
                                    ? const TextInputType.numberWithOptions(
                                        signed: true, decimal: true)
                                    : TextInputType.number,
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
                            'Select Item',
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
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 2,
                                    color: AppColors.backgroundColor)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Product>(
                                value: _transactionController.selectedProduct,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.backgroundColor,
                                ),
                                iconSize: 30,
                                items: _productController.offlineBusinessProduct
                                    .map((value) {
                                  return DropdownMenuItem<Product>(
                                    value: value,
                                    child: Text(value.productName!),
                                  );
                                }).toList(),
                                onChanged: (value) => myState(() {
                                  _transactionController.selectedProduct =
                                      value;
                                  _transactionController
                                      .selectedProduct!.quantity = 1;
                                  _transactionController.amountController!
                                      .text = value!.sellingPrice!.toString();
                                  _transactionController
                                      .quantityController.text = 1.toString();
                                }),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: "Amount",
                                  hint: '${Utils.getCurrency()}0.00',
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  validatorText: "Amount is needed",
                                  textEditingController:
                                      _transactionController.amountController!,
                                  inputformater: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyType: Platform.isIOS
                                      ? const TextInputType.numberWithOptions(
                                          signed: true, decimal: true)
                                      : TextInputType.number,
                                ),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.height *
                                      0.03),
                              Expanded(
                                child: CustomTextField(
                                    label: "Quantity",
                                    hint: '1',
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    inputformater: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyType: Platform.isIOS
                                        ? const TextInputType.numberWithOptions(
                                            signed: true, decimal: true)
                                        : TextInputType.number,
                                    validatorText: "Quantity is needed",
                                    textEditingController:
                                        _transactionController
                                            .quantityController),
                              ),
                            ],
                          ),
                        ],
                      ),
                _transactionController.selectedValue == 1
                    ? Container()
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02),
                Button(
                  action: () {
                    _transactionController.addMoreProduct();
                    setState(() {});
                    Get.back();
                  },
                  // showLoading: ,
                  label: "Save",
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                )
              ],
            ),
          ),
        );
      });

  DropdownMenuItem<String> buildPaymentItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
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
      },
    );
  }

  Widget showAllItems() {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        height: _transactionController.productList.length * 80,
        child: Scrollbar(
          controller: _scrollController,
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
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) => buildEditItem(
                              _transactionController.productList[index],
                              index));
                    },
                  )),
        ));
  }

  Widget buildEditItem(PaymentItem item, int index) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return SingleChildScrollView(
          child: Container(
            padding: MediaQuery.of(context).viewInsets,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
            ),
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
                        hint: '${Utils.getCurrency()}0.00',
                        validatorText: "Amount name is needed",
                        enabled:
                            item.productId == null || item.productId!.isEmpty,
                        textEditingController:
                            _transactionController.amountController!,
                        inputformater: [FilteringTextInputFormatter.digitsOnly],
                        keyType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                signed: true, decimal: true)
                            : TextInputType.number,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.03),
                    Expanded(
                      child: CustomTextField(
                          label: "Quantity",
                          hint: '1',
                          inputformater: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyType: Platform.isIOS
                              ? const TextInputType.numberWithOptions(
                                  signed: true, decimal: true)
                              : TextInputType.number,
                          validatorText: "Quantity name is needed",
                          textEditingController:
                              _transactionController.quantityController),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Button(
                  action: () {
                    _transactionController.updatePaymetItem(item, index);
                    setState(() {});
                    Get.back();
                  },
                  label: 'Update',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                )
              ],
            ),
          ),
        );
      });
}
