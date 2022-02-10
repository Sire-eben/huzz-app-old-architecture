import 'dart:io';
import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/app/screens/widget/util.dart';
import 'package:huzz/model/business.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:huzz/model/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfTransactionApi {
  // ignore: avoid_init_to_null
  static Customer? customer = null;
  static final _businessController = Get.find<BusinessRespository>();
  static final _customerController = Get.find<CustomerRepository>();
  static Future<File> generate(TransactionModel transactionModel) async {
    final pdf = Document();
    if (transactionModel.customerId != null)
      customer = _customerController
          .checkifCustomerAvailableWithValue(transactionModel.customerId!);

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(_businessController.selectedBusiness.value!),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildMoneyInOutInvoice(
            transactionModel.businessTransactionPaymentItemList!),
        Divider(),
        buildTotal(transactionModel.businessTransactionPaymentItemList!),
        SizedBox(height: PdfPageFormat.cm),
        buildSummaryTotal(transactionModel.businessTransactionPaymentItemList!,
            transactionModel.totalAmount, transactionModel.balance),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildFooter(customer)
      ],
      // footer: (context) => buildFooter(moneyInvoice),
    ));

    return PdfApi.saveDocument(name: 'my_transaction.pdf', pdf: pdf);
  }

  static Widget buildHeader(Business item) => Container(
      padding: EdgeInsets.all(20),
      color: PdfColors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(item),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('RECEIPT',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: PdfColors.white)),
                Text(DateFormat.yMMMd().format(DateTime.now()).toString(),
                    style: TextStyle(color: PdfColors.white)),
              ]),
            ],
          ),
        ],
      ));

  static Widget buildCustomerAddress(Customer? customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer!.name!, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.phone!),
        ],
      );

  static Widget buildSupplierAddress(Business item) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 40,
              width: 40,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: PdfColors.white),
              child: Center(
                child: Text(item.businessName![0],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.blue)),
              )),
          Text(item.businessName!,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: PdfColors.white)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(item.businessEmail ?? "",
              style: TextStyle(color: PdfColors.white)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(item.businessPhoneNumber!,
              style: TextStyle(color: PdfColors.white)),
        ],
      );

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(""),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildMoneyInOutInvoice(List<PaymentItem> items) {
    final headers = [
      'Item',
      'Qty',
      'Amount',
    ];
    final data = items.map((item) {
      // ignore: unused_local_variable
      final total = item.totalAmount;

      return [
        item.itemName,
        '${item.quality}',
        '\NGN${item.amount}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle:
          TextStyle(fontWeight: FontWeight.bold, color: PdfColors.blue),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
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

  static Widget buildTotal(List<PaymentItem> items) {
    dynamic netTotal = 0;
    // items
    //     .map((item) => item.amount! * item.quality!)
    //     .reduce((item1, item2) => item1 + item2);
    items.forEach((element) {
      netTotal = netTotal + (element.amount! * element.quality!);
    });

    final total = netTotal;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: PdfColors.orange,
            child: Text(
              'Total',
              style: TextStyle(
                color: PdfColors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            Utils.formatPrice(total * 1.0),
            style: TextStyle(
              color: PdfColors.blue,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  static Widget buildSummaryTotal(
      List<PaymentItem> items, dynamic amount, dynamic balance) {
    dynamic netTotal = 0;

    items.forEach((element) {
      netTotal = netTotal + (element.amount! * element.quality!);
    });

    final total = netTotal;

    return Container(
        alignment: Alignment.centerRight,
        child: Column(children: [
          Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PARTLY PAID:',
                style: TextStyle(
                  color: PdfColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Utils.formatPrice(amount - balance),
                style: TextStyle(
                  color: PdfColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(height: PdfPageFormat.mm),
          Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Outstanding:',
                style: TextStyle(
                  color: PdfColors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Utils.formatPrice(balance * 1.0),
                style: TextStyle(
                  color: PdfColors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ]));
  }

  static Widget buildFooter(Customer? customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 2 * PdfPageFormat.mm),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            (customer != null)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          'ISSUED TO:',
                          style: TextStyle(
                            color: PdfColors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(customer.name!),
                        Text(customer.phone!),
                      ])
                : Container(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('POWERED BY:'),
              Text(
                'HUZZ',
                style: TextStyle(
                  color: PdfColors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ])
          ]),
          SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Paypal', value: moneyInvoice.supplier.mail),
        ],
      );

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

class PdfApi {
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
