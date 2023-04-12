import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/ui/customers/customers/add_customer.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:huzz/ui/widget/huzz_dialog/delete_dialog.dart';
import 'package:random_color/random_color.dart';
import '../../widget/loading_widget.dart';

class Customers extends StatefulWidget {
  final String? pageName;
  const Customers({Key? key, @required this.pageName}) : super(key: key);

  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final _searchcontroller = TextEditingController();
  final RandomColor _randomColor = RandomColor();
  final _customerController = Get.find<CustomerRepository>();
  final teamController = Get.find<TeamRepository>();
  String searchtext = "";
  List<Customer> searchResult = [];
  final _businessController = Get.find<BusinessRespository>();

  void searchItem(String val) {
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
        return teamController.teamMembersStatus == TeamMemberStatus.Loading
            ? Center(
                child: LoadingWidget(),
              )
            : Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    TextField(
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        color: AppColors.backgroundColor,
                      ),
                      controller: _searchcontroller,
                      cursorColor: Colors.white,
                      autofocus: false,
                      onChanged: searchItem,
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
                        contentPadding: const EdgeInsets.only(
                            left: 16, right: 8, top: 8, bottom: 8),
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
                    if (_customerController.customerStatus ==
                        CustomerStatus.UnAuthorized) ...[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.02,
                              right: MediaQuery.of(context).size.height * 0.02,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.02),
                          decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
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
                                const SizedBox(height: 5),
                                Text(
                                  'Customer',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Your customers will show here.',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'You need to be authorized\nto view this module',
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AppColors.orangeBorderColor,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ] else ...[
                      if (teamController.teamMembersStatus ==
                              TeamMemberStatus.UnAuthorized ||
                          teamController.teamMembersStatus ==
                              TeamMemberStatus.Error) ...[
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.02),
                          child: (searchtext.isEmpty || searchResult.isNotEmpty)
                              ? (_customerController
                                      .customerCustomer.isNotEmpty)
                                  ? RefreshIndicator(
                                      onRefresh: () async {
                                        return Future.delayed(
                                            const Duration(seconds: 1), () {
                                          _customerController.getOnlineCustomer(
                                              value!.businessId!);
                                          _customerController
                                              .getOfflineCustomer(
                                                  value.businessId!);
                                        });
                                      },
                                      child:
                                          (_customerController.customerStatus ==
                                                  CustomerStatus.Loading)
                                              ? Center(child: LoadingWidget())
                                              : (_customerController
                                                          .customerStatus ==
                                                      CustomerStatus.Available)
                                                  ? ListView.separated(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          const AlwaysScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const Divider(),
                                                      itemCount:
                                                          (searchResult.isEmpty)
                                                              ? _customerController
                                                                  .customerCustomer
                                                                  .length
                                                              : searchResult
                                                                  .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var item = (searchResult
                                                                .isEmpty)
                                                            ? _customerController
                                                                    .customerCustomer[
                                                                index]
                                                            : searchResult[
                                                                index];
                                                        return Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Container(
                                                                    height: 50,
                                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: _randomColor.randomColor()),
                                                                    child: Center(
                                                                        child: Text(
                                                                      item.name == null ||
                                                                              item.name!.isEmpty
                                                                          ? ""
                                                                          : item.name![0],
                                                                      style: GoogleFonts.inter(
                                                                          fontSize:
                                                                              30,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w600),
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
                                                                            FontWeight.w400),
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
                                                            GestureDetector(
                                                                onTap: () {
                                                                  _customerController
                                                                      .setItem(
                                                                          item);
                                                                  Get.to(
                                                                      AddCustomer(
                                                                    item: item,
                                                                  ));
                                                                },
                                                                child: SvgPicture
                                                                    .asset(
                                                                        'assets/images/edit.svg')),
                                                            Row(
                                                              children: [
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (_) {
                                                                            return HuzzDeleteDialog(
                                                                              title: "Customer",
                                                                              content: "customer",
                                                                              action: () {
                                                                                _customerController.deleteBusinessCustomer(item);
                                                                                Get.back();
                                                                              },
                                                                            );
                                                                          });
                                                                    },
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            'assets/images/delete.svg')),
                                                              ],
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    )
                                                  : (_customerController
                                                              .customerStatus ==
                                                          CustomerStatus.Empty)
                                                      ? const Text('No Item')
                                                      : const Text('Empty'),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF5F5F5),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 2,
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                      ),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                'assets/images/customers.svg'),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Customer',
                                              style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Your customers will show here. Click the',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Add customers button to add your first customer',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                              : const Center(
                                  child: Text("No Customer Found"),
                                ),
                        ))
                      ] else ...[
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.02),
                          child: (searchtext.isEmpty || searchResult.isNotEmpty)
                              ? (_customerController
                                      .customerCustomer.isNotEmpty)
                                  ? RefreshIndicator(
                                      onRefresh: () async {
                                        return Future.delayed(
                                            const Duration(seconds: 1), () {
                                          _customerController.getOnlineCustomer(
                                              value!.businessId!);
                                          _customerController
                                              .getOfflineCustomer(
                                                  value.businessId!);
                                        });
                                      },
                                      child:
                                          (_customerController.customerStatus ==
                                                  CustomerStatus.Loading)
                                              ? Center(child: LoadingWidget())
                                              : (_customerController
                                                          .customerStatus ==
                                                      CustomerStatus.Available)
                                                  ? ListView.separated(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          const AlwaysScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const Divider(),
                                                      itemCount:
                                                          (searchResult.isEmpty)
                                                              ? _customerController
                                                                  .customerCustomer
                                                                  .length
                                                              : searchResult
                                                                  .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var item = (searchResult
                                                                .isEmpty)
                                                            ? _customerController
                                                                    .customerCustomer[
                                                                index]
                                                            : searchResult[
                                                                index];
                                                        return Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Container(
                                                                    height: 50,
                                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: _randomColor.randomColor()),
                                                                    child: Center(
                                                                        child: Text(
                                                                      item.name == null ||
                                                                              item.name!.isEmpty
                                                                          ? ""
                                                                          : item.name![0],
                                                                      style: GoogleFonts.inter(
                                                                          fontSize:
                                                                              30,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w600),
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
                                                                              FontWeight.w400),
                                                                    ),
                                                                    Text(
                                                                      item.phone!,
                                                                      style: GoogleFonts.inter(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey),
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
                                                                          AddCustomer(
                                                                        item:
                                                                            item,
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
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (_) {
                                                                                  return HuzzDeleteDialog(
                                                                                    title: "Customer",
                                                                                    content: "customer",
                                                                                    action: () {
                                                                                      _customerController.deleteBusinessCustomer(item);
                                                                                      Get.back();
                                                                                    },
                                                                                  );
                                                                                });
                                                                          },
                                                                          child:
                                                                              SvgPicture.asset('assets/images/delete.svg')),
                                                                    ],
                                                                  )
                                                                : Container(),
                                                          ],
                                                        );
                                                      },
                                                    )
                                                  : (_customerController
                                                              .customerStatus ==
                                                          CustomerStatus.Empty)
                                                      ? const Text('No Item')
                                                      : const Text('Empty'),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF5F5F5),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 2,
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                      ),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                'assets/images/customers.svg'),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Customer',
                                              style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Your customers will show here. Click the',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Add customers button to add your first customer',
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
                                  child: const Center(
                                    child: Text("No Customer Found"),
                                  ),
                                ),
                        ))
                      ],
                    ],
                  ],
                ),
              );
      }),
      floatingActionButton:
          (_customerController.customerStatus == CustomerStatus.UnAuthorized)
              ? Container()
              : (teamController.teamMember.authoritySet == null ||
                      teamController.teamMember.teamMemberStatus == 'CREATOR')
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        Get.to(() => AddCustomer());
                      },
                      icon: const Icon(Icons.add),
                      backgroundColor: AppColors.backgroundColor,
                      label: Text(
                        'Add Customer',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : (teamController.teamMember.authoritySet!
                          .contains('CREATE_CUSTOMER'))
                      ? FloatingActionButton.extended(
                          onPressed: () {
                            Get.to(() => AddCustomer());
                          },
                          icon: const Icon(Icons.add),
                          backgroundColor: AppColors.backgroundColor,
                          label: Text(
                            'Add Customer',
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      : Container(),
    );
  }
}
