import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/ui/customers/merchants/add_merchant.dart';
import 'package:huzz/util/colors.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:random_color/random_color.dart';

import '../../../data/repository/team_repository.dart';

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
  final teamController = Get.find<TeamRepository>();
  String searchtext = "";
  List<Customer> searchResult = [];
  final _businessController = Get.find<BusinessRespository>();

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
        final value = _businessController.selectedBusiness.value;
        return Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              if (_customerController.customerStatus ==
                  CustomerStatus.UnAuthorized) ...[
                Container(),
              ] else ...[
                TextField(
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    color: AppColor().backgroundColor,
                  ),
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
                    hintStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
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
              ],
              if (_customerController.customerStatus ==
                  CustomerStatus.UnAuthorized) ...[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * 0.02,
                        right: MediaQuery.of(context).size.height * 0.02,
                        bottom: MediaQuery.of(context).size.height * 0.02),
                    decoration: BoxDecoration(
                      color: Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 2, color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/images/customers.svg'),
                          SizedBox(height: 5),
                          Text(
                            'Merchant',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Your merchants will show here.',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'You need to be authorized\nto view this module',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColor().orangeBorderColor,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ] else ...[
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(
                      // left: MediaQuery.of(context).size.height * 0.02,
                      // right: MediaQuery.of(context).size.height * 0.02,
                      bottom: MediaQuery.of(context).size.height * 0.02),
                  child: (searchtext.isEmpty || searchResult.isNotEmpty)
                      ? (_customerController.customerMerchant.isNotEmpty)
                          ? RefreshIndicator(
                              onRefresh: () async {
                                return Future.delayed(Duration(seconds: 1), () {
                                  _customerController
                                      .getOnlineCustomer(value!.businessId!);
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
                                                  .customerMerchant.length
                                              : searchResult.length,
                                          itemBuilder: (context, index) {
                                            var item = (searchResult.isEmpty)
                                                ? _customerController
                                                    .customerMerchant[index]
                                                : searchResult[index];
                                            print(
                                                'merchant: ${item.name}, ${item.customerId}');
                                            return Column(
                                              children: [
                                                if (item.name == null ||
                                                    item.name == '')
                                                  ...[]
                                                else ...[
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Container(
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: _randomColor
                                                                      .randomColor()),
                                                              child: Center(
                                                                  child: Text(
                                                                (item.name ==
                                                                            null ||
                                                                        item.name ==
                                                                            '')
                                                                    ? '0'
                                                                    : '${item.name![0]}',
                                                                style: GoogleFonts.inter(
                                                                    fontSize:
                                                                        30,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ))),
                                                        ),
                                                      )),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
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
                                                                style: GoogleFonts.inter(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              Text(
                                                                item.phone!,
                                                                style: GoogleFonts.inter(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      (teamController.teamMember
                                                                      .teamMemberStatus ==
                                                                  'CREATOR' ||
                                                              teamController
                                                                  .teamMember
                                                                  .authoritySet!
                                                                  .contains(
                                                                      'UPDATE_CUSTOMER'))
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                _customerController
                                                                    .setItem(
                                                                        item);
                                                                Get.to(
                                                                    AddMerchant(
                                                                  item: item,
                                                                ));
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'assets/images/edit.svg'))
                                                          : Container(),
                                                      (teamController.teamMember
                                                                      .teamMemberStatus ==
                                                                  'CREATOR' ||
                                                              teamController
                                                                  .teamMember
                                                                  .authoritySet!
                                                                  .contains(
                                                                      'DELETE_CUSTOMER'))
                                                          ? Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      _displayDialog(
                                                                          context,
                                                                          item);
                                                                    },
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            'assets/images/delete.svg')),
                                                              ],
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ]
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
                                  left:
                                      MediaQuery.of(context).size.height * 0.02,
                                  right:
                                      MediaQuery.of(context).size.height * 0.02,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.02),
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
                                    SizedBox(height: 5),
                                    Text(
                                      'Merchant',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Your merchants will show here. Click the',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Add merchant button to add your first merchant',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
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
            ],
          ),
        );
      }),
      floatingActionButton:
          (_customerController.customerStatus == CustomerStatus.UnAuthorized)
              ? Container()
              : (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                      teamController.teamMember.authoritySet!
                          .contains('CREATE_CUSTOMER'))
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        if (teamController.teamMember.teamMemberStatus ==
                                'CREATOR' ||
                            teamController.teamMember.authoritySet!
                                .contains('CREATE_CUSTOMER')) {
                          Get.to(() => AddMerchant());
                        } else {
                          Get.snackbar('Alert',
                              'You need to be authorized to perform this operation');
                        }
                      },
                      icon: Icon(Icons.add),
                      backgroundColor: AppColor().backgroundColor,
                      label: Text(
                        'Add Merchant',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : Container(),
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
                    'You are about to delete a merchant, Are you sure you want to continue?',
                    style: GoogleFonts.inter(
                      color: AppColor().blackColor,
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
                              style: GoogleFonts.inter(
                                color: AppColor().backgroundColor,
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
                              style: GoogleFonts.inter(
                                color: AppColor().whiteColor,
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
