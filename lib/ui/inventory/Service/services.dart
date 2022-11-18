import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/ui/inventory/Service/servicelist.dart';
import '../../../data/repository/team_repository.dart';
import '../../../util/colors.dart';
import 'add_service.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final _productController = Get.find<ProductRepository>();
  final teamController = Get.find<TeamRepository>();
  final _businessController = Get.find<BusinessRespository>();
  @override
  Widget build(BuildContext context) {
    return (_productController.productServices.isNotEmpty)
        ? ServiceListing()
        : Scaffold(
            floatingActionButton: (_productController.productStatus ==
                    ProductStatus.UnAuthorized)
                ? Container()
                : (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                        teamController.teamMember.authoritySet!
                            .contains('CREATE_PRODUCT'))
                    ? FloatingActionButton.extended(
                        onPressed: () {
                          Get.to(() => AddService());
                        },
                        icon: Icon(Icons.add),
                        backgroundColor: AppColor().backgroundColor,
                        label: Text(
                          'New Service',
                          style: TextStyle(
                              fontFamily: 'InterRegular',
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Container(),
            body: RefreshIndicator(
              onRefresh: () async {
                return Future.delayed(Duration(seconds: 1), () {
                  _businessController.OnlineBusiness();
                });
              },
              child: Stack(
                children: [
                  //Service Count
                  if (_productController.productStatus ==
                      ProductStatus.UnAuthorized) ...[
                    Container(),
                  ] else ...[
                    Positioned(
                      top: 30,
                      left: 20,
                      right: 20,
                      child: serviceCount(context),
                    ),
                  ],
                  Positioned(
                    bottom: 30,
                    top: (_productController.productStatus ==
                            ProductStatus.UnAuthorized)
                        ? 30
                        : 150,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Group 3625.png',
                            height: 50,
                            color: AppColor().backgroundColor,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Service',
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'InterRegular',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            (_productController.productStatus !=
                                    ProductStatus.UnAuthorized)
                                ? "Your services will show here. Click the"
                                : "Your services will show here.",
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'InterRegular',
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          if (_productController.productStatus !=
                              ProductStatus.UnAuthorized) ...[
                            Text(
                              "New Service button to add your first service",
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontFamily: 'InterRegular',
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                          SizedBox(height: 20),
                          if (_productController.productStatus ==
                              ProductStatus.UnAuthorized) ...[
                            Text(
                              'You need to be authorized\nto view this module',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor().orangeBorderColor,
                                  fontFamily: 'InterRegular',
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget serviceCount(BuildContext context) => Container(
        height: 95,
        decoration: BoxDecoration(
          color: AppColor().backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Service Count",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'InterRegular',
                      fontSize: 12,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "0",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'InterRegular',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 95,
              padding: EdgeInsets.only(right: 9),
              decoration: BoxDecoration(
                color: AppColor().secondbgColor,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.1,
                    0.6,
                    0.8,
                  ],
                  colors: [
                    Color(0xff0D8372),
                    Color(0xff07A58E),
                    AppColor().backgroundColor.withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 39),
                      child: Text(
                        "Total service value",
                        style: TextStyle(
                          fontFamily: 'InterRegular',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "N0.00",
                        style: TextStyle(
                          fontFamily: 'InterRegular',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
