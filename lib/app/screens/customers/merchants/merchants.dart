import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/app/screens/customers/merchants/add_merchant.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/merchant_model.dart';
import 'package:random_color/random_color.dart';

class Merchants extends StatefulWidget {
  final String? pageName;
  const Merchants({Key? key, this.pageName}) : super(key: key);

  @override
  _MerchantsState createState() => _MerchantsState();
}

class _MerchantsState extends State<Merchants> {
  final _searchcontroller = TextEditingController();
  RandomColor _randomColor = RandomColor();
  final _customerController = Get.find<CustomerRepository>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return Container(
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
                  hintText: 'Search Merchant',
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
                child: (_customerController.customerMerchant.isNotEmpty)
                    ? ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: _customerController.customerMerchant.length,
                        itemBuilder: (context, index) {
                          var item =
                              _customerController.customerMerchant[index];
                          return Row(
                            children: [
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.only(bottom: 10),
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
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                            fontFamily: 'DMSans',
                                            fontWeight: FontWeight.bold),
                                      ))),
                                ),
                              )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'DMSans',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        item.phone!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'DMSans',
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _customerController.setItem(item);
                                    Get.to(AddMerchant(
                                      item: item,
                                    ));
                                  },
                                  child: SvgPicture.asset(
                                      'assets/images/edit.svg')),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _customerController
                                        .deleteBusinessCustomer(item);
                                  },
                                  child: SvgPicture.asset(
                                      'assets/images/delete.svg')),
                            ],
                          );
                        },
                      )
                    : Container(
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
                              SvgPicture.asset('assets/images/customers.svg'),
                              Text(
                                'Customers',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'DMSans',
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Your customers will show here. Click the',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                    fontFamily: 'DMSans'),
                              ),
                              Text(
                                'Add customer button to add your first customer',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                    fontFamily: 'DMSans'),
                              ),
                            ],
                          ),
                        ),
                      ),
              ))
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddMerchant());
        },
        icon: Icon(Icons.add),
        backgroundColor: AppColor().backgroundColor,
        label: Text(
          'Add Merchant',
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
