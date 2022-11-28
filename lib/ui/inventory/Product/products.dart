import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/ui/inventory/Product/productlist.dart';
import 'package:number_display/number_display.dart';
import '../../../data/repository/business_respository.dart';
import '../../../data/repository/team_repository.dart';
import '../../../util/colors.dart';
import '../../../util/util.dart';
import 'add_product.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final _productController = Get.find<ProductRepository>();
  final teamController = Get.find<TeamRepository>();
  final _businessController = Get.find<BusinessRespository>();
  final display = createDisplay(
      length: 5,
      decimal: 0,
      placeholder: '${Utils.getCurrency()}',
      units: ['K', 'M', 'B', 'T']);
  @override
  Widget build(BuildContext context) {
    return (_productController.productGoods.isEmpty ||
            _productController.productStatus == ProductStatus.UnAuthorized)
        ? Scaffold(
            floatingActionButton: (_productController.productStatus ==
                    ProductStatus.UnAuthorized)
                ? Container()
                : (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                        teamController.teamMember.authoritySet!
                            .contains('CREATE_PRODUCT'))
                    ? FloatingActionButton.extended(
                        onPressed: () {
                          Get.to(() => AddProduct());
                        },
                        icon: Icon(Icons.add),
                        backgroundColor: AppColor().backgroundColor,
                        label: Text(
                          'New Product',
                          style: GoogleFonts.inter(
                              
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
                  if (_productController.productStatus ==
                      ProductStatus.UnAuthorized) ...[
                    Container(),
                  ] else ...[
                    Positioned(
                      top: 30,
                      left: 20,
                      right: 20,
                      child: productCount(context),
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
                            'Product',
                            style: GoogleFonts.inter(
                              color: AppColor().blackColor,
                              
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            (_productController.productStatus !=
                                    ProductStatus.UnAuthorized)
                                ? "Your products will show here. Click the"
                                : "Your products will show here.",
                            style: GoogleFonts.inter(
                              color: AppColor().blackColor,
                              
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          if (_productController.productStatus !=
                              ProductStatus.UnAuthorized) ...[
                            Text(
                              "New Product button to add your first product",
                              style: GoogleFonts.inter(
                                color: AppColor().blackColor,
                                
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
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColor().orangeBorderColor,
                                  
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
          )
        : ProductListing();
  }

  Widget productCount(BuildContext context) => Container(
        height: 95,
        width: double.infinity,
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
                    "Product Count",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      
                      fontSize: 12,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "0",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 95,
              padding: EdgeInsets.only(right: 8),
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
                      padding: const EdgeInsets.symmetric(horizontal: 37),
                      child: Text(
                        "Total product value",
                        style: GoogleFonts.inter(
                          
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
                        "${Utils.getCurrency()}0.0",
                        style: GoogleFonts.inter(
                          
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
