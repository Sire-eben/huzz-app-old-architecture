import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/transaction_respository.dart';
import 'package:huzz/app/Utils/constants.dart';
import 'package:huzz/app/screens/home/insight.dart';
import 'package:huzz/app/screens/home/records/records_pdf.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/invoice_receipt_model.dart';
import 'package:huzz/model/recordData.dart';
import 'package:huzz/model/transaction_model.dart';
import 'package:number_display/number_display.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'money_history.dart';
import 'records/download.dart';

class Records extends StatefulWidget {
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final transactionController = Get.find<TransactionRespository>();
  List<TransactionModel> transactionList = [];
  DateTimeRange? dateRange;

  final recordFilter = [
    'Today',
    'This Week',
    'This month',
    'This Year',
    'All Time',
    'Custom date range'
  ];

  // String? value;
  List<_SalesData> data = [
    _SalesData('1pm', 35),
    _SalesData('2pm', 28),
    _SalesData('3pm', 34),
    _SalesData('4pm', 32),
    _SalesData('5pm', 40),
    _SalesData('6pm', 28),
    _SalesData('7pm', 34),
    _SalesData('8pm', 32)
  ];

  List<_SalesData> data2 = [
    _SalesData('1pm', 15),
    _SalesData('2pm', 10),
    _SalesData('3pm', 40),
    _SalesData('4pm', 32),
    _SalesData('5pm', 20),
    _SalesData('6pm', 15),
    _SalesData('7pm', 40),
    _SalesData('8pm', 32)
  ];
  final display = createDisplay(
      length: 5, decimal: 0, placeholder: 'N', units: ['K', 'M', 'B', 'T']);

  Future<DateTimeRange?> pickDateRanges(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return null;

    setState(() {
      dateRange = newDateRange;
      print(dateRange);
    });
    return dateRange;
  }

