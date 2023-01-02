// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/data/model/product.dart';
import 'package:number_display/number_display.dart';
import 'package:huzz/core/constants/app_themes.dart';

class DeleteProduct extends StatefulWidget {
  const DeleteProduct({Key? key}) : super(key: key);

  @override
  _DeleteProductState createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  final TextEditingController textEditingController = TextEditingController();
  final _productController = Get.find<ProductRepository>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.backgroundColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Back',
          style: GoogleFonts.inter(
            color: AppColors.backgroundColor,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
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
                    'Product (${_productController.productGoods.length})',
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.lightBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.lightBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_outlined,
                      size: 20,
                      color: AppColors.backgroundColor,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffE6F4F2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search,
                      color: AppColors.backgroundColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        controller: textEditingController,
                        textInputAction: TextInputAction.none,
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.backgroundColor, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Search',
                          hintStyle:
                              Theme.of(context).textTheme.headline4!.copyWith(
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
                  itemCount: _productController.productGoods.length,
                  itemBuilder: (BuildContext context, int index) {
                    Product item = _productController.productGoods[index];
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
                  _productController.deleteSelectedItem();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete_forever_sharp,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Delete Product',
                        style: GoogleFonts.inter(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
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
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
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
                    "${_productController.productGoods.length}",
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
              padding: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.secondBgColor,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    0.1,
                    0.6,
                    0.8,
                  ],
                  colors: [
                    const Color(0xff0D8372),
                    const Color(0xff07A58E),
                    AppColors.backgroundColor.withOpacity(0.5),
                  ],
                ),
                borderRadius: const BorderRadius.only(
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
                        "N0.00",
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

// ignore: must_be_immutable
class ListingProduct extends StatefulWidget {
  Product? item;
  ListingProduct({super.key,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xffC3C3C3),
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
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.item!.productName!,
                      style: GoogleFonts.inter(
                        color: AppColors.blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'left: ',
                          style: GoogleFonts.inter(
                            color: AppColors.blackColor,
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "${widget.item!.quantityLeft}",
                          style: GoogleFonts.inter(
                            color: AppColors.orangeBorderColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          'N${display(widget.item!.costPrice ?? 0)}',
                          style: GoogleFonts.inter(
                            color: AppColors.blackColor,
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Expanded(
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
                    duration: const Duration(milliseconds: 200),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: _productController
                              .checkifSelectedForDelted(widget.item!.productId!)
                          ? AppColors.orangeBorderColor
                          : AppColors.whiteColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xffEF6500),
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
                            ? AppColors.whiteColor
                            : AppColors.orangeBorderColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      );
    });
  }
}
