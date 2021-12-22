import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/inventory/Service/servicelist.dart';
import 'package:huzz/app/screens/widget/custom_form_field.dart';
import 'package:huzz/model/debtors_model.dart';
import 'package:number_display/number_display.dart';

import '../../../../colors.dart';

class DebtOwned extends StatefulWidget {
  const DebtOwned({Key? key}) : super(key: key);

  @override
  _DebtOwnedState createState() => _DebtOwnedState();
}

class _DebtOwnedState extends State<DebtOwned> {
  TextEditingController amountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController mountController = TextEditingController();

  final debtStatus = ['Pending', 'Fully Paid'];

  int statusType = 0;
  String? value;

  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(width: 2, color: AppColor().backgroundColor)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 14,
                    color: AppColor().backgroundColor,
                  ),
                  hint: Text(
                    'Pending',
                    style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  isDense: true,
                  items: debtStatus.map(buildDropDown).toList(),
                  onChanged: (value) => setState(() => this.value = value),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.02,
                    right: MediaQuery.of(context).size.height * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.02),
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: debtOwnedList.length,
                  itemBuilder: (context, index) {
                    if (debtOwnedList.length == 0) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.height * 0.02,
                            bottom: MediaQuery.of(context).size.height * 0.02),
                        decoration: BoxDecoration(
                          color: Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/images/debtors.svg'),
                              Text(
                                'Add Debtors',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Your debtors will show here. Click the ',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                    fontFamily: 'DMSans'),
                              ),
                              Text(
                                'New Debtors button to add your first debtor',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                    fontFamily: 'DMSans'),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Row(
                        children: [
                          Image.asset(debtOwnedList[index].image!),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    debtOwnedList[index].name!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'DMSans',
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    debtOwnedList[index].phone!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'DMSans',
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bal: ${debtorsList[index].balance!}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'DMSans',
                                        color: AppColor().orangeBorderColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "Paid: ${debtorsList[index].paid!}",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'DMSans',
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  print(index);
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => buildUpdatePayment(
                                          debtOwnedList[index]));
                                },
                                child: SvgPicture.asset(
                                    'assets/images/edit_pri.svg')),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Get.to(ServiceListing());
              },
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 22,
                      color: AppColor().whiteColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Center(
                      child: Text(
                        'Add New Debt Owed',
                        style: TextStyle(
                          color: AppColor().whiteColor,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUpdatePayment(DebtOwnedModel debtOwnedModel) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        ScrollController? controller;
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            controller: controller,
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
                          statusType = 1;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<int>(
                            value: 1,
                            activeColor: AppColor().backgroundColor,
                            groupValue: statusType,
                            onChanged: (value) {
                              myState(() {
                                statusType = 1;
                              });
                            },
                          ),
                          Text(
                            'Paying Fully',
                            style: TextStyle(
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
                          statusType = 0;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<int>(
                              value: 0,
                              activeColor: AppColor().backgroundColor,
                              groupValue: statusType,
                              onChanged: (value) {
                                myState(() {
                                  value = 0;
                                  statusType = 0;
                                });
                              }),
                          Text(
                            'Paying Partly',
                            style: TextStyle(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    statusType == 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Bal: ',
                                style: TextStyle(
                                  fontFamily: "DMSans",
                                  color: AppColor().orangeBorderColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                debtOwnedModel.balance!,
                                style: TextStyle(
                                  fontFamily: "DMSans",
                                  color: AppColor().orangeBorderColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    CustomTextField(
                      enabled: true,
                      label: 'Amount',
                      hint: 'N20,000',
                      keyType: TextInputType.phone,
                      validatorText: 'amount is needed',
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                InkWell(
                  onTap: () {
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
          ),
        );
      });

  DropdownMenuItem<String> buildDropDown(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );
}
