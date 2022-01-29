import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/app/screens/inventory/Product/productdelete.dart';
import 'package:huzz/app/screens/inventory/Product/productlist.dart';
import 'package:huzz/app/screens/inventory/Service/add_service.dart';
import 'package:huzz/model/product.dart';
import 'package:huzz/model/product_model.dart';
import 'package:huzz/model/service_model.dart';
import 'package:number_display/number_display.dart';

import '../../../../colors.dart';

class ServiceListing extends StatefulWidget {
  const ServiceListing({Key? key}) : super(key: key);

  @override
  _ServiceListingState createState() => _ServiceListingState();
}

class _ServiceListingState extends State<ServiceListing> {
  final TextEditingController textEditingController = TextEditingController();
  final _productController = Get.find<ProductRepository>();
      final display = createDisplay(
    length: 5,
    decimal: 0,
    placeholder: 'N',
    units: ['K','M','B','T']
  );
   bool isDelete=false;
  String searchtext="";
  List<Product> searchResult=[];
    void searchItem(String val){
      print("search text $val");
      searchtext=val;
      setState(() {
        
      });
      
searchResult.clear();
_productController.productServices.forEach((element) {
  if (element.productName!.toLowerCase().contains(val.toLowerCase())){

searchResult.add(element);
  }

});
setState(() {
  
});
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().whiteColor,
      body: Obx(() {
        return Stack(
          children: [
            //Service Count
            Positioned(
              top: 30,
              left: 20,
              right: 20,
              child: productCount(context),
            ),
            //Add & Delete Button
            Positioned(
              top: 210,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Text(
                    'Services (${_productController.productServices.length})',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'DMSans',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Spacer(),
                  // InkWell(
                  //   onTap: () => showModalBottomSheet(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.vertical(
                  //         top: Radius.circular(20),
                  //       ),
                  //     ),
                  //     context: context,
                  //     builder: (context) => buildAddProduct(),
                  //   ),
                  //   child: Container(
                  //     height: 30,
                  //     width: 30,
                  //     decoration: BoxDecoration(
                  //       color: AppColor().lightbackgroundColor,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Icon(
                  //       Icons.add,
                  //       size: 20,
                  //       color: AppColor().backgroundColor,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: 5,
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                  setState(() {
                    isDelete=!isDelete;
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
            //Search
            Positioned(
              top: 140,
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
                                  color: AppColor().backgroundColor, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Search',
                          hintStyle:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    fontFamily: 'DMSans',
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
            //ServiceList
            Positioned(
              top: 270,
              bottom: 30,
              left: 20,
              right: 20,
              child:(searchtext.isEmpty||searchResult.isNotEmpty)? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount:( searchtext.isEmpty)? _productController.productServices.length:searchResult.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = searchtext.isEmpty? _productController.productServices[index]:searchResult[index];
                    return (isDelete)?ListingProductDelete(
                      item: item,
                    ) :ListingServices(
                      item: item,
                    );
                  }):Container(
                    child: Center(

                      child: Text("No Service Found"),
                    ),
                  ),
            ),
             Positioned(
            bottom: 10,
            right: 30,
            child: GestureDetector(
              onTap: () {
                if(isDelete)
                _productController.deleteSelectedItem();
                else
                Get.to(AddService());
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
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                    (isDelete)?"Delete Service(s)":  'New Service',
                      style: TextStyle(
                        color: AppColor().whiteColor,
                        fontFamily: 'DMSans',
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
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: Text(
                    "Services Count",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DMSans',
                      fontSize: 12,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "${_productController.productServices.length}",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DMSans',
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
                        "Total Services value",
                        style: TextStyle(
                          fontFamily: 'DMSans',
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
                        "N${display(_productController.totalService)}",
                        style: TextStyle(
                          fontFamily: 'DMSans',
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
                    fontFamily: 'DMSans',
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
                                fontFamily: 'DMSans',
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
                                        fontFamily: 'DMSans',
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      '7',
                                      style: TextStyle(
                                        color: AppColor().orangeBorderColor,
                                        fontFamily: 'DMSans',
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
                                    fontFamily: 'DMSans',
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
                      hintText: 'N 0.00',
                      hintStyle:
                          Theme.of(context).textTheme.headline4!.copyWith(
                                fontFamily: 'DMSans',
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
                      fontFamily: 'DMSans',
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
  final _productController = Get.find<ProductRepository>();
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
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    "assets/images/Rectangle 1015.png",
                    height: 70,
                    width: 70,
                  ),
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
                              fontFamily: 'DMSans',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'N${display(widget.item!.costPrice!)}',
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'DMSans',
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
                          "description",
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'DMSans',
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
class ListingServicesDelete extends StatefulWidget {
  Product? item;
  ListingServicesDelete({
    this.item,
  });

  @override
  _ListingServicesDeleteState createState() => _ListingServicesDeleteState();
}

class _ListingServicesDeleteState extends State<ListingServices> {
  ProductModels? products;
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  final _productController = Get.find<ProductRepository>();
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
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    "assets/images/Rectangle 1015.png",
                    height: 70,
                    width: 70,
                  ),
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
                              fontFamily: 'DMSans',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'N${display(widget.item!.costPrice!)}',
                            style: TextStyle(
                              color: AppColor().blackColor,
                              fontFamily: 'DMSans',
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
                          "description",
                          style: TextStyle(
                            color: AppColor().blackColor,
                            fontFamily: 'DMSans',
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
      ),
    );
  }
}
