import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/create_business.dart';
import 'package:huzz/app/screens/home/money_in.dart';
import 'package:huzz/app/screens/home/money_out.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/transaction_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final items = ['Huzz Technologies', 'Huzz', 'Technologies'];
  String? value;
  int selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 3, color: AppColor().backgroundColor)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        onTap: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              context: context,
                              builder: (context) => buildSelectBusiness());
                        },
                        value: value,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor().backgroundColor,
                        ),
                        iconSize: 30,
                        items: items.map(buildMenuItem).toList(),
                        onChanged: (value) {
                          setState(() {
                            this.value = value;
                          });
                        }),
                  ),
                ),
                Container(
                    child: Row(
                  children: [
                    Image.asset('assets/images/bell.png'),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Image.asset('assets/images/settings.png')
                  ],
                )),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
              decoration: BoxDecoration(
                  color: AppColor().backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage('assets/images/home_rectangle.png'),
                      fit: BoxFit.fill)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Today’s BALANCE',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      Text(
                        'N27,000',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Color(0xff056B5C),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Text(
                              'See all your Records',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.white,
                                  fontFamily: 'DMSans'),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 15,
                              color: Colors.white,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Color(0xff0065D3),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Image.asset('assets/images/money_in.png'),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            Text(
                              'Today’s Money IN',
                              style:
                                  TextStyle(fontSize: 9, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'N7,000',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Color(0xffF58D40),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Image.asset('assets/images/money_out.png'),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            Text(
                              'Today’s Money OUT',
                              style:
                                  TextStyle(fontSize: 9, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'N3,500',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                color: AppColor().backgroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.08,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/debtors.png'))),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Text(
                        'Debtors',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'N10,000',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xffF58D40),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Color(0xffF58D40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.02,
                  right: MediaQuery.of(context).size.height * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (transactionList.length == 0) {
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
                              SvgPicture.asset(
                                  'assets/images/empty_transaction.svg'),
                              Text(
                                'Record a transaction',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Your recent transactions will show here. Click the',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                    fontFamily: 'DMSans'),
                              ),
                              Text(
                                'Add transaction button to record your first transaction',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(transactionList[index].image!),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transactionList[index].name!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    transactionList[index].date!,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transactionList[index].amount!,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                transactionList[index].details!,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: transactionList.length),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            context: context,
            builder: (context) => buildAddTransaction()),
        icon: Icon(Icons.add),
        backgroundColor: AppColor().backgroundColor,
        label: Text(
          'Add transaction',
          style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildAddTransaction() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 8,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(4)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      Get.to(() => MoneyOut());
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Color(0xffEF6500),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/moneyRound_out.png'),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Text(
                                'Money OUT',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Text(
                            'Click here to record an expense',
                            style: TextStyle(fontSize: 7, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      Get.to(() => MoneyIn());
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Color(0xff0065D3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/moneyRound_in.png'),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Text(
                                'Money IN',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Text(
                            'Click here to record an income',
                            style: TextStyle(fontSize: 7, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );

  Widget buildSelectBusiness() => Container(
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
                  color: Colors.black, borderRadius: BorderRadius.circular(4)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              children: [
                Expanded(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff00E13F)),
                      child: Center(
                          child: Text(
                        'H',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold),
                      ))),
                )),
                Expanded(
                    flex: 2,
                    child: Text(
                      'Huzz Technologies',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Radio<int>(
                      value: 1,
                      activeColor: AppColor().backgroundColor,
                      groupValue: selectedValue,
                      onChanged: (value) => setState(() => selectedValue = 1)),
                )),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              children: [
                Expanded(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.brown),
                      child: Center(
                          child: Text(
                        'T',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold),
                      ))),
                )),
                Expanded(
                    flex: 2,
                    child: Text(
                      'Tade Technologies',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Radio<int>(
                      value: 1,
                      activeColor: AppColor().backgroundColor,
                      groupValue: selectedValue,
                      onChanged: (value) => setState(() => selectedValue = 1)),
                )),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            InkWell(
              onTap: () {
                Get.to(() => CreateBusiness());
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.02),
                    Text(
                      'Add New',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'DMSans'),
                    ),
                  ],
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
}
