import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/transaction_respository.dart';
import 'package:huzz/app/Utils/constants.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/business.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:number_display/number_display.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final item = ['Huzz Technologies', 'Huzz Company', 'Huzz Infotech'];
  final _business=Get.find<BusinessRespository>();
  final _transactionController=Get.find<TransactionRespository>();
  String? value;
  final display=createDisplay(
  length: 8,
  decimal: 0,
);
@override
 void onInit(){


}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  (){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 250,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColor().backgroundColor,
                              width: 2,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Business>(
                              value: _business.selectedBusiness.value,
                              
                              iconSize: 30,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColor().backgroundColor,
                              ),
                              items: _business.offlineBusiness.map((e)=>buildMenuItem(e.business!)).toList(),
                              onChanged: (value) =>
                                  _business.selectedBusiness(value),
                            ),
                          ),
                        ),
                        Container(),
                        Icon(
                          Icons.notifications_none,
                          color: AppColor().backgroundColor,
                          size: 25,
                        ),
                        Icon(
                          Icons.settings_outlined,
                          color: AppColor().backgroundColor,
                          size: 25,
                        ),
                      ],
                    );
                  }
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () {
                    return Container(
                      padding: EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/images/Group 3505.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColor().whiteColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "Today’s BALANCE",
                                        style: TextStyle(
                                          color: AppColor().blackColor,
                                          fontFamily: 'DMSans',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "N${display(_transactionController.totalbalance.value)}",
                                      style: TextStyle(
                                        color: AppColor().whiteColor,
                                        fontFamily: 'DMSans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Color(0xff056B5C),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "See all your Records",
                                            style: TextStyle(
                                              color: AppColor().whiteColor,
                                              fontFamily: 'DMSans',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_outlined,
                                            color: AppColor().whiteColor,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Color(0xff016BCC),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.exit_to_app,
                                            color: AppColor().whiteColor,
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Today’s Money IN",
                                            style: TextStyle(
                                              color: AppColor().whiteColor,
                                              fontFamily: 'DMSans',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "N${display(_transactionController.income.value)}",
                                      style: TextStyle(
                                        color: AppColor().whiteColor,
                                        fontFamily: 'DMSans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Color(0xffDD8F48),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.exit_to_app,
                                            color: AppColor().whiteColor,
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Today’s Money Out",
                                            style: TextStyle(
                                              color: AppColor().whiteColor,
                                              fontFamily: 'DMSans',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "N${display(_transactionController.expenses.value)}",
                                      style: TextStyle(
                                        color: AppColor().whiteColor,
                                        fontFamily: 'DMSans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height / 4.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage("assets/images/Rectangle 78.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xffDCF2EF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffEF6500),
                            ),
                            child: Icon(
                              // CupertinoIcons.person_add,
                              Icons.person_add_alt,
                              color: AppColor().whiteColor,
                              size: 16,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Debtors',
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'DMSans',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'N${display(_transactionController.debtors.value)}',
                            style: TextStyle(
                              color: Color(0xffEF6500),
                              fontFamily: 'DMSans',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Color(0xffEF6500),
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Expanded(
                      child: Container(
                       
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xffC3C3C3).withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child:History()
                        // ListView.builder(
                        //     scrollDirection: Axis.vertical,
                        //     itemCount: 5,
                        //     itemBuilder: (BuildContext context, index) {
                        //       return History();
                        //     }),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      left: 200,
                      right: 5,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xff07A58E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: AppColor().whiteColor,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Add Transaction",
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontFamily: 'DMSans',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<Business> buildMenuItem(Business item) => DropdownMenuItem(
        value: item,
        child: Text(
          item.businessName!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      );
}

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final _transactionController=Get.find<TransactionRespository>();

  Widget transactionItem(PaymentItem item){

    return Column(
       children: [
         Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.arrow_downward,
                      color: Color(0xff0065D3),
                      size: 18,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.itemName!,
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 180,
                              ),
                              Text(
                                'N ${item.totalAmount}',
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                               item.createdTime!.formatDate()!,
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              Text(
                                'FULLY PAID',
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
                   SizedBox(
            height: 5,
          ),
          Divider(
            thickness: 2,
            color: Color(0xffE0E1E2),
          ),
       ],
     );
     
  }
  @override
  Widget build(BuildContext context) {
    return Obx(()
     {
       if(_transactionController.allPaymentItem.isNotEmpty){

        return Container(

          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _transactionController.allPaymentItem.map((e) => transactionItem(e)).toList()
          ),
        );
      
     }else{

    return Container(
    
    child:Center(
    
      child:Text("No Transaction Available",style:TextStyle(color:Colors.grey))
    )
    );


     }
     }
    );
  }
}
