import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';

import '../../../../colors.dart';
import 'productConfirm.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController textEditingController = TextEditingController();

  final items = [
    'Box',
    'feet',
    'kilogram',
    'meters',
  ];

  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor().whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor().whiteColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColor().backgroundColor,
          ),
        ),
        title: Text(
          "Add Product",
          style: TextStyle(
            color: AppColor().backgroundColor,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  context: context,
                  builder: (context) => buildAddImage()),
              child: Center(
                child: Image.asset(
                  'assets/images/Group 3647.png',
                  height: 50,
                  color: AppColor().backgroundColor,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                'Profile Picture',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'DMSans',
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              label: "Product name",
              validatorText: "Product name is needed",
              hint: 'E.g Television',
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 175,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Cost price',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: TextFormField(
                          controller: textEditingController,
                          textInputAction: TextInputAction.none,
                          decoration: InputDecoration(
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColor().backgroundColor,
                                    width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColor().backgroundColor,
                                    width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColor().backgroundColor,
                                    width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            hintText: 'N 0.00',
                            hintStyle:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      fontFamily: 'DMSans',
                                      color: Colors.black26,
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 175,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Selling price',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: TextFormField(
                          // onChanged: this.onChanged,
                          // maxLength: 6,
                          controller: textEditingController,
                          textInputAction: TextInputAction.none,
                          decoration: InputDecoration(
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColor().backgroundColor,
                                    width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColor().backgroundColor,
                                    width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColor().backgroundColor,
                                    width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            // labelText: label,
                            hintText: 'N 0.00',
                            hintStyle:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      fontFamily: 'DMSans',
                                      fontSize: 14,
                                      color: Colors.black26,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "*",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: AppColor().whiteColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 120,
                    child: TextFormField(
                      controller: textEditingController,
                      textInputAction: TextInputAction.none,
                      decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().backgroundColor, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        // labelText: label,
                        hintText: 'N 0.00',
                        hintStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontFamily: 'DMSans',
                                  color: Colors.black26,
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: AppColor().whiteColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Select Unit',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: AppColor().backgroundColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  focusColor: AppColor().whiteColor,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColor().backgroundColor,
                  ),
                  iconSize: 30,
                  hint: Text(
                    'Select product unit',
                    style: TextStyle(
                      color: Colors.black26,
                      fontFamily: 'DMSans',
                    ),
                  ),
                  items: items.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() => this.value = value),
                ),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.to(Confirmation());
              },
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppColor().whiteColor,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddImage() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 3,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Color(0xffE6F4F2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColor().backgroundColor,
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Upload Image',
              style: TextStyle(
                color: AppColor().blackColor,
                fontFamily: 'DMSans',
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/camera.png',
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                'Select from Device',
                style: TextStyle(
                  color: AppColor().blackColor,
                  fontFamily: 'DMSans',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Spacer(),
            Container(
              height: 55,
              margin: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                  color: AppColor().backgroundColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: AppColor().whiteColor,
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Color(0xffCFD1D2),
                ),
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffDCF2EF),
              ),
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      );
}
