import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/records_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'transaction_history.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final recordFilter = [
    'Today',
    'This Year',
    'This Week',
    'All Time',
    'This month',
    'Custom date range'
  ];

  String? value;
  List<_SalesData> data = [
    _SalesData('Nov 1', 35),
    _SalesData('Nov 2', 28),
    _SalesData('Nov 3', 34),
    _SalesData('Nov 4', 32),
    _SalesData('Nov 5', 40),
    _SalesData('Nov 6', 28),
    _SalesData('Nov 7', 34),
    _SalesData('Nov 8', 32)
  ];

  List<_SalesData> data2 = [
    _SalesData('Nov 1', 15),
    _SalesData('Nov 2', 10),
    _SalesData('Nov 3', 40),
    _SalesData('Nov 4', 32),
    _SalesData('Nov 5', 20),
    _SalesData('Nov 6', 15),
    _SalesData('Nov 7', 40),
    _SalesData('Nov 8', 32)
  ];
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
          'Records',
          style: TextStyle(
            color: AppColor().backgroundColor,
            fontFamily: "DMSans",
            fontStyle: FontStyle.normal,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                height: 90,
                decoration: BoxDecoration(
                  color: AppColor().backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage("assets/images/home_rectangle.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.025),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Money Out",
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'DMSans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "N55,000",
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'DMSans',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Balance",
                          style: TextStyle(
                            color: AppColor().whiteColor,
                            fontFamily: 'DMSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "N3,570",
                          style: TextStyle(
                            color: AppColor().whiteColor,
                            fontFamily: 'DMSans',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.025),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Money Out",
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'DMSans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "N55,000",
                            style: TextStyle(
                              color: AppColor().whiteColor,
                              fontFamily: 'DMSans',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Row(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor().orangeBorderColor),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Money Out (₦)',
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor().blueColor),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Money in (₦)',
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            width: 2, color: AppColor().backgroundColor)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: value,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 14,
                          color: AppColor().backgroundColor,
                        ),
                        hint: Text(
                          'This month',
                          style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        isDense: true,
                        items: recordFilter.map(buildDropDown).toList(),
                        onChanged: (value) =>
                            setState(() => this.value = value),
                        onTap: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              context: context,
                              builder: (context) => buildCustomDate());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Container(
                height: 200,
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),

                    // Chart title
                    // title: ChartTitle(text: 'Half yearly sales analysis'),
                    // Enable legend
                    legend: Legend(isVisible: false),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<_SalesData, String>>[
                      SplineSeries<_SalesData, String>(
                          dataSource: data,
                          color: AppColor().backgroundColor,
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: 'Sales',
                          splineType: SplineType.cardinal,
                          cardinalSplineTension: 0.9,
                          // Enable data label
                          dataLabelSettings:
                              DataLabelSettings(isVisible: false)),
                      SplineSeries<_SalesData, String>(
                          dataSource: data2,
                          color: AppColor().orangeBorderColor,
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: 'Sales',
                          splineType: SplineType.cardinal,
                          cardinalSplineTension: 0.9,
                          // Enable data label
                          dataLabelSettings:
                              DataLabelSettings(isVisible: false)),
                    ]),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Transactions',
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '(This Month)',
                        style: TextStyle(
                          color: AppColor().blackColor,
                          fontFamily: 'DMSans',
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  SvgPicture.asset('assets/images/graph.svg'),
                  SizedBox(width: 5),
                  SvgPicture.asset('assets/images/download.svg')
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.03),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor().backgroundColor.withOpacity(0.2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DATE',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: 'DMSans',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'MONEY OUT (N)',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: 'DMSans',
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'MONEY IN (N)',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: 'DMSans',
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: ListView.builder(
                  itemCount: recordList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = recordList[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.02,
                          left: MediaQuery.of(context).size.height * 0.03,
                          right: MediaQuery.of(context).size.height * 0.03),
                      child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.015),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.1),
                            border: Border.all(
                                width: 2, color: Colors.grey.withOpacity(0.1))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.date!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DMSans',
                                      fontSize: 10,
                                      color: AppColor().blackColor),
                                ),
                                Text(
                                  item.moneyOut!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DMSans',
                                      fontSize: 10,
                                      color: AppColor().orangeBorderColor),
                                ),
                                Text(
                                  item.moneyIn!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DMSans',
                                      fontSize: 10,
                                      color: AppColor().blueColor),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    context: context,
                                    builder: (context) =>
                                        buildRecordSummary(item));
                              },
                              child: Text(
                                'View',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans',
                                    fontSize: 10,
                                    color: AppColor().backgroundColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRecordSummary(RecordModel recordModel) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 6,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '10, Nov. 2021',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: "DMSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        myState(() {
                          Get.back();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor().backgroundColor.withOpacity(0.2)),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: AppColor().backgroundColor,
                        ),
                      ))
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width * 0.02),
                child: Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.015),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.1),
                      border: Border.all(
                          width: 2, color: Colors.grey.withOpacity(0.1))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              recordModel.date!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Money Out',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().blackColor),
                            ),
                            Text(
                              recordModel.moneyOut!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  color: AppColor().orangeBorderColor),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Money In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans',
                                    fontSize: 10,
                                    color: AppColor().blackColor),
                              ),
                              Text(
                                recordModel.moneyIn!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'DMSans',
                                    fontSize: 10,
                                    color: AppColor().blueColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: recordSummaryList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = recordSummaryList[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.width * 0.02),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.height * 0.015),
                          child: Row(
                            children: [
                              Image.asset(item.image!),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'DMSans',
                                          fontSize: 10,
                                          color: AppColor().blackColor),
                                    ),
                                    Text(
                                      item.time!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'DMSans',
                                          fontSize: 10,
                                          color: AppColor().blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.price!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'DMSans',
                                          fontSize: 10,
                                          color: AppColor().blackColor),
                                    ),
                                    Text(
                                      item.detail!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'DMSans',
                                          fontSize: 10,
                                          color: AppColor().blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  Get.to(() =>
                                      TransactionHistory(recordSummary: item));
                                },
                                child: Icon(
                                  Icons.visibility,
                                  color: AppColor().backgroundColor,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      });

  Widget buildCustomDate() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 6,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width * 0.02),
                child: Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.015),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.1),
                      border: Border.all(
                          width: 2, color: Colors.grey.withOpacity(0.1))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DMSans',
                              fontSize: 10,
                              color: AppColor().blackColor),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Money Out',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DMSans',
                              fontSize: 10,
                              color: AppColor().blackColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  setState(() {});
                  Get.back();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Filter',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: 'DMSans'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });

  DropdownMenuItem<String> buildDropDown(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
