import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/customer_model.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final _searchcontroller = TextEditingController();
  final _customerController = Get.find<CustomerRepository>();
  String searchtext = "";
  List<Customer> searchResult = [];
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
                  fontFamily: 'InterRegular'),
              controller: _searchcontroller,
              onChanged: searchItem,
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
                  left: MediaQuery.of(context).size.height * 0.02,
                  right: MediaQuery.of(context).size.height * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.02),
              child: (searchtext.isEmpty || searchResult.isNotEmpty)
                  ? ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: (searchResult.isEmpty)
                          ? _customerController.customerCustomer.length
                          : searchResult.length,
                      itemBuilder: (context, index) {
                        if (customerList.length == 0) {
                          return Container(
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Customers',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontFamily: 'InterRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Your customers will show here. Click the',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontFamily: 'InterRegular'),
                                  ),
                                  Text(
                                    'Add customer button to add your first customer',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontFamily: 'InterRegular'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          var item = (searchResult.isEmpty)
                              ? _customerController.customerCustomer[index]
                              : searchResult[index];
                          return Row(
                            children: [
                              Image.asset(customerList[index].image!),
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
                                            fontFamily: 'InterRegular',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        item.phone!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'InterRegular',
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child:
                                    SvgPicture.asset('assets/images/edit.svg'),
                              ),
                              Expanded(
                                child: SvgPicture.asset(
                                    'assets/images/delete.svg'),
                              ),
                            ],
                          );
                        }
                      },
                    )
                  : Container(
                      child: Center(
                        child: Text("No Customer Found"),
                      ),
                    ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Get.to(() => AddCustomer());
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
}