  List<RecordsData> item1 = [];
  List<RecordsData> item2 = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // transactionController.
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
      body: Obx(() {
        return Container(
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
                            vertical:
                                MediaQuery.of(context).size.height * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Money In",
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontFamily: 'DMSans',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "N${display(transactionController.recordMoneyIn)}",
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.015),
                        child: Column(
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
                              "N${display(transactionController.recordBalance)}",
                              style: TextStyle(
                                color: AppColor().whiteColor,
                                fontFamily: 'DMSans',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.02),
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
                              "N${display(transactionController.recordMoneyOut)}",
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
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
                          'Money Out (N)',
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
                          'Money in (N)',
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
                          value: transactionController.value.value,
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
                          onChanged: (value) async {
                            transactionController.value(value);
                            if (transactionController.value.value
                                .contains("This Year")) {
                              transactionController.getYearRecord();
                            } else if (transactionController.value.value
                                .contains("Today")) {
                              transactionController.splitCurrentTime();
                            } else if (transactionController.value.value
                                .contains("This Week")) {
                              transactionController.getWeeklyRecordData();
                            } else if (transactionController.value.value
                                .contains("This month")) {
                              transactionController.getMonthlyRecord();
                            } else if (transactionController.value.value
                                .contains("This Month")) {
                              transactionController.getMonthlyRecord();
                            } else if (transactionController.value.value
                                .contains("All Time")) {
                              transactionController.getAllTimeRecord();
                            } else if (transactionController.value.value
                                .contains("Custom date range")) {
                              DateTimeRange? val =
                                  await pickDateRanges(context);
                              if (val != null) {
                                transactionController.getDateRangeRecordData(
                                    val.start, val.end);
                              }
                            }
                          },
                          onTap: () {
                            // showModalBottomSheet(
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.vertical(
                            //             top: Radius.circular(20))),
                            //     context: context,
                            //     builder: (context) => buildCustomDate());
                          },
                        ),
                      ),
                    ),
                    // transactionController.value.toString() == 'Custom date range'
                    //     ? IconButton(
                    //         onPressed: () async {

                    //         },
                    //         icon: Icon(
                    //           Icons.date_range,
                    //           color: AppColor().backgroundColor,
                    //         ))
                    //     : Container()
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.03),
                child: Container(
                  height: 200,
                  child: Obx(() {
                    // item1=removeDoubleItem(transactionController.allIncomeHoursData);
                    // item2=removeDoubleItem(transactionController.allExpenditureHoursData);
                    return SfCartesianChart(
                        primaryYAxis: NumericAxis(
                          // labelFormat: "N"
                          axisLabelFormatter: (s) => ChartAxisLabel(
                              "N${display(s.value)}", TextStyle(fontSize: 10)),
                        ),
                        primaryXAxis: CategoryAxis(),
                        onTooltipRender: (s) {
                          var list = s.text!.split(":");
                          s.text =
                              "${list[0]} ${display(double.parse(list[1]))}";
                        },
                        // Chart title
                        // title: ChartTitle(text: 'Half yearly sales analysis'),
                        // Enable legend
                        legend: Legend(isVisible: false),
                        // Enable tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries<RecordsData, String>>[
                          SplineSeries<RecordsData, String>(
                              dataSource: transactionController
                                  .allIncomeHoursData
                                  .toList(),
                              color: AppColor().blueColor,
                              xValueMapper: (RecordsData value, _) =>
                                  value.label,
                              yValueMapper: (RecordsData value, _) =>
                                  value.value,
                              name: 'Sales',
                              splineType: SplineType.cardinal,
                              cardinalSplineTension: 0.9,
                              // Enable data label
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: false)),
                          SplineSeries<RecordsData, String>(
                              dataSource: transactionController
                                  .allExpenditureHoursData
                                  .toList(),
                              color: AppColor().orangeBorderColor,
                              xValueMapper: (RecordsData value, _) =>
                                  value.label,
                              yValueMapper: (RecordsData value, _) =>
                                  value.value,
                              name: 'Value',
                              xAxisName: "Date",
                              yAxisName: "Amount",
                              splineType: SplineType.cardinal,
                              cardinalSplineTension: 0.9,
                              // Enable data label
                              dataLabelSettings: DataLabelSettings(
                                isVisible: false,
                                builder: (data, point, series, pointIndex,
                                        seriesIndex) =>
                                    Text("bb"),
                              )),
                        ]);
                  }),
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
                          '${transactionController.value.value}',
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
                    InkWell(
                        onTap: () {
                          Get.to(() => Insight());
                        },
                        child: SvgPicture.asset('assets/images/graph.svg')),
                    SizedBox(width: 5),
                    InkWell(
                        onTap: () async {
                          final date = DateTime.now();
                          final dueDate = date.add(Duration(days: 7));

                          final record = Invoice(
                            supplier: Supplier(
                              name: 'Business Name',
                              mail: 'tunmisehassan@gmail.com',
                              phone: '+234 8123 456 789',
                            ),
                            bankDetails: BankDetails(
                                name: 'First Bank of Nigeria',
                                no: '0123456789',
                                mode: 'BANK TRANSFER'),
                            customer: InvoiceCustomer(
                              name: 'Joshua Olatunde',
                              phone: '+234 903 872 6495',
                            ),
                            info: InvoiceInfo(
                              date: date,
                              dueDate: dueDate,
                              description: 'My description...',
                              number: '${DateTime.now().year}-9999',
                            ),
                            items: [
                              InvoiceItem(
                                item: 'MacBook',
                                quantity: 3,
                                amount: 500000,
                              ),
                              InvoiceItem(
                                item: 'MacBook',
                                quantity: 3,
                                amount: 500000,
                              ),
                              InvoiceItem(
                                item: 'MacBook',
                                quantity: 3,
                                amount: 500000,
                              ),
                              InvoiceItem(
                                item: 'MacBook',
                                quantity: 3,
                                amount: 500000,
                              ),
                            ],
                          );

                          // final recordsData =
                          //     await RecordPdfApi.generate(record);
                          // Get.to(() => DownloadReceipt(file: recordsData,));
                        },
                        child: SvgPicture.asset('assets/images/download.svg'))
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
                    itemCount:
                        transactionController.allExpenditureHoursData.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item1 =
                          transactionController.allExpenditureHoursData[index];
                      var item2 =
                          transactionController.allIncomeHoursData[index];
                  
                      return Visibility(
                        visible: (item1.value!=0 ||item2.value!=0),
                        
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                context: context,
                                builder: (context) =>
                                    buildRecordSummary(item1, item2));
                          },
                          child: Padding(
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
                                      width: 2,
                                      color: Colors.grey.withOpacity(0.1))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item1.label,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'DMSans',
                                            fontSize: 10,
                                            color: AppColor().blackColor),
                                      ),
                                      Text(
                                        "N ${display(item1.value)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'DMSans',
                                            fontSize: 10,
                                            color: AppColor().orangeBorderColor),
                                      ),
                                      Text(
                                        "N ${display(item2.value)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'DMSans',
                                            fontSize: 10,
                                            color: AppColor().blueColor),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'View',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'DMSans',
                                        fontSize: 10,
                                        color: AppColor().backgroundColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget buildRecordSummary(RecordsData item1, RecordsData item2) {
    var paymentList = transactionController.getAllPaymentItemForRecord(item1);
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
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item1.label}',
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
                    Get.back();
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
              width: MediaQuery.of(context).size.width,
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
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
                          item1.label,
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
                          "${display(item1.value)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DMSans',
                              fontSize: 10,
                              color: AppColor().orangeBorderColor),
                        ),
                      ],
                    ),
                  ),
                 Container(
                    // alignment: Alignment.centerRight,
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
                            "N ${display(item2.value)}",
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
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: paymentList.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = paymentList[index];

                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.width * 0.02),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.015),
                      child: Row(
                        children: [
                          Image.asset(
                            (item.transactionType == "EXPENDITURE")
                                ? "assets/images/arrow_up.png"
                                : "assets/images/arrow_down.png",
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DMSans',
                                      fontSize: 10,
                                      color: AppColor().blackColor),
                                ),
                                Text(
                                  item.createdTime!.formatDate()!,
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
                                  " N ${display(item.totalAmount)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DMSans',
                                      fontSize: 10,
                                      color: AppColor().blackColor),
                                ),
                                Text(
                                  item.isFullyPaid!
                                      ? "Fully Paid"
                                      : "Partially",
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
                              Get.to(() => MoneySummary(
                                    item: item,
                                  ));
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
  }

  Widget buildCustomDate() => Container(
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
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
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

  DropdownMenuItem<String> buildDropDown(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.bold),
        ),
      );

  List<RecordsData> removeDoubleItem(List<RecordsData> list) {
    print("previous items lenght ${list.length}");
    List<RecordsData> newList = [];
    list.forEach((element) {
      if (newList
          .where((element1) => element.label.contains(element1.label))
          .toList()
          .isEmpty) {
        newList.add(element);
      } else {
        if (element.value > 0) {
          var ll = newList
              .where((element1) => element.label.contains(element1.label))
              .toList();
          if (ll.isNotEmpty) {
            var value = ll[0].value;
            if (element.value < value) {
              newList.remove(ll);
              newList.add(element);
            }
          }
        }
      }
    });
    print("new item list is ${newList.length}");
    return newList;
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
