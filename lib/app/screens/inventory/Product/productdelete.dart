import 'package:flutter/material.dart';
import 'package:huzz/model/product_model.dart';

import '../../../../colors.dart';

class BuildDeleteProduct extends StatefulWidget {
  const BuildDeleteProduct({Key? key}) : super(key: key);

  @override
  _BuildDeleteProductState createState() => _BuildDeleteProductState();
}

class _BuildDeleteProductState extends State<BuildDeleteProduct> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().whiteColor,
      body: Stack(
        children: [
          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: productCount(context),
          ),
          Positioned(
            top: 210,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Text(
                  'Product (4)',
                  style: TextStyle(
                    color: AppColor().blackColor,
                    fontFamily: 'DMSans',
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
          //ProductList
          Positioned(
            top: 250,
            bottom: 30,
            left: 20,
            right: 20,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: productList.length,
                itemBuilder: (BuildContext context, int index) {
                  ProductModels items = productList[index];
                  return ListingProduct(
                    item: items,
                  );
                }),
          ),
          Positioned(
            bottom: 10,
            right: 30,
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
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
                      fontFamily: 'DMSans',
                      fontSize: 12,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "0",
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
                        "Total product value",
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
                        "N0.00",
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
}

// ignore: must_be_immutable
class ListingProduct extends StatefulWidget {
  ProductModels? item;
  ListingProduct({
    this.item,
  });

  @override
  _ListingProductState createState() => _ListingProductState();
}

class _ListingProductState extends State<ListingProduct> {
  bool isSelected = false;
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.item!.image!,
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
                    widget.item!.name!,
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
                        widget.item!.count!,
                        style: TextStyle(
                          color: AppColor().orangeBorderColor,
                          fontFamily: 'DMSans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        widget.item!.amount!,
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
              SizedBox(
                width: 100,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = !isSelected;
                    isVisible = !isVisible;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor().orangeBorderColor
                        : AppColor().whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xffEF6500),
                    ),
                  ),
                  child: Visibility(
                    visible: isVisible,
                    child: Icon(
                      Icons.check,
                      size: 15,
                      color: isSelected
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
  }
}
