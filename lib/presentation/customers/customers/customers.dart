import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/customer_model.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final _searchController = TextEditingController();
  final _customerController = Get.find<CustomerRepository>();
  String searchText = "";
  List<Customer> searchResult = [];
  void searchItem(String val) {
    // print("search text $val");
    searchText = val;
    setState(() {});

    searchResult.clear();
    for (var element in _customerController.customerCustomer) {
      if (element.name!.toLowerCase().contains(val.toLowerCase())) {
        searchResult.add(element);
      }
    }
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
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                color: AppColors.backgroundColor,
              ),
              controller: _searchController,
              onChanged: searchItem,
              cursorColor: Colors.white,
              autofocus: false,
              decoration: InputDecoration(
                prefixIcon: const Icon(

                  Icons.search,
                  color: AppColors.backgroundColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search Customers',
                hintStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
                contentPadding:
                    const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.backgroundColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 2,
                    color: AppColors.backgroundColor,
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
              child: (searchText.isEmpty || searchResult.isNotEmpty)
                  ? ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: (searchResult.isEmpty)
                          ? _customerController.customerCustomer.length
                          : searchResult.length,
                      itemBuilder: (context, index) {
                        if (customerList.isEmpty) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height * 0.02,
                                right:
                                    MediaQuery.of(context).size.height * 0.02,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.02),
                            decoration: BoxDecoration(
                              color: const Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/customers.svg'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Customers',
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Your customers will show here. Click the',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Add customer button to add your first customer',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
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
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name!,
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      item.phone!,
                                      style: GoogleFonts.inter(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
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
                  : const Center(
                    child: Text("No Customer Found"),
                  ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Get.to(() => AddCustomer());
        },
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.backgroundColor,
        label: Text(
          'Add Customer',
          style: GoogleFonts.inter(
              fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
