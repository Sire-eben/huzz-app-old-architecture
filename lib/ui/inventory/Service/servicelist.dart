import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/data/repository/business_respository.dart';
import 'package:huzz/data/repository/product_repository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/ui/inventory/Service/add_service.dart';
import 'package:huzz/data/model/product.dart';
import 'package:huzz/data/model/product_model.dart';
import 'package:number_display/number_display.dart';
import '../../../util/colors.dart';
import '../../../util/util.dart';

class ServiceListing extends StatefulWidget {
  const ServiceListing({Key? key}) : super(key: key);

  @override
  _ServiceListingState createState() => _ServiceListingState();
}

class _ServiceListingState extends State<ServiceListing> {
  final TextEditingController textEditingController = TextEditingController();
  final _productController = Get.find<ProductRepository>();
  final _businessController = Get.find<BusinessRespository>();
  final teamController = Get.find<TeamRepository>();
  final display = createDisplay(
      roundingType: RoundingType.floor,
      length: 15,
      decimal: 5,
      placeholder: '${Utils.getCurrency()}',
      units: ['K', 'M', 'B', 'T']);

  bool isDelete = false;
  String searchtext = "";
  List<Product> searchResult = [];
  void searchItem(String val) {
    print("search text $val");
    searchtext = val;
    setState(() {});

    searchResult.clear();
    _productController.productServices.forEach((element) {
      if (element.productName!.toLowerCase().contains(val.toLowerCase())) {
        searchResult.add(element);
      }
    });
    setState(() {});
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
                    'You are about to delete a service, Are you sure you want to continue?',
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
                if (teamController.teamMember.authoritySet!
                    .contains('DELETE_PRODUCT')) {
                  _displayDialog(context);
                } else {
                  Get.snackbar('Alert',
                      'You need to be authorized to perform this operation');
                }
              } else {
                if (teamController.teamMember.authoritySet!
                    .contains('CREATE_PRODUCT')) {
                  Get.to(() => AddService());
                } else {
                  Get.snackbar('Alert',
                      'You need to be authorized to perform this operation');
                }
              }
            },
            icon: (isDelete) ? Container() : Icon(Icons.add),
            backgroundColor: AppColor().backgroundColor,
            label: Text(
              (isDelete) ? "Delete Service(s)" : 'New Service',
              style: TextStyle(
                  fontFamily: 'InterRegular',
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            children: [
              //Service Count
              Positioned(
                top: 15,
                left: 20,
                right: 20,
                child: serviceCount(context),
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
                          // textInputAction: TextInputAction.none,
                          onChanged: searchItem,
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
                                    color: AppColor().backgroundColor,
                                    width: 2),
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
              //Add & Delete Button
              Positioned(
                top: 190,
                left: 30,
                right: 30,
                child: Row(
                  children: [
                    Text(
                      'Services (${_productController.productServices.length})',
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
                      height: 10,
                    ),
                    InkWell(
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
                    ),
                  ],
                ),
              ),

              //ServiceList
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
                              ? Center(child: CircularProgressIndicator())
                              : (_productController.productStatus ==
                                      ProductStatus.Available)
                                  ? ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: (searchtext.isEmpty)
                                          ? _productController
                                              .productServices.length
                                          : searchResult.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var item = searchtext.isEmpty
                                            ? _productController
                                                .productServices[index]
                                            : searchResult[index];
                                        return (isDelete)
                                            ? ListingServicesDelete(
                                                item: item,
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  if (teamController
                                                      .teamMember.authoritySet!
                                                      .contains(
                                                          'UPDATE_PRODUCT')) {
                                                    _productController
                                                        .setItem(item);
                                                    Get.to(AddService(
                                                      item: item,
                                                    ));
                                                  } else {
                                                    Get.snackbar('Alert',
                                                        'You need to be authorized to perform this operation');
                                                  }
                                                },
                                                child: ListingServices(
                                                  item: item,
                                                ),
                                              );
                                      })
                                  : (_productController.productStatus ==
                                          ProductStatus.Empty)
                                      ? Text('Not Item')
                                      : Text('Empty'),
                        );
                      })
                    : Container(
                        child: Center(
                          child: Text("No Service Found"),
                        ),
                      ),
              ),
            ],
          ));
    });
  }

  Widget serviceCount(BuildContext context) => Container(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Services Count",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'InterRegular',
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "${_productController.productServices.length}",
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
                        "Total Services value",
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
                          "${Utils.getCurrency()}${display(_productController.totalService)}",
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
class ListingServices extends StatefulWidget {
  Product? item;
  ListingServices({
    this.item,
  });

  @override
  _ListingServicesState createState() => _ListingServicesState();
}

class _ListingServicesState extends State<ListingServices> {
  ProductModels? products;
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  // ignore: unused_field
  final _productController = Get.find<ProductRepository>();
  final teamController = Get.find<TeamRepository>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            height: MediaQuery.of(context).size.height * 0.12,
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
                  width: 15,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.item!.productName!,
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'InterRegular',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${Utils.getCurrency()}${display(widget.item!.costPrice!)}',
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'InterRegular',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Expanded(
                        child: Text(
                          "${widget.item!.description}",
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'InterRegular',
                            fontSize: 9,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColor().backgroundColor,
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
    );
  }
}

// ignore: must_be_immutable
class ListingServicesDelete extends StatefulWidget {
  Product? item;
  ListingServicesDelete({
    this.item,
  });

  @override
  _ListingServicesDeleteState createState() => _ListingServicesDeleteState();
}

class _ListingServicesDeleteState extends State<ListingServicesDelete> {
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  final _productController = Get.find<ProductRepository>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              height: MediaQuery.of(context).size.height * 0.12,
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
                    width: 20,
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.item!.productName!,
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontFamily: 'InterRegular',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${Utils.getCurrency()}${display(widget.item!.costPrice!)}',
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontFamily: 'InterRegular',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Expanded(
                          child: Text(
                            "${widget.item!.description}",
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'InterRegular',
                              fontSize: 9,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                        color: _productController.checkifSelectedForDelted(
                                widget.item!.productId!)
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
        ),
      );
    });
  }
}
