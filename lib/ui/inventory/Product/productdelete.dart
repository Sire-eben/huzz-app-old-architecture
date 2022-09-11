// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/data/model/product.dart';
import 'package:number_display/number_display.dart';

import '../../../util/colors.dart';

class BuildDeleteProduct extends StatefulWidget {
  const BuildDeleteProduct({Key? key}) : super(key: key);

  @override
  _BuildDeleteProductState createState() => _BuildDeleteProductState();
}

class _BuildDeleteProductState extends State<BuildDeleteProduct> {
  final TextEditingController textEditingController = TextEditingController();
  final _productControlller = Get.find<ProductRepository>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor().backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Back',
          style: TextStyle(
            color: AppColor().backgroundColor,
            fontFamily: "InterRegular",
            fontStyle: FontStyle.normal,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: AppColor().whiteColor,
      body: Obx(() {
        return Stack(
          children: [
            Positioned(
              left: 20,
              right: 20,
              child: productCount(context),
            ),
            Positioned(
              top: 180,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Text(
                    'Product (${_productControlller.productGoods.length})',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'InterRegular',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppColor().lightbackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: AppColor().backgroundColor,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppColor().lightbackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline_outlined,
                      size: 20,
                      color: AppColor().backgroundColor,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 110,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffE6F4F2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColor().backgroundColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        controller: textEditingController,
                        textInputAction: TextInputAction.none,
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor().backgroundColor, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Search',
                          hintStyle:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    fontFamily: 'InterRegular',
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //ProductList
            Positioned(
              top: 230,
              bottom: 30,
              left: 20,
              right: 20,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _productControlller.productGoods.length,
                  itemBuilder: (BuildContext context, int index) {
                    Product item = _productControlller.productGoods[index];
                    return ListingProduct(
                      item: item,
                    );
                  }),
            ),
            Positioned(
              bottom: 10,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  _productControlller.deleteSelectedItem();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_forever_sharp,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Delete Product',
                        style: TextStyle(
                          color: AppColor().whiteColor,
                          fontFamily: 'InterRegular',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget productCount(BuildContext context) => Container(
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
                    "${_productControlller.productGoods.length}",
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

// ignore: must_be_immutable
class ListingProduct extends StatefulWidget {
  Product? item;
  ListingProduct({
    this.item,
  });

  @override
  _ListingProductState createState() => _ListingProductState();
}

class _ListingProductState extends State<ListingProduct> {
  final _productController = Get.find<ProductRepository>();
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xffC3C3C3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                true
                    ? Image.asset(
                        "assets/images/Rectangle 1015.png",
                        height: 50,
                      )
                    : Image.network(
                        widget.item!.productLogoFileStoreId!,
                        height: 50,
                      ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.item!.productName!,
                      style: TextStyle(
                        color: AppColor().blackColor,
                        fontFamily: 'InterRegular',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'left: ',
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'InterRegular',
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "${widget.item!.quantityLeft}",
                          style: TextStyle(
                            color: AppColor().orangeBorderColor,
                            fontFamily: 'InterRegular',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          'N${display(widget.item!.costPrice ?? 0)}',
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'InterRegular',
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(),
                ),
                GestureDetector(
                  onTap: () {
                    if (_productController
                        .checkifSelectedForDelted(widget.item!.productId!)) {
                      _productController.removeFromDeleteList(widget.item!);
                    } else {
                      _productController.addToDeleteList(widget.item!);
                    }
                    setState(() {});
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: _productController
                              .checkifSelectedForDelted(widget.item!.productId!)
                          ? AppColor().orangeBorderColor
                          : AppColor().whiteColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xffEF6500),
                      ),
                    ),
                    child: Visibility(
                      visible: _productController
                          .checkifSelectedForDelted(widget.item!.productId!),
                      child: Icon(
                        Icons.check,
                        size: 15,
                        color: _productController.checkifSelectedForDelted(
                                widget.item!.productId!)
                            ? AppColor().whiteColor
                            : AppColor().orangeBorderColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      );
    });
  }
}
