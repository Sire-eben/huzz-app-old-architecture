import 'dart:io';
import 'package:huzz/ui/widget/util.dart';
import 'package:huzz/data/model/invoice_receipt_model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class SingleInvoicePdf {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(),
        buildSubTotal(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildTotal(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildFooter(invoice)
      ],
    ));

    return PdfApi.saveDocument(name: 'invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Container(
      padding: EdgeInsets.all(20),
      color: PdfColors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              buildBankDetails(invoice.bankDetails),
            ],
          ),
        ],
      ));

  static Widget buildCustomerAddress(InvoiceCustomer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.phone),
        ],
      );

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 40,
              width: 40,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: PdfColors.white),
              child: Center(
                child: Text(supplier.name[0],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.blue)),
              )),
          Text(supplier.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: PdfColors.white)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.mail, style: TextStyle(color: PdfColors.white)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.phone, style: TextStyle(color: PdfColors.white)),
        ],
      );

  static Widget buildBankDetails(BankDetails bankDetails) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('INVOICE',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 16)),
            SizedBox(width: 1 * PdfPageFormat.mm),
            Text('#61144',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 16)),
          ]),
          Text(DateFormat.yMMMd().format(DateTime.now()).toString(),
              style: TextStyle(color: PdfColors.white, fontSize: 10)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text('Mode of Payment',
              style: TextStyle(color: PdfColors.white, fontSize: 10)),
          Text(bankDetails.mode,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: PdfColors.white)),
          Text(bankDetails.name,
              style: TextStyle(color: PdfColors.white, fontSize: 10)),
          Text(bankDetails.no,
              style: TextStyle(color: PdfColors.white, fontSize: 10)),
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
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Item',
      'Qty',
      'Amount',
    ];
    final data = invoice.items.map((item) {
      final total = item.amount * item.quantity;

      return [
        item.item,
        '${item.quantity}',
        '${Utils.formatPrice(item.amount)}',
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
    final netTotal = invoice.items
        .map((item) => item.amount * item.quantity)
        .reduce((item1, item2) => item1 + item2);

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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            Utils.formatPrice(total),
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

  static Widget buildSubTotal(Invoice invoice) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Issue Date',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat.yMMMd().format(DateTime.now()).toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Due Date',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat.yMMMd().format(DateTime.now()).toString(),
            style: TextStyle(
              color: PdfColors.orange,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Sub-total',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Tax (0%)',
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
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            '${Utils.formatPrice(150000)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${Utils.formatPrice(2000)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${Utils.formatPrice(1000)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ])
      ]);

  static Widget buildFooter(Invoice invoice) =>
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
          Text(invoice.customer.name),
          Text(invoice.customer.phone),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: PdfColors.orange),
                color: PdfColors.orange50),
            child: Text('Pending',
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
      ]);
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
