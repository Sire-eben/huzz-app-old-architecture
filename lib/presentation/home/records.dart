import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/util/constants.dart';
import 'package:huzz/data/repository/transaction_respository.dart';
import 'package:huzz/presentation/home/insight.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/recordData.dart';
import 'package:huzz/data/model/transaction_model.dart';
import 'package:huzz/core/util/util.dart';
import 'package:number_display/number_display.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'money_history.dart';
import 'records/download_records.dart';
import 'records/records_pdf.dart';

class Records extends StatefulWidget {
  const Records({super.key});

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

  final display = createDisplay(
    roundingType: RoundingType.floor,
    length: 15,
    decimal: 0,
  );

  Future<DateTimeRange?> pickDateRanges(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(hours: 24 * 3)),
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
    });
    return dateRange;
  }

  List<RecordsData> item1 = [];
  List<RecordsData> item2 = [];
  @override
  void initState() {
    super.initState();
    if (transactionController.value.value.contains("This Year")) {
      transactionController.getYearRecord();
    } else if (transactionController.value.value.contains("Today")) {
      transactionController.splitCurrentTime();
    } else if (transactionController.value.value.contains("This Week")) {
      transactionController.getWeeklyRecordData();
    } else if (transactionController.value.value.contains("This month")) {
      transactionController.getMonthlyRecord();
    } else if (transactionController.value.value.contains("This Month")) {
      transactionController.getMonthlyRecord();
    } else if (transactionController.value.value.contains("All Time")) {
      transactionController.getAllTimeRecord();
    }
  }

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
          'Records',
          style: GoogleFonts.inter(
            color: AppColors.backgroundColor,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        return Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
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
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${Utils.getCurrency()}${display(transactionController.recordMoneyIn)}",
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
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
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${Utils.getCurrency()}${display(transactionController.recordBalance)}",
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
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
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${Utils.getCurrency()}${display(transactionController.recordMoneyOut)}",
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
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
                      // start
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.orangeBorderColor),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Money Out (${Utils.getCurrency()})',
                                  style: GoogleFonts.inter(
                                    color: AppColors.blackColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.blueColor),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Money in (${Utils.getCurrency()})',
                                  style: GoogleFonts.inter(
                                    color: AppColors.blackColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const Insight());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.backgroundColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Insights",
                                  style: GoogleFonts.inter(
                                      fontSize: 11, color: Colors.white),
                                ),
                                const SizedBox(width: 4),
                                SvgPicture.asset(
                                  'assets/images/graph.svg',
                                  color: Colors.white,
                                  height: 15,
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  width: 2, color: AppColors.backgroundColor)),
                          child: DropdownButton<String>(
                            value: transactionController.value.value,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 14,
                              color: AppColors.backgroundColor,
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
                        // transactionController.value.toString() == 'Custom date range'
                        //     ? IconButton(
                        //         onPressed: () async {

                        //         },
                        //         icon: Icon(
                        //           Icons.date_range,
                        //           color: AppColors.backgroundColor,
                        //         ))
                        //     : Container()
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: SizedBox(
                      height: 200,
                      child: Obx(() {
                        // item1=removeDoubleItem(transactionController.allIncomeHoursData);
                        // item2=removeDoubleItem(transactionController.allExpenditureHoursData);
                        return SfCartesianChart(
                            primaryYAxis: NumericAxis(
                              // labelFormat: "${ Utils.getCurrency()}"
                              axisLabelFormatter: (s) => ChartAxisLabel(
                                  "${Utils.getCurrency()}${display(s.value)}",
                                  GoogleFonts.inter(fontSize: 10)),
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
                                  color: AppColors.blueColor,
                                  xValueMapper: (RecordsData value, _) =>
                                      value.label,
                                  yValueMapper: (RecordsData value, _) =>
                                      value.value,
                                  name: 'Sales',
                                  splineType: SplineType.cardinal,
                                  cardinalSplineTension: 0.9,
                                  // Enable data label
                                  dataLabelSettings: const DataLabelSettings(
                                      isVisible: false)),
                              SplineSeries<RecordsData, String>(
                                  dataSource: transactionController
                                      .allExpenditureHoursData
                                      .toList(),
                                  color: AppColors.orangeBorderColor,
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
                                        const Text("bb"),
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
                              style: GoogleFonts.inter(
                                color: AppColors.blackColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              (transactionController.value.value
                                      .contains("Custom date range"))
                                  ? transactionController.customText
                                  : transactionController.value.value,
                              style: GoogleFonts.inter(
                                color: AppColors.blackColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            final recordsData =
                                await DailyRecordPdfApi.generate();
                            Get.to(() => DownloadRecordReceipt(
                                  file: recordsData,
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.backgroundColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Download",
                                  style: GoogleFonts.inter(
                                      fontSize: 11, color: Colors.white),
                                ),
                                const SizedBox(width: 4),
                                SvgPicture.asset(
                                  'assets/images/download.svg',
                                  color: Colors.white,
                                  height: 15,
                                  width: 15,
                                ),
                              ],
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.backgroundColor.withOpacity(0.2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'DATE',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'MONEY OUT(${Utils.getCurrency()})',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'MONEY IN(${Utils.getCurrency()})',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Obx(() {
                    return (transactionController.recordMoneyIn == 0 &&
                            transactionController.recordMoneyOut == 0)
                        ? Expanded(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // SizedBox(height: 20),
                                  SvgPicture.asset(
                                    'assets/images/frown.svg',
                                    height: 40,
                                  ),
                                  Text(
                                    'Oh, snap. No transactions to show',
                                    style: GoogleFonts.inter(
                                      color: AppColors.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: transactionController
                                    .allExpenditureHoursData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item1 = transactionController
                                      .allExpenditureHoursData[index];
                                  var item2 = transactionController
                                      .allIncomeHoursData[index];

                                  return Visibility(
                                    visible:
                                        (item1.value != 0 || item2.value != 0),
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20))),
                                            context: context,
                                            builder: (context) =>
                                                buildRecordSummary(
                                                    item1, item2));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.015),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.1))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        item1.label,
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10,
                                                            color: AppColors
                                                                .blackColor),
                                                      ),
                                                      Text(
                                                        '',
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10,
                                                            color: AppColors
                                                                .backgroundColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "${Utils.getCurrency()}${display(item1.value)}",
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10,
                                                            color: AppColors
                                                                .orangeBorderColor),
                                                      ),
                                                      Text(
                                                        '',
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10,
                                                            color: AppColors
                                                                .backgroundColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "${Utils.getCurrency()}${display(item2.value)}",
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 10,
                                                                color: AppColors
                                                                    .blueColor),
                                                      ),
                                                      Text(
                                                        'View',
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10,
                                                            color: AppColors
                                                                .backgroundColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                  })
                ],
              ),
            ),
            // transactionController.transactionStatus == TransactionStatus.Loading
            //     ?

            // Container(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       CircularProgressIndicator(
            //         color: AppColors.backgroundColor,
            //       ),
            //       Text('Loading Data'),
            //     ],
            //   ),
            // )
            // : Container(),
          ],
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
                item1.label,
                style: GoogleFonts.inter(
                  color: AppColors.blackColor,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundColor.withOpacity(0.2)),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.backgroundColor,
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
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: AppColors.blackColor),
                        ),
                        Text(
                          item1.label,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: AppColors.blackColor),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Total Money Out',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: AppColors.blackColor),
                          ),
                          Text(
                            "${Utils.getCurrency()} ${display(item1.value)}",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: AppColors.orangeBorderColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Total Money In',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: AppColors.blackColor),
                          ),
                          Text(
                            "${Utils.getCurrency()} ${display(item2.value)}",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: AppColors.blueColor),
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
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
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
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName!,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: AppColors.blackColor),
                                ),
                                Text(
                                  item.createdTime!.formatDate()!,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: AppColors.blackColor),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${Utils.getCurrency()}${display(item.totalAmount)}",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: AppColors.blackColor),
                                ),
                                Text(
                                  item.isFullyPaid!
                                      ? "Fully Paid"
                                      : "Partially",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: AppColors.blackColor),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                              Get.to(() => MoneyHistory(
                                    item: item,
                                    pageCheck: false,
                                  ));
                            },
                            child: const Icon(
                              Icons.visibility,
                              color: AppColors.backgroundColor,
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
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: AppColors.blackColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Money Out',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: AppColors.blackColor),
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
                decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    'Filter',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
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
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      );

  List<RecordsData> removeDoubleItem(List<RecordsData> list) {
    List<RecordsData> newList = [];
    for (var element in list) {
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
    }
    return newList;
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
