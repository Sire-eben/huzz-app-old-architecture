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
import 'package:huzz/app/Utils/util.dart' as format;
import 'package:printing/printing.dart';

class PdfMoneyInOutApi {
  // ignore: avoid_init_to_null

  static final _businessController = Get.find<BusinessRespository>();
  static final _customerController = Get.find<CustomerRepository>();
  static Future<File> generate(
      TransactionModel transactionModel, PdfColor themeColor) async {
    final pdf = Document();
    Customer? customer;
    if (transactionModel.customerId != null) {
      print("my customer id ${transactionModel.customerId}");
      customer = _customerController
          .checkifCustomerAvailableWithValue(transactionModel.customerId!);
    }
    final selectedBusiness = _businessController.selectedBusiness.value!;
    pw.ImageProvider? businessImgProvider;
    if (selectedBusiness.buisnessLogoFileStoreId != null &&
        selectedBusiness.buisnessLogoFileStoreId!.isNotEmpty) {
      businessImgProvider =
          await networkImage(selectedBusiness.buisnessLogoFileStoreId!);
    }

    final huzzImgProvider =
        await imageFromAssetBundle('assets/images/huzz_logo.png');

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(selectedBusiness, businessImgProvider, themeColor),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildMoneyInOutInvoice(
            transactionModel.businessTransactionPaymentItemList!, themeColor),
        SizedBox(height: 20),
        buildTotal(
            transactionModel.businessTransactionPaymentItemList!, themeColor),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildFooter(customer, huzzImgProvider, themeColor)
      ],
    ));

    return PdfApi.saveDocument(name: 'receipt.pdf', pdf: pdf);
  }

  static Widget buildHeader(Business item, ImageProvider? businessImgProvider,
          PdfColor themeColor) =>
      Container(
          padding: EdgeInsets.all(20),
          color: themeColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSupplierAddress(item, businessImgProvider, themeColor),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('RECEIPT',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: PdfColors.white)),
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

  static Widget buildSupplierAddress(Business item,
          ImageProvider? businessImgProvider, PdfColor themeColor) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PdfColors.white,
                image: businessImgProvider != null
                    ? pw.DecorationImage(image: businessImgProvider)
                    : null),
            child: businessImgProvider == null
                ? Center(
                    child: Text(
                      item.businessName![0],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                  )
                : null,
          ),
          pw.SizedBox(height: 8),
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

  static Widget buildMoneyInOutInvoice(
      List<PaymentItem> items, PdfColor themeColor) {
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
        '${Utils.formatPrice(item.amount)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      cellStyle: TextStyle(fontSize: 15),
      headerStyle: TextStyle(
          fontWeight: FontWeight.bold, color: themeColor, fontSize: 20),
      cellHeight: 38,
      cellDecoration: (r, __, c) {
        return c == data.length
            ? pw.BoxDecoration(
                border: Border.symmetric(
                horizontal: pw.BorderSide(color: themeColor, width: 2),
              ))
            : pw.BoxDecoration(
                border: Border(top: pw.BorderSide(color: themeColor, width: 2)),
              );
      },
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

  static Widget buildTotal(List<PaymentItem> items, PdfColor themeColor) {
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
              color: themeColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  static Widget buildFooter(Customer? customer,
          pw.ImageProvider huzzImgProvider, PdfColor themeColor) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 2 * PdfPageFormat.mm),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (customer != null)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'ISSUED TO:',
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                Text("${customer.name}"),
                Text("${customer.phone}"),
              ])
            else
              pw.SizedBox(),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'POWERED BY:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 7),
              pw.Row(children: [
                pw.Image(huzzImgProvider, height: 27, width: 27),
                pw.SizedBox(width: 7),
                Text(
                  'Huzz',
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])
            ])
          ]),
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
