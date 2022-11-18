import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/ui/inventory/Product/add_product.dart';
import 'package:huzz/ui/inventory/Service/servicelist.dart';
import 'package:huzz/data/model/product.dart';
import 'package:number_display/number_display.dart';
import '../../../util/colors.dart';
import '../../../util/util.dart';

class ProductListing extends StatefulWidget {
  const ProductListing({Key? key}) : super(key: key);

  @override
  _ProductListingState createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  final _businessController = Get.find<BusinessRespository>();
  final teamController = Get.find<TeamRepository>();
  final display = createDisplay(
      roundingType: RoundingType.floor,
      length: 15,
      decimal: 5,
      units: ['K', 'M', 'B', 'T']);

  final TextEditingController textEditingController = TextEditingController();
  Rx<List<Product>> _searchResult = Rx([]);
  List<Product> get searchResult => _searchResult.value;
  var searchtext = '';
  bool isDelete = false;
  final _productController = Get.find<ProductRepository>();
  void searchItem(String val) {
    searchtext = val;
    // searchResult.clear();
    List<Product> list = [];
    setState(() {});
    _productController.productGoods.forEach((element) {
      if (element.productName!.toLowerCase().contains(val.toLowerCase())) {
        // searchResult.add(element);
        list.add(element);
      }
    });
    _searchResult(list);
  }

