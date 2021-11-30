import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';

import '../../../colors.dart';

class MoneyOut extends StatefulWidget {
  const MoneyOut({Key? key}) : super(key: key);

  @override
  _MoneyOutState createState() => _MoneyOutState();
}

class _MoneyOutState extends State<MoneyOut> {
  int selectedValue = 0;
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
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
                      label: "Select Date",
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.orange,
                      ),
                      validatorText: "Select date is needed",
                      keyType: TextInputType.phone,
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      label: "Select Time",
                      prefixIcon: Icon(
                        Icons.lock_clock,
                        color: Colors.orange,
                      ),
                      keyType: TextInputType.phone,
                      validatorText: "Select time is needed",
                    ),
                  ),
                ],
              ),
              CustomTextField(
                label: "Customer's Name",
                validatorText: "Item name is needed",
                hint: 'Enter your customer`s name',
              ),
              CustomTextField(
                label: "Email",
                validatorText: "Item name is needed",
                hint: 'yourmail@mail.com',
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
}
