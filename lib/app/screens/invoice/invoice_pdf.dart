import 'dart:io';
import 'package:get/get.dart';
import 'package:huzz/Repository/bank_account_repository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/customer_repository.dart';
import 'package:huzz/app/Utils/constants.dart';
import 'package:huzz/app/screens/widget/util.dart';
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
import 'package:printing/printing.dart';

class PdfInvoiceApi {
  static final _businessController = Get.find<BusinessRespository>();
  static final _customerController = Get.find<CustomerRepository>();
  static final _bankController = Get.find<BankAccountRepository>();
  static final display = createDisplay(
      length: 5,
      decimal: 0,
      placeholder: '${utils.Utils.getCurrency()}',
      units: ['K', 'M', 'B', 'T']);

  static Future<File> generate(Invoice invoice, PdfColor themeColor) async {
    final pdf = Document();
    var customer = _customerController
        .checkifCustomerAvailableWithValue(invoice.customerId!);
    print("bank id ${invoice.bankId}");
    var bank = _bankController.checkifBankAvailableWithValue(invoice.bankId!);

    final selectedBusiness = _businessController.selectedBusiness.value!;
    pw.ImageProvider? businessImgProvider;
    if (selectedBusiness.buisnessLogoFileStoreId != null &&
        selectedBusiness.buisnessLogoFileStoreId!.isNotEmpty) {
      businessImgProvider =
          await networkImage(selectedBusiness.buisnessLogoFileStoreId!);
    }

    final huzzImgProvider =
        await imageFromAssetBundle('assets/images/huzz_logo.png');

    final pdfFont = await PdfGoogleFonts.interRegular();

    pdf.addPage(MultiPage(
      theme: ThemeData.withFont(base: pdfFont),
      build: (context) => [
        buildHeader(
            selectedBusiness, businessImgProvider, bank, invoice, themeColor),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildInvoice(invoice, themeColor),
        SizedBox(height: 20),
        buildSubTotal(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildTotal(invoice, themeColor),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildFooter(customer, invoice, huzzImgProvider, themeColor)
      ],
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(
          Business business,
          pw.ImageProvider? businessImgProvider,
          Bank? bank,
          Invoice invoice,
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
                  buildSupplierAddress(
                      business, businessImgProvider, themeColor),
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

  static Widget buildSupplierAddress(Business business,
      pw.ImageProvider? businessImgProvider, PdfColor themeColor) {
    print("business is ${business.businessName}");

    return Column(
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
                    business.businessName![0],
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
          (bankDetails != null)
              ? Text(bankDetails.bankAccountName!,
                  style: TextStyle(color: PdfColors.white, fontSize: 10))
              : pw.Container(),
          (bankDetails != null)
              ? Text(bankDetails.bankAccountNumber!,
                  style: TextStyle(color: PdfColors.white, fontSize: 10))
              : pw.Container(),
          (bankDetails != null)
              ? Text(bankDetails.bankName!,
                  style: TextStyle(color: PdfColors.white, fontSize: 10))
              : pw.Container(),
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

  static Widget buildInvoice(Invoice invoice, PdfColor themeColor) {
    final headers = [
      'Item',
      'Qty',
      'Amount',
    ];
    final data = invoice.paymentItemRequestList!.map((item) {
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

  static Widget buildTotal(Invoice invoice, PdfColor themeColor) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: PdfColors.orange,
            child: Text(
              'TOTAL',
              style: TextStyle(
                color: PdfColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: Get.width * 0.15),
          Text(
            "${Utils.formatPrice(invoice.totalAmount)}",
            style: TextStyle(
              color: themeColor,
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (invoice.note == null || invoice.note == '')
              ? Container()
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Comment',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("${invoice.note}"),
                ]),
          Spacer(),
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
              'Discount',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(width: Get.width * 0.20),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(
              "${Utils.formatPrice(totalAmount)}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${Utils.formatPrice(invoice.tax)}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${Utils.formatPrice(invoice.discountAmount)}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ])
        ]);
  }

  static Widget buildFooter(Customer? customer, Invoice invoice,
      pw.ImageProvider huzzImgProvider, PdfColor themeColor) {
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
                color: PdfColors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ])
        ])
      ]),
      SizedBox(height: 1 * PdfPageFormat.cm),
      if (lists.isNotEmpty) ...[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
        Divider(color: themeColor),
      ],
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
                      e.paymentSource ?? "CASH",
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
