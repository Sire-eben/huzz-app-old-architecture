import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/transaction_respository.dart';
import 'package:huzz/app/screens/home/wordclass.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/recordData.dart';
import 'package:huzz/model/records_model.dart';
import 'package:number_display/number_display.dart';
import 'package:random_color/random_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'transaction_history.dart';

class Insight extends StatefulWidget {
  @override
  _InsightState createState() => _InsightState();
}

class _InsightState extends State<Insight> {
  DateTimeRange? dateRange;
 final transactionController = Get.find<TransactionRespository>();
  
 
  final recordFilter = [
    'Today',
    'This Week',
    'This month',
    'This Year',
    'All Time',
    'Custom date range'
  ];
    final display = createDisplay(
    length: 5,
    decimal: 0,
    placeholder: 'N',
    units: ['K','M','B','T']
  );

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
      print(dateRange);    });
return dateRange;
    
  }
  List<RecordsData> item1=[];
  List<RecordsData> item2=[];
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

  List<_PieChartData> pieMoneyIn = [
    _PieChartData('Mon', 35, AppColor().orangeBorderColor),
    _PieChartData('Tue', 28, AppColor().wineColor),
    _PieChartData('Wed', 34, AppColor().backgroundColor),
    _PieChartData('Thur', 32, AppColor().blueColor),
    _PieChartData('Fri', 40, AppColor().lightblueColor),
    _PieChartData('Sat', 28, AppColor().purpleColor),
    _PieChartData('Sun', 32, AppColor().brownColor)
  ];

  List<_PieChartData> pieMoneyOut = [
    _PieChartData('Mon', 15, AppColor().orangeBorderColor),
    _PieChartData('Tue', 10, AppColor().wineColor),
    _PieChartData('Wed', 40, AppColor().backgroundColor),
    _PieChartData('Thur', 32, AppColor().blueColor),
    _PieChartData('Fri', 20, AppColor().lightblueColor),
    _PieChartData('Sat', 15, AppColor().purpleColor),
    _PieChartData('Sun', 32, AppColor().brownColor)
  ];
    List<RecordsData> removeDoubleItem(List<RecordsData> list){
print("previous items lenght ${list.length}");
 List<RecordsData> newList=[];
list.forEach((element) {
  

if(element.value>0){

  newList.add(element);
}
});






print("new item list is ${newList.length}");
return newList;

}
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
transactionController.splitCurrentTime();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
       () {

                  item1=removeDoubleItem(transactionController.allIncomeHoursData);
         item2=removeDoubleItem(transactionController.allExpenditureHoursData);
             var paymentList1=transactionController .getAllPaymentItemListForIncomeRecord();
             var paymentList2=transactionController.getAllPaymentItemListForExpenditure();

          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.04,
                        left: MediaQuery.of(context).size.height * 0.005,
                        right: MediaQuery.of(context).size.height * 0.005),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColor().backgroundColor,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Insight',
                              style: TextStyle(
                                color: AppColor().backgroundColor,
                                fontFamily: "DMSans",
                                fontStyle: FontStyle.normal,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
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
                                  'Today',
                                  style: TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                isDense: true,
                                items: recordFilter.map(buildDropDown).toList(),
                                onChanged: (value){                            
                                  setState(() => this.value = value);
                                if(value!.contains("This Year")){
                              transactionController.getYearRecord();
          
                                }else if(value.contains("Today")){
                                transactionController.splitCurrentTime();
          
                                }else if(value.contains("This Week")){
                                transactionController.getWeeklyRecordData();
          
                                }else if(value.contains("This month")){
                                transactionController.getMonthlyRecord();
          
                                }else if(value.contains("This Month")){
          
                               transactionController.getMonthlyRecord();
          
                                }else if(value.contains("All Time")){
          
                                  transactionController.getAllTimeRecord();
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
                           value.toString() == 'Custom date range' ? IconButton(onPressed: ()async{
                           DateTimeRange? val=await pickDateRanges(context);
                           if(val!=null){
                          transactionController.getDateRangeRecordData(val.start, val.end);
          
                           }
                          }, icon: Icon(Icons.date_range, color: AppColor().backgroundColor,)) : Container() 
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                              primaryXAxis: CategoryAxis(),
          
                              // Chart title
                              // title: ChartTitle(text: 'Half yearly sales analysis'),
                              // Enable legend
                              legend: Legend(isVisible: false),
                              // Enable tooltip
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <ChartSeries<RecordsData, String>>[
                                SplineSeries<RecordsData, String>(
                                    dataSource:
                                        transactionController.allIncomeHoursData.toList(),
                                    color: AppColor().blueColor,
                                    xValueMapper: (RecordsData value, _) => value.label,
                                    yValueMapper: (RecordsData value, _) => value.value,
                                    name: 'Sales',
                                    splineType: SplineType.cardinal,
                                    cardinalSplineTension: 0.9,
                                    // Enable data label
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: false)),
                                SplineSeries<RecordsData, String>(
                                    dataSource:
                                        transactionController.allExpenditureHoursData.toList(),
                                    color: AppColor().orangeBorderColor,
                                    xValueMapper: (RecordsData value, _) => value.label,
                                    yValueMapper: (RecordsData value, _) => value.value,
                                    name: 'Value',
                                    splineType: SplineType.cardinal,
                                    cardinalSplineTension: 0.9,
                                    // Enable data label
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: false)),
                              ]);
                        }),
                      ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: Divider(),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: Text(
                      'Transaction Distribution',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: 'DMSans',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Income',
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontFamily: 'DMSans',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 200,
                              child: SfCircularChart(
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <CircularSeries>[
                                    PieSeries<RecordsData, String>(
                                        dataSource:item1,
                                        pointColorMapper: (RecordsData data, _) =>
                                            data.color!,
                                        xValueMapper: (RecordsData data, _) =>
                                            data.label,
                                        yValueMapper: (RecordsData data, _) =>
                                            data.value,
                                        dataLabelSettings:
                                            DataLabelSettings(isVisible: true)),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Expenses',
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontFamily: 'DMSans',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: 200,
                              child: SfCircularChart(
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <CircularSeries>[
                                    PieSeries<RecordsData, String>(
                                        dataSource: item2,
                                        pointColorMapper: (RecordsData data, _) =>
                                            data.color!,
                                        xValueMapper: (RecordsData data, _) =>
                                            data.label,
                                        yValueMapper: (RecordsData data, _) =>
                                            data.value,
                                        dataLabelSettings:
                                            DataLabelSettings(isVisible: true)),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
               
                            SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: Column(
                      children: [
                           Text(
                              'Income',
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontFamily: 'DMSans',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:item1.map((e)=>
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: e.color),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  '${e.label}',
                                  style: TextStyle(
                                    color: AppColor().blackColor,
                                    fontFamily: 'DMSans',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                               SizedBox(width: 5,) 
                              ],
                            )).toList(),
                            
                          
                        ),
                      ],
                    ),
                  ),
     
                            SizedBox(height: 10,),
                   Padding( 
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: Column(
                      children: [
                          Text(
                              'Expenses',
                              style: TextStyle(
                                color: AppColor().blackColor,
                                fontFamily: 'DMSans',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:item2.map((e)=>
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: e.color),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  '${e.label}',
                                  style: TextStyle(
                                    color: AppColor().blackColor,
                                    fontFamily: 'DMSans',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                               SizedBox(width: 5,) 
                              ],
                            )).toList(),
                            
                          
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: Text(
                      'Popular Items',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: 'DMSans',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Income',
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'DMSans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10,),
                             Container(child: WordCloud(paymentList1))
                            ],
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Expenses',
                                style: TextStyle(
                                  color: AppColor().blackColor,
                                  fontFamily: 'DMSans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10,),
                              WordCloud(paymentList2)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    child: Text(
                      'Statistics',
                      style: TextStyle(
                        color: AppColor().backgroundColor,
                        fontFamily: 'DMSans',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height * 0.03),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              StatisticsWidget(
                                image: 'assets/images/income_transaction.svg',
                                color: AppColor().blueColor,
                                amount: item1.length.toString(),
                                name1: 'Income',
                                name2: 'Transaction',
                                message:
                                    'Total number of\nincome transactions\nfor the selected period',
                              ),
                              SizedBox(width: 10),
                              StatisticsWidget(
                                image: 'assets/images/expense_transaction.svg',
                                color: AppColor().orangeBorderColor,
                                amount:item2.length.toString(),
                                name1: 'Expense',
                                name2: 'Transaction',
                                message: '',
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              StatisticsWidget(
                                image: 'assets/images/total_income.svg',
                                color: AppColor().backgroundColor,
                                amount: '₦'+display(transactionController.recordMoneyIn),
                                name1: 'Total',
                                name2: 'Income',
                                message: '',
                              ),
                              SizedBox(width: 10),
                              StatisticsWidget(
                                image: 'assets/images/total_expense.svg',
                                color: AppColor().blackColor,
                                amount: '₦'+display(transactionController.recordMoneyOut),
                                name1: 'Total',
                                name2: 'Expenses',
                                message: '',
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              StatisticsWidget(
                                image: 'assets/images/average_income.svg',
                                color: AppColor().purpleColor,
                                amount:'₦'+display((transactionController.recordMoneyIn/item1.length)),
                                name1: 'Average income',
                                name2: 'per transaction',
                                message: '',
                              ),
                              SizedBox(width: 10),
                              StatisticsWidget(
                                image: 'assets/images/average_expenses.svg',
                                color: AppColor().wineColor,
                                amount:'₦'+display((transactionController.recordMoneyOut/item2.length)),
                                name1: 'Average expenses',
                                name2: 'per transaction',
                                message: '',
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     StatisticsWidget(
                          //       image: 'assets/images/net_income.svg',
                          //       color: AppColor().lightblueColor,
                          //       amount: 50,
                          //       name1: 'Net income',
                          //       name2: '',
                          //       message: '',
                          //     ),
                          //     SizedBox(width: 10),
                          //     StatisticsWidget(
                          //       image: 'assets/images/h_income_transaction.svg',
                          //       color: AppColor().brownColor,
                          //       amount: 50,
                          //       name1: 'Highest income',
                          //       name2: 'transaction',
                          //       message: '',
                          //     ),
                          //   ],
                          // ),
                        ],
                      )),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

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

class StatisticsWidget extends StatelessWidget {
  final String? image, name1, name2, message;
  final String? amount;
  final Color? color;

  const StatisticsWidget(
      {Key? key,
      this.image,
      this.name1,
      this.name2,
      this.message,
      this.amount,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Tooltip(
                waitDuration: Duration(microseconds: 0),
                showDuration: Duration(microseconds: 0),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black38, blurRadius: 10)
                    ]),
                textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'DMSans',
                    fontSize: 10,
                    color: Colors.black),
                preferBelow: false,
                message: message!,
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 10,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SvgPicture.asset(
                    image!,
                    height: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      Text(
                        amount!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DMSans',
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      Text(
                        name1!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DMSans',
                            fontSize: 8,
                            color: Colors.white),
                      ),
                      Text(
                        name2!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DMSans',
                            fontSize: 8,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }



}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _PieChartData {
  _PieChartData(this.year, this.sales, [this.color]);
  final String year;
  final double sales;
  final Color? color;
}
