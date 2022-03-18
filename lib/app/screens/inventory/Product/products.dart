import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/app/screens/inventory/Product/productlist.dart';
import 'package:number_display/number_display.dart';
import '../../../../colors.dart';
import '../../../Utils/util.dart';
import 'add_product.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final _productController = Get.find<ProductRepository>();
  final display = createDisplay(
      length: 5,
      decimal: 0,
      placeholder: '${Utils.getCurrency()}',
      units: ['K', 'M', 'B', 'T']);
  @override
  Widget build(BuildContext context) {
    return (_productController.productGoods.isEmpty)
        ? Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Get.to(AddProduct());
              },
              icon: Icon(Icons.add),
              backgroundColor: AppColor().backgroundColor,
              label: Text(
                'New Product',
                style: TextStyle(
                    fontFamily: 'InterRegular',
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Stack(
              children: [
                Positioned(
                  top: 30,
                  left: 20,
                  right: 20,
                  child: productCount(context),
                ),
                Positioned(
                  bottom: 30,
                  top: 150,
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
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Add Product',
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'InterRegular',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Your products will show here. Click the",
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'InterRegular',
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "New Product button to add your first product",
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'InterRegular',
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 10,
                //   right: 30,
                //   child: InkWell(
                //     onTap: () {
                //       Get.to(AddProduct());
                //     },
                //     child: Container(
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 20,
                //         vertical: 15,
                //       ),
                //       decoration: BoxDecoration(
                //         color: AppColor().backgroundColor,
                //         borderRadius: BorderRadius.circular(25),
                //       ),
                //       child: Row(
                //         children: [
                //           Icon(
                //             Icons.add,
                //             size: 18,
                //             color: Colors.white,
                //           ),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text(
                //             'New Products',
                //             style: TextStyle(
                //               color: AppColor().whiteColor,
                //               fontFamily: 'InterRegular',
                //               fontWeight: FontWeight.bold,
                //               fontSize: 14,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
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
                        "${Utils.getCurrency()}0.0",
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
