import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../colors.dart';
import 'income_success.dart';

class MoneyOut extends StatefulWidget {
  const MoneyOut({Key? key}) : super(key: key);

  @override
  _MoneyOutState createState() => _MoneyOutState();
}

class _MoneyOutState extends State<MoneyOut> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController contactName = TextEditingController();
  final TextEditingController contactPhone = TextEditingController();
  final TextEditingController contactMail = TextEditingController();
  final payments = ['Select payment mode', 'item1', 'item2'];

  String? value;
  int selectedValue = 0;
  int customerType = 0;
  String countryFlag = "NG";
  String countryCode = "234";
  String am = 'AM';
  String pm = "PM";
  bool addCustomer = true;
  DateTime? date;
  TimeOfDay? time;
  File? image;

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      print(imageTemporary);
      setState(
        () {
          this.image = imageTemporary;
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
          this.image = imageTemporary;
        },
      );
    } on PlatformException catch (e) {
      print('$e');
    }
  }

  @override
  void initState() {
    dateController.text =
        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
    super.initState();
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      dateController.text = DateFormat("yyyy-MM-dd").format(newDate).toString();
      print(dateController.text);
    });
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );

    if (newTime == null) return;

    setState(() {
      time = newTime;
      timeController.text =
          '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')} ${time!.period.index == 0 ? am : pm}';
      print(timeController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Money Out',
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => setState(() => selectedValue = 1),
                      child: Row(
                        children: [
                          Radio<int>(
                              value: 1,
                              activeColor: AppColor().backgroundColor,
                              groupValue: selectedValue,
                              onChanged: (value) =>
                                  setState(() => selectedValue = 1)),
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
                      onTap: () => setState(() => selectedValue = 0),
                      child: Row(
                        children: [
                          Radio<int>(
                              value: 0,
                              activeColor: AppColor().backgroundColor,
                              groupValue: selectedValue,
                              onChanged: (value) =>
                                  setState(() => selectedValue = 0)),
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
              ),
              selectedValue == 1
                  ? Column(
                      children: [
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
                                hint: 'N 0.00',
                                validatorText: "Amount name is needed",
                                keyType: TextInputType.phone,
                              ),
                            ),
                            Expanded(
                              child: CustomTextField(
                                label: "Quantity",
                                hint: '4',
                                keyType: TextInputType.phone,
                                validatorText: "Quantity name is needed",
                              ),
                            ),
                          ],
                        ),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 2,
                                    color: AppColor().backgroundColor)),
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
                      ),
                    ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                      color: selectedValue == 1
                          ? AppColor().backgroundColor
                          : AppColor().backgroundColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(45)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
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
                    child: CustomTextField(
                      textEditingController: dateController,
                      label: "Select Date",
                      hint: 'Select Date',
                      prefixIcon: IconButton(
                        onPressed: () {
                          pickDate(context);
                        },
                        icon: Icon(Icons.calendar_today),
                        color: Colors.orange,
                      ),
                      validatorText: "Select date is needed",
                      keyType: TextInputType.phone,
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      textEditingController: timeController,
                      label: "Select Time",
                      hint: 'Select Time',
                      prefixIcon: IconButton(
                        onPressed: () {
                          pickTime(context);
                        },
                        icon: Icon(Icons.lock_clock),
                        color: Colors.orange,
                      ),
                      keyType: TextInputType.phone,
                      validatorText: "Select time is needed",
                    ),
                  ),
                ],
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
                          'Expense Category',
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
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: image != null
                            ? AppColor().backgroundColor.withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: image != null
                            ? null
                            : Border.all(
                                width: 2, color: AppColor().backgroundColor)),
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
                            image != null
                                ? image!.path.toString()
                                : 'Add any supporting image (Optional)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color:
                                    image != null ? Colors.black : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'DMSans'),
                          ),
                        ),
                        image != null
                            ? Expanded(
                                child: SvgPicture.asset(
                                  'assets/images/edit.svg',
                                ),
                              )
                            : Container(),
                        image != null
                            ? Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      image = null;
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Customer',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DMSans'),
                    ),
                    Switch.adaptive(
                        activeColor: AppColor().backgroundColor,
                        value: addCustomer,
                        onChanged: (newValue) =>
                            setState(() => this.addCustomer = newValue))
                  ],
                ),
              ),
              addCustomer == true
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
                                onTap: () => setState(() => customerType = 1),
                                child: Row(
                                  children: [
                                    Radio<int>(
                                        value: 1,
                                        activeColor: AppColor().backgroundColor,
                                        groupValue: customerType,
                                        onChanged: (value) =>
                                            setState(() => customerType = 1)),
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
                                onTap: () => setState(() => customerType = 0),
                                child: Row(
                                  children: [
                                    Radio<int>(
                                        value: 0,
                                        activeColor: AppColor().backgroundColor,
                                        groupValue: customerType,
                                        onChanged: (value) =>
                                            setState(() => customerType = 0)),
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
                          customerType == 1
                              ? CustomTextFieldWithImageTransaction(
                                  contactName: contactName,
                                  contactPhone: contactPhone,
                                  contactMail: contactMail,
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
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 2,
                                              color:
                                                  AppColor().backgroundColor)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: value,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: AppColor().backgroundColor,
                                          ),
                                          iconSize: 30,
                                          items: payments
                                              .map(buildPaymentItem)
                                              .toList(),
                                          onChanged: (value) => setState(
                                              () => this.value = value),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  Get.to(() => IncomeSuccess());
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
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'DMSans'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildPaymentItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 14, fontFamily: 'DMSans'),
        ),
      );
}