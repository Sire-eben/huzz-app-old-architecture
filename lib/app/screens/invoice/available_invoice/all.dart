import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/invoice/create_invoice.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/invoice_model.dart';

class All extends StatefulWidget {
  const All({Key? key}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  bool deleteItem = false;
  List<Invoice> _items = [];
  List _selectedIndex = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Invoices',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DMSans',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text(
                      '(3)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DMSans',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      deleteItem = !deleteItem;
                      print(deleteItem);
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      decoration: BoxDecoration(
                          color: AppColor().backgroundColor.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: SvgPicture.asset('assets/images/trash.svg')),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.02),
            Expanded(
              child: deleteItem
                  ? ListView.builder(
                      itemCount: invoiceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = invoiceList[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.width * 0.02),
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height * 0.02),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.1),
                                border: Border.all(
                                    width: 2,
                                    color: Colors.grey.withOpacity(0.1))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'DMSans',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.price!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'DMSans',
                                                fontSize: 14,
                                                color: Color(0xffEF6500)),
                                          ),
                                          Text(
                                            item.details!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'DMSans',
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            item.date!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'DMSans',
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.1),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColor().backgroundColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : ListView.builder(
                      itemCount: invoiceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = invoiceList[index];
                        final _isSelected = _selectedIndex.contains(index);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (_items.contains(index)) {
                                _selectedIndex.add(index);
                              } else {
                                _selectedIndex.remove(index);
                              }
                            });
                            print('selected');
                            print(_items.toString());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.02),
                            child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.height * 0.02),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(0.1),
                                  border: Border.all(
                                      width: 2,
                                      color: Colors.grey.withOpacity(0.1))),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'DMSans',
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.price!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'DMSans',
                                                  fontSize: 14,
                                                  color: Color(0xffEF6500)),
                                            ),
                                            Text(
                                              item.details!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'DMSans',
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              item.date!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'DMSans',
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.1),
                                  // _isSelected
                                  //     ? SvgPicture.asset(
                                  //         'assets/images/circle.svg')
                                  //     : SvgPicture.asset(
                                  //         'assets/images/selectedItem.svg')
                                  GestureDetector(
                                    onTap: () {},
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: AppColor().orangeBorderColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Color(0xffEF6500),
                                        ),
                                      ),
                                      child: Visibility(
                                        visible: true,
                                        child: Icon(
                                          Icons.check,
                                          size: 15,
                                          color: AppColor().orangeBorderColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => CreateInvoice());
        },
        icon: Icon(Icons.add),
        backgroundColor: AppColor().backgroundColor,
        label: Text(
          deleteItem ? 'New Invoice' : 'Delete Item',
          style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
