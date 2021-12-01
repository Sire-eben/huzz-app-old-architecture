import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/customer_model.dart';

import 'add_customer.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final _searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                child: Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.02,
                  right: MediaQuery.of(context).size.height * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.02),
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(),
                itemCount: customerList.length,
                itemBuilder: (context, index) {
                  if (customerList.length == 0) {
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
                      children: [
                        Image.asset(customerList[index].image!),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customerList[index].name!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'DMSans',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  customerList[index].phone!,
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
                          child: SvgPicture.asset('assets/images/edit.svg'),
                        ),
                        Expanded(
                          child: SvgPicture.asset('assets/images/delete.svg'),
                        ),
                      ],
                    );
                  }
                },
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddCustomer());
        },
        icon: Icon(Icons.add),
        backgroundColor: AppColor().backgroundColor,
        label: Text(
          'Add Customer',
          style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
