import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/app/screens/customers/merchants/add_merchant.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/customer_model.dart';
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
  String searchtext = "";
  List<Customer> searchResult = [];
  void searchItem(String val) {
    print("search text $val");
    searchtext = val;
    setState(() {});

    searchResult.clear();
    _customerController.customerMerchant.forEach((element) {
      if (element.name!.toLowerCase().contains(val.toLowerCase())) {
        searchResult.add(element);
      }
    });
    setState(() {});
  }

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
                onChanged: searchItem,
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
                child: (searchtext.isEmpty || searchResult.isNotEmpty)
                    ? (_customerController.customerMerchant.isNotEmpty)
                        ? ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: (searchResult.isEmpty)
                                ? _customerController.customerMerchant.length
                                : searchResult.length,
                            itemBuilder: (context, index) {
                              var item = (searchResult.isEmpty)
                                  ? _customerController.customerMerchant[index]
                                  : searchResult[index];
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
                                              color:
                                                  _randomColor.randomColor()),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
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
                                        _displayDialog(context, item);
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
                                right:
                                    MediaQuery.of(context).size.height * 0.02,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.02),
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
                                      'assets/images/customers.svg'),
                                  Text(
                                    'Merchant',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: 'DMSans',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Your merchants will show here. Click the',
                                    style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                        fontFamily: 'DMSans'),
                                  ),
                                  Text(
                                    'Add merchant button to add your first merchant',
                                    style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                        fontFamily: 'DMSans'),
                                  ),
                                ],
                              ),
                            ),
                          )
                    : Container(
                        child: Center(
                          child: Text("No Merchant Found"),
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

  _displayDialog(BuildContext context, var item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 200,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'You are about to delete a merchant, Are you sure you want to continue?',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            content: Center(
              child: SvgPicture.asset(
                'assets/images/delete_alert.svg',
                fit: BoxFit.fitHeight,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColor().whiteColor,
                              border: Border.all(
                                width: 2,
                                color: AppColor().backgroundColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _customerController.deleteBusinessCustomer(item);
                          Get.back();
                        },
                        child: Container(
                          height: 45,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColor().backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontFamily: 'DMSans',
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