  _displayDialog(BuildContext context) async {
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
                    'You are about to delete a product, Are you sure you want to continue?',
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
                'assets/images/polygon.svg',
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
                        onTap: () async {
                          await _productController.deleteSelectedItem();
                          setState(() {
                            isDelete = false;
                          });
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = _businessController.selectedBusiness.value;
      return Scaffold(
        backgroundColor: AppColor().whiteColor,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (isDelete) {
              if (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                  teamController.teamMember.authoritySet!
                      .contains('DELETE_PRODUCT')) {
                _displayDialog(context);
              } else {
                Get.snackbar('Alert',
                    'You need to be authorized to perform this operation');
              }
            } else {
              if (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                  teamController.teamMember.authoritySet!
                      .contains('CREATE_PRODUCT')) {
                Get.to(AddProduct());
              } else {
                Get.snackbar('Alert',
                    'You need to be authorized to perform this operation');
              }
            }
          },
          icon: (isDelete) ? Container() : Icon(Icons.add),
          backgroundColor: AppColor().backgroundColor,
          label: Text(
            (isDelete) ? "Delete Product(s)" : 'New Product',
            style: TextStyle(
                fontFamily: 'InterRegular',
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
            // Product Count
            Positioned(
              top: 15,
              left: 20,
              right: 20,
              child: productCount(context),
            ),

            //Search
            Positioned(
              top: 125,
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
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextFormField(
                        controller: textEditingController,
                        onChanged: searchItem,
                        // textInputAction: TextInputAction.none,
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

            // Add &  Delete Button
            Positioned(
              top: 190,
              left: 30,
              right: 30,
              child: Row(
                children: [
                  Text(
                    'Product (${_productController.productGoods.length})',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'InterRegular',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 5,
                  ),
                  (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                          teamController.teamMember.authoritySet!
                              .contains('DELETE_PRODUCT'))
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              isDelete = !isDelete;
                            });
                          },
                          child: Container(
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
                        )
                      : Container(),
                ],
              ),
            ),

            //ProductList
            Positioned(
              top: 240,
              bottom: 30,
              left: 20,
              right: 20,
              child: (searchtext.isEmpty || searchResult.isNotEmpty)
                  ? Obx(() {
                      return RefreshIndicator(
                        onRefresh: () async {
                          return Future.delayed(Duration(seconds: 1), () {
                            _productController
                                .getOnlineProduct(value!.businessId!);
                            _productController
                                .getOfflineProduct(value.businessId!);
                          });
                        },
                        child: (_productController.productStatus ==
                                ProductStatus.Loading)
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: AppColor().backgroundColor))
                            : (_productController.productStatus ==
                                    ProductStatus.Available)
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: (searchResult.isEmpty)
                                        ? _productController.productGoods.length
                                        : searchResult.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var item = (searchResult.isEmpty)
                                          ? _productController
                                              .productGoods[index]
                                          : searchResult[index];
                                      print("product item ${item.toJson()}");
                                      return (isDelete)
                                          ? ListingProductDelete(
                                              item: item,
                                            )
                                          : ListingProduct(
                                              item: item,
                                            );
                                    })
                                : (_productController.productStatus ==
                                        ProductStatus.Empty)
                                    ? Text('Not Item')
                                    : Center(
                                        child: CircularProgressIndicator(
                                            color: AppColor().backgroundColor),
                                      ),
                      );
                    })
                  : Container(
                      child: Center(
                        child: Text("No Product Found"),
                      ),
                    ),
            ),
          ],
        ),
      );
    });
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Product Count",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'InterRegular',
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "${_productController.productGoods.length}",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'InterRegular',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
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
                      child: Text(
                        "Total product value",
                        style: TextStyle(
                          fontFamily: 'InterRegular',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "${Utils.getCurrency()}${display(_productController.totalProduct)}",
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
            ),
          ],
        ),
      );
  Widget buildAddProduct() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07,
            bottom: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 3,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add stock',
                  style: TextStyle(
                    color: AppColor().blackColor,
                    fontFamily: 'InterRegular',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Color(0xffE6F4F2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColor().backgroundColor,
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/productImage.png',
                        height: 50,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Television',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                      '7',
                                      style: TextStyle(
                                        color: AppColor().orangeBorderColor,
                                        fontFamily: 'InterRegular',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 150,
                                ),
                                Text(
                                  'N20,000',
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
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Quantity',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          "*",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 18,
                    color: AppColor().whiteColor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 120,
                  child: TextFormField(
                    controller: textEditingController,
                    textInputAction: TextInputAction.none,
                    decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().backgroundColor, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().backgroundColor, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().backgroundColor, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      // labelText: label,
                      hintText: '${Utils.getCurrency()} 0.00',
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
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 18,
                    color: AppColor().whiteColor,
                  ),
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.to(ServiceListing());
              },
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    color: AppColor().backgroundColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: AppColor().whiteColor,
                      fontFamily: 'InterRegular',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  final _productController = Get.find<ProductRepository>();
  final teamController = Get.find<TeamRepository>();
  @override
  Widget build(BuildContext context) {
    // print("image ${widget.item!.productLogoFileStoreId}");
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
              widget.item!.productLogoFileStoreId == null ||
                      widget.item!.productLogoFileStoreId!.isEmpty
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
                    "${widget.item!.productName}",
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
                        '${Utils.getCurrency()}${display(widget.item!.sellingPrice ?? 0)}',
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
              (teamController.teamMember.teamMemberStatus == 'CREATOR' ||
                      teamController.teamMember.authoritySet!
                          .contains('UPDATE_PRODUCT'))
                  ? GestureDetector(
                      onTap: () {
                        _productController.setItem(widget.item!);
                        Get.to(AddProduct(
                          item: widget.item!,
                        ));
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xffF4D8C4),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Color(0xffEF6500),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              size: 20,
                              color: AppColor().orangeBorderColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: AppColor().orangeBorderColor,
                                fontFamily: 'InterRegular',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class ListingProductDelete extends StatefulWidget {
  Product? item;
  ListingProductDelete({
    this.item,
  });

  @override
  _ListingProductDeleteState createState() => _ListingProductDeleteState();
}

class _ListingProductDeleteState extends State<ListingProductDelete> {
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
                widget.item!.productLogoFileStoreId == null ||
                        widget.item!.productLogoFileStoreId!.isEmpty
                    ? Image.asset(
                        "assets/images/Rectangle 1015.png",
                        height: 50,
                      )
                    : Image.asset(
                        "assets/images/Rectangle 1015.png",
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
                          '${Utils.getCurrency()}${display(widget.item!.costPrice ?? 0)}',
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
            height: 20,
          )
        ],
      );
    });
  }
}
