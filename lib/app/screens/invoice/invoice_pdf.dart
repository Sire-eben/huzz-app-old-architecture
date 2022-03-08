import 'dart:io';

import 'package:get/get.dart';
import 'package:huzz/Repository/bank_account_repository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/app/Utils/constants.dart';
import 'package:huzz/app/screens/widget/util.dart' ;
import 'package:huzz/app/Utils/util.dart' as utils;
import 'package:huzz/model/bank.dart';
import 'package:huzz/model/business.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/invoice.dart';
import 'package:huzz/model/payment_history.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static final _businessController = Get.find<BusinessRespository>();
  static final _customerController = Get.find<CustomerRepository>();
  static final _bankController = Get.find<BankAccountRepository>();
  static final display = createDisplay(
      length: 5, decimal: 0, placeholder: '${ utils.Utils.getCurrency()}', units: ['K', 'M', 'B', 'T']);

  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    var customer = _customerController
        .checkifCustomerAvailableWithValue(invoice.customerId!);
    print("bank id ${invoice.bankId}");
    var bank = _bankController.checkifBankAvailableWithValue(invoice.bankId!);

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(bank, invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(),
        buildSubTotal(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildTotal(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildFooter(customer, invoice)
      ],
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Bank? bank, Invoice invoice) => Container(
      padding: EdgeInsets.all(20),
      color: PdfColors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(_businessController.selectedBusiness.value!),
              buildBankDetails(bank, invoice),
            ],
          ),
        ],
      ));

  static Widget buildCustomerAddress(Customer? customer) {
    print("consumer ${customer!.name}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ade", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("086"),
      ],
    );
  }

  static Widget buildSupplierAddress(Business business) {
    print("business is ${business.businessName}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 40,
            width: 40,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: PdfColors.white),
            child: Center(
              child: Text(business.businessName![0],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.blue)),
            )),
        Text(business.businessName ?? "",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: PdfColors.white)),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(business.businessEmail ?? "",
            style: TextStyle(color: PdfColors.white)),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(business.businessPhoneNumber ?? "",
            style: TextStyle(color: PdfColors.white)),
      ],
    );
  }

  static Widget buildBankDetails(Bank? bankDetails, Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('INVOICE',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 16)),
            SizedBox(width: 1 * PdfPageFormat.mm),
            Text('#${invoice.id!.substring(1, 6)}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 16)),
          ]),
          Text(
              'Issued Date:' +
                  DateFormat.yMMMd().format(DateTime.now()).toString(),
              style: TextStyle(color: PdfColors.white, fontSize: 10)),
          Text(
              'Due Date:' +
                  DateFormat.yMMMd().format(invoice.dueDateTime!).toString(),
              style: TextStyle(color: PdfColors.white, fontSize: 10)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text('Mode of Payment',
              style: TextStyle(color: PdfColors.white, fontSize: 10)),
          Text("Transfer",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: PdfColors.white)),
       (bankDetails!=null)?   Text(bankDetails.bankAccountName!,
              style: TextStyle(color: PdfColors.white, fontSize: 10)):pw.Container(),
          (bankDetails!=null)?   Text(bankDetails.bankAccountNumber!,
              style: TextStyle(color: PdfColors.white, fontSize: 10)):pw.Container(),
          (bankDetails!=null)?   Text(bankDetails.bankName!,
              style: TextStyle(color: PdfColors.white, fontSize: 10)):pw.Container(),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          // Text(invoice.info.description),
          // SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Item',
      'Qty',
      'Amount',
    ];
    final data = invoice.paymentItemRequestList!.map((item) {
      // final total = item.amount! * item.quality!;
      print("item name ${item.itemName}");
      return [
        '${item.itemName}',
        '${item.quality}',
        '${Utils.formatPrice(item.totalAmount)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      cellStyle: TextStyle(fontSize: 15),
      headerStyle: TextStyle(
          fontWeight: FontWeight.bold, color: PdfColors.blue, fontSize: 20),
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

  static Widget buildTotal(Invoice invoice) {
    // final netTotal = invoice.paymentItemRequestList!
    //     .map((item) => item.amount! * item.quality!)
    //     .reduce((item1, item2) => item1 + item2);

    final total = 0;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: PdfColors.orange,
            child: Text(
              'Total',
              style: TextStyle(
                color: PdfColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "${Utils.formatPrice(invoice.totalAmount)}",
            style: TextStyle(
              color: PdfColors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  static Widget buildSubTotal(Invoice invoice) {
    dynamic totalAmount = 0;
    invoice.paymentItemRequestList!.forEach((element) {
      totalAmount = totalAmount + element.totalAmount!;
    });
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //   Text(
      //     'COMMENTS',
      //     style: TextStyle(
      //       fontSize: 10,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   Text(
      //     '1. Payment should not exceed 30 days',
      //     style: TextStyle(
      //       fontSize: 7,
      //     ),
      //   ),
      //   Text(
      //     '2. Please note your invoice no in your payment',
      //     style: TextStyle(
      //       fontSize: 7,
      //     ),
      //   ),
      // ]),

      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Sub-total',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Tax',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'DIscount',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
      SizedBox(width: Get.width * 0.20),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(
          '$totalAmount',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${invoice.tax}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          ' ${invoice.discountAmount}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ])
    ]);
  }

  static Widget buildFooter(Customer? customer, Invoice invoice) {
    List<PaymentHistory> lists = invoice.businessTransaction == null ||
            invoice.businessTransaction!
                    .businessTransactionPaymentHistoryList ==
                null ||
            invoice.businessTransaction!.businessTransactionPaymentHistoryList!
                .isEmpty
        ? []
        : invoice.businessTransaction!.businessTransactionPaymentHistoryList!;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'ISSUED TO:',
            style: TextStyle(
              color: PdfColors.blue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("${customer!.name}"),
          Text("${customer.phone}"),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: PdfColors.orange),
                color: PdfColors.orange50),
            child: Text(('${invoice.businessInvoiceStatus}'),
                style: TextStyle(color: PdfColors.orange, fontSize: 12)),
          )
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            'POWERED BY:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
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
      SizedBox(height: 1 * PdfPageFormat.cm),
      lists.isEmpty
          ? pw.Container()
          : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Amount Paid',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Mode of Payment',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
      Divider(),
      ...lists
          .map<pw.Widget>((e) => pw.Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Text(
                      e.createdDateTime!.formatDate()!,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '${Utils.formatPrice(e.amountPaid)}',
                      style: TextStyle(
                        fontSize: 10,
                        color: PdfColors.orange,
                      ),
                    ),
                    Text(
                      e.paymentSource!,
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ])))
          .toList(),
    ]);
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
