import 'dart:io';
import 'package:huzz/app/screens/widget/util.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:huzz/model/reciept_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
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

  static Widget buildCustomerAddress(Customer customer) => Column(
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
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            Utils.formatPrice(total),
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

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 2 * PdfPageFormat.mm),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'ISSUED TO:',
                style: TextStyle(
                  color: PdfColors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(invoice.customer.name),
              Text(invoice.customer.phone),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('POWERED BY:'),
              Row(children: [
                Text(
                  'HUZZ',
                  style: TextStyle(
                    color: PdfColors.blue,
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
            ])
          ]),
          SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.mail),
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
