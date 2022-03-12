import 'dart:io';
import 'package:get/get.dart';
import 'package:huzz/Repository/transaction_respository.dart';
import 'package:huzz/app/Utils/constants.dart';
import 'package:huzz/app/screens/widget/util.dart';
import 'package:huzz/model/record_receipt.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class RecordPdfApi {
  static Future<File> generate(RecordInvoice recordInvoice) async {
    final pdf = Document();
    var _transactionController = Get.find<TransactionRespository>();
    final huzzImgProvider =
        await imageFromAssetBundle('assets/images/huzz_logo.png');

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(_transactionController),
        SizedBox(height: PdfPageFormat.cm),
        buildMoneyInOutInvoice(recordInvoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTotal(recordInvoice),
        SizedBox(height: PdfPageFormat.cm),
        buildMoneyInTotal(recordInvoice),
        SizedBox(height: 20 * PdfPageFormat.cm),
      ],
    ));

    return PdfRecordApi.saveDocument(name: 'my_monthlyRecord.pdf', pdf: pdf);
  }

  static Widget buildHeader(TransactionRespository transactionRespository) =>
      Container(
        padding: EdgeInsets.all(20),
        child: Center(
            child: Text(
                'YOUR TRANSACTIONS(${transactionRespository.value.value})',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.black,
                    fontSize: 18))),
      );

  static Widget buildMoneyInOutInvoice(RecordInvoice recordInvoice) {
    final headers = [
      'DATE',
      'MONEY IN',
      'MONEY OUT',
    ];
    final data = recordInvoice.items.map((item) {
      return [
        item.date,
        '${Utils.formatPrice(item.moneyIn)}',
        '${Utils.formatPrice(item.moneyOut)}',
      ];
    }).toList();

    return Table.fromTextArray(
      cellPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      headerPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      headers: headers,
      data: data,
      border: null,
      cellStyle: TextStyle(
          fontWeight: FontWeight.bold, color: PdfColors.black, fontSize: 18),
      headerStyle: TextStyle(
          fontWeight: FontWeight.bold, color: PdfColors.white, fontSize: 18),
      headerDecoration: BoxDecoration(color: PdfColor.fromInt(0xff07A58E)),
      rowDecoration: BoxDecoration(color: PdfColors.grey100),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(RecordInvoice recordInvoice) {
    final moneyInTotal = recordInvoice.items
        .map((item) => item.moneyIn)
        .reduce((item1, item2) => item1 + item2);

    final moneyOutTotal = recordInvoice.items
        .map((item) => item.moneyOut)
        .reduce((item1, item2) => item1 + item2);

    final moneyINtotal = moneyInTotal;
    final moneyOUTtotal = moneyOutTotal;

    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(border: Border.all(color: PdfColors.orange)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: PdfColors.orange,
            child: Text(
              'TOTAL',
              style: TextStyle(
                color: PdfColors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            Utils.formatPrice(moneyINtotal),
            style: TextStyle(
              color: PdfColors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            Utils.formatPrice(moneyOUTtotal),
            style: TextStyle(
              color: PdfColors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  static Widget buildMoneyInTotal(RecordInvoice recordInvoice) {
    final moneyInTotal = recordInvoice.items
        .map((item) => item.moneyIn)
        .reduce((item1, item2) => item1 + item2);

    final moneyINtotal = moneyInTotal;

    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(color: PdfColor.fromInt(0xff07A58E))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: PdfColor.fromInt(0xff07A58E),
            child: Text(
              'AVAILABLE BALANCE',
              style: TextStyle(
                color: PdfColors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            Utils.formatPrice(moneyINtotal),
            style: TextStyle(
              color: PdfColors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

class DailyRecordPdfApi {
  static Future<File> generate() async {
    final pdf = Document();
    final transactionController = Get.find<TransactionRespository>();
    final range =
        "${(transactionController.value.contains("Custom date range")) ? transactionController.customText : transactionController.value.value}";
    final huzzImgProvider =
        await imageFromAssetBundle('assets/images/huzz_logo.png');
    final font = await PdfGoogleFonts.interRegular();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(range, font),
        SizedBox(height: PdfPageFormat.cm),
        buildMoneyInOutInvoice(transactionController, font),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildMoneyInTotal(transactionController, font),
        SizedBox(height: PdfPageFormat.cm),
        buildMoneyOutTotal(transactionController, font),
        SizedBox(height: PdfPageFormat.cm),
        buildTotal(transactionController, font),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildFooter(huzzImgProvider, font)
      ],
    ));

    return PdfRecordApi.saveDocument(
        name: 'huzz_record_for_${range.split(" ").join("_")}.pdf', pdf: pdf);
  }

  static buildFooter(pw.ImageProvider huzzImgProvider, Font font) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "POWERED BY",
        style: TextStyle(
          color: PdfColors.black,
        ),
      ),
      SizedBox(height: 7),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image(
          huzzImgProvider,
          height: 50,
          width: 50,
        ),
        SizedBox(width: 10),
        Text(
          "Huzz",
          style: TextStyle(
            color: PdfColor.fromInt(0xff07A58E),
            fontSize: 16,
            font: font,
          ),
        ),
      ])
    ]));
  }

  static Widget buildHeader(String range, Font font) => Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            'YOUR TRANSACTIONS ( $range )',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: PdfColors.black,
              font: font,
              fontSize: 20,
            ),
          ),
        ),
      );

  static Widget buildMoneyInOutInvoice(
      TransactionRespository transactionRespository, Font font) {
    final headers = [
      'Date',
      'Type',
      'Item',
      'Qty',
      'Amount',
      'Mode',
    ];
    List<List<dynamic>> data = [];
    for (int i = 0; i < transactionRespository.allIncomeHoursData.length; ++i) {
      var item1 = transactionRespository.allExpenditureHoursData[i];
      var item2 = transactionRespository.allIncomeHoursData[i];
      item1.transactionList.forEach((element) {
        element.businessTransactionPaymentItemList!.forEach((element1) {
          data.add([
            '${element.entryDateTime!.formatDate(pattern: "dd, MMM y")} ${element.entryDateTime!.formatDate(pattern: "hh:mm a")}',
            // element.entryDateTime!.formatDate(pattern: "hh:mm a"),
            element1.transactionType,
            element1.itemName ?? "",
            '${element1.quality}',
            '${Utils.formatPrice(element1.amount)}',
            element1.isFullyPaid! ? "FULL PAYMENT" : "PART PAYMENT",
          ]);
        });
      });
    }

// item2.transactionList.forEach((element) {
//   element.businessTransactionPaymentItemList!.forEach((element1) {

// data.add([
//   element.entryDateTime!.formatDate(pattern: "yymmdd"),
//         element.entryDateTime!.formatDate(pattern: "hh:mm"),
//         // item.type,
//         element1.itemName,
//         '${element1.quality}',
//         '\${ Utils.getCurrency()}${element1.amount}',
//         element1.isFullyPaid!?"Fully Paid":"Partily Paid",
// ]);
//   });

// });
    // final data = recordInvoice.items.map((item) {
    //   // ignore: unused_local_variable
    //   final total = item.amount * item.quantity;

    //   return [
    //     item.date,
    //     item.time,
    //     // item.type,
    //     item.itemName,
    //     '${item.quantity}',
    //     '\${ Utils.getCurrency()}${item.amount}',
    //     item.mode,
    //     // item.customerName,
    //   ];
    // }).toList();

    return Table.fromTextArray(
      cellPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: PdfColors.white,
        fontSize: 14,
        font: font,
      ),
      cellStyle: TextStyle(
        color: PdfColors.black,
        fontSize: 10,
        font: font,
      ),
      headerDecoration: BoxDecoration(
        color: PdfColor.fromInt(0xff07A58E),
      ),
      cellDecoration: (_, __, ___) => BoxDecoration(
        color: PdfColors.grey100,
        border: Border.symmetric(
            vertical: BorderSide(
          color: PdfColors.white,
          width: 1.2,
        )),
      ),
      cellHeight: 40,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(
      TransactionRespository transactionRespository, Font font) {
    // final amountTotal = recordInvoice.items
    //     .map((item) => item.amount * item.quantity)
    //     .reduce((item1, item2) => item1 + item2);

    // final total = amountTotal;

    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(color: PdfColor.fromInt(0xffEF6500))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: PdfColor.fromInt(0xffEF6500),
            child: Text(
              'AVAILABLE BALANCE',
              style: TextStyle(
                color: PdfColors.white,
                fontSize: 15,
                font: font,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              Utils.formatPrice(transactionRespository.recordBalance),
              style: TextStyle(
                color: PdfColors.black,
                fontSize: 15,
                font: font,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget buildMoneyInTotal(
      TransactionRespository transactionRespository, Font font) {
    // final moneyInTotal = recordInvoice.items
    //     .map((item) => item.amount)
    //     .reduce((item1, item2) => item1 + item2);

    // final moneyINtotal = moneyInTotal;

    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(color: PdfColor.fromInt(0xff07A58E))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: PdfColor.fromInt(0xff07A58E),
            child: Text(
              'TOTAL MONEY IN',
              style: TextStyle(
                color: PdfColors.white,
                fontSize: 15,
                font: font,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              Utils.formatPrice(transactionRespository.recordMoneyIn),
              style: TextStyle(
                color: PdfColors.black,
                fontSize: 15,
                font: font,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget buildMoneyOutTotal(
      TransactionRespository transactionRespository, Font font) {
    // final moneyInTotal = recordInvoice.items
    //     .map((item) => item.amount)
    //     .reduce((item1, item2) => item1 + item2);

    // final moneyINtotal = moneyInTotal;

    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          border: Border.all(color: PdfColor.fromInt(0xff07A58E))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: PdfColor.fromInt(0xff07A58E),
            child: Text(
              'TOTAL MONEY OUT',
              style: TextStyle(
                color: PdfColors.white,
                font: font,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              Utils.formatPrice(transactionRespository.recordMoneyOut),
              style: TextStyle(
                color: PdfColors.black,
                font: font,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

class PdfRecordApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
