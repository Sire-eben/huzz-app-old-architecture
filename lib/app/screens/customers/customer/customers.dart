import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/app/screens/customers/customers/add_customer.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:random_color/random_color.dart';

class Customers extends StatefulWidget {
  final String? pageName;
  const Customers({Key? key, @required this.pageName}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final _searchcontroller = TextEditingController();
  RandomColor _randomColor = RandomColor();
  final _customerController = Get.find<CustomerRepository>();
  String searchtext = "";
  List<Customer> searchResult = [];
  final _businessController = Get.find<BusinessRespository>();

  void searchItem(String val) {
    print("search text $val");
    searchtext = val;
    setState(() {});

    searchResult.clear();
    _customerController.customerCustomer.forEach((element) {
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
        final value = _businessController.selectedBusiness.value;
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
                    fontFamily: 'InterRegular'),
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
                  hintText: 'Search Customers',
                  hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      fontFamily: 'InterRegular'),
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
                    bottom: MediaQuery.of(context).size.height * 0.02),
                child: (searchtext.isEmpty || searchResult.isNotEmpty)
                    ? (_customerController.customerCustomer.isNotEmpty)
                        ? RefreshIndicator(
                            onRefresh: () async {
                              return Future.delayed(Duration(seconds: 1), () {
                                _customerController
                                    .getOnlineCustomer(value!.businessId!);
                                _customerController
                                    .getOfflineCustomer(value.businessId!);
                              });
                            },
                            child: (_customerController.customerStatus ==
                                    CustomerStatus.Loading)
                                ? Center(child: CircularProgressIndicator())
                                : (_customerController.customerStatus ==
                                        CustomerStatus.Available)
                                    ? ListView.separated(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) =>
                                            Divider(),
                                        itemCount: (searchResult.isEmpty)
                                            ? _customerController
                                                .customerCustomer.length
                                            : searchResult.length,
                                        itemBuilder: (context, index) {
                                          var item = (searchResult.isEmpty)
                                              ? _customerController
                                                  .customerCustomer[index]
                                              : searchResult[index];
                                          return Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: _randomColor
                                                              .randomColor()),
                                                      child: Center(
                                                          child: Text(
                                                        item.name == null ||
                                                                item.name!
                                                                    .isEmpty
                                                            ? ""
                                                            : '${item.name![0]}',
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'InterRegular',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))),
                                                ),
                                              )),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.name!,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'InterRegular',
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      Text(
                                                        item.phone!,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'InterRegular',
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    _customerController
                                                        .setItem(item);
                                                    Get.to(AddCustomer(
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
                                                    _displayDialog(
                                                        context, item);
                                                  },
                                                  child: SvgPicture.asset(
                                                      'assets/images/delete.svg')),
                                            ],
                                          );
                                        },
                                      )
                                    : (_customerController.customerStatus ==
                                            CustomerStatus.Empty)
                                        ? Text('Not Item')
                                        : Text('Empty'),
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
                              border: Border.all(
                                  width: 2,
                                  color: Colors.grey.withOpacity(0.2)),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/customers.svg'),
                                  Text(
                                    'Customer',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontFamily: 'InterRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Your customers will show here. Click the',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontFamily: 'InterRegular'),
                                  ),
                                  Text(
                                    'Add customers button to add your first customer',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontFamily: 'InterRegular'),
                                  ),
                                ],
                              ),
                            ),
                          )
                    : Container(
                        child: Center(
                          child: Text("No Customer Found"),
                        ),
                      ),
              ))
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddCustomer());
        },
        icon: Icon(Icons.add),
        backgroundColor: AppColor().backgroundColor,
        label: Text(
          'Add Customer',
          style: TextStyle(
              fontFamily: 'InterRegular',
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
              vertical: 300,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'You are about to delete a customer, Are you sure you want to continue?',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'InterRegular',
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
                          // _invoiceController.deleteItems();
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
                                fontFamily: 'InterRegular',
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
                                fontFamily: 'InterRegular',
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
