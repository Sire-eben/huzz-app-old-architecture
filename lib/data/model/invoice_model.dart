class Invoice {
  String? name, price, details, date;
  Invoice({this.details, this.name, this.price, this.date});
}

List<Invoice> invoiceList = [
  Invoice(
      name: 'Labour',
      price: 'N20,000',
      details: 'DEPOSIT',
      date: '23, NOV. 2021'),
  Invoice(
      name: 'Labour',
      price: 'N20,000',
      details: 'DEPOSIT',
      date: '23, NOV. 2021'),
  Invoice(
      name: 'Labour',
      price: 'N20,000',
      details: 'DEPOSIT',
      date: '23, NOV. 2021'),
];
