class RecordModel {
  String? date, moneyIn, moneyOut;
  RecordModel({
    this.moneyIn,
    this.date,
    this.moneyOut,
  });
}

List<RecordModel> recordList = [
  RecordModel(
    moneyIn: 'N20,000',
    date: '10 Nov, 2021',
    moneyOut: 'N5,980',
  ),
  RecordModel(
    moneyIn: 'N4,456',
    date: '10 Nov, 2021',
    moneyOut: 'N20,000',
  ),
  RecordModel(
    moneyIn: 'N5,980',
    date: '10 Nov, 2021',
    moneyOut: 'N3,000',
  ),
  RecordModel(
    moneyIn: 'N3,000',
    date: '10 Nov, 2021',
    moneyOut: 'N4,456',
  ),
];

class RecordSummary {
  String? name, detail, price, time, image;
  RecordSummary({this.detail, this.name, this.price, this.time, this.image});
}

List<RecordSummary> recordSummaryList = [
  RecordSummary(
      detail: 'FULLY PAID',
      name: 'Stuff',
      price: 'N5,980',
      time: '3:00 PM',
      image: 'assets/images/arrow_down.png'),
  RecordSummary(
      detail: 'FULLY PAID',
      name: 'Stuff',
      price: 'N20,000',
      time: '5:00 PM',
      image: 'assets/images/arrow_up.png'),
  RecordSummary(
      detail: 'FULLY PAID',
      name: 'Food',
      price: 'N3,000',
      time: '3:15 PM',
      image: 'assets/images/arrow_up.png'),
  RecordSummary(
      detail: 'FULLY PAID',
      name: 'Shoe',
      price: 'N4,456',
      time: '11:00 AM',
      image: 'assets/images/arrow_down.png'),
];

class ItemsRecord {
  String? name, quantity, price;
  ItemsRecord({this.quantity, this.name, this.price});
}

List<ItemsRecord> itemsRecordList = [
  ItemsRecord(quantity: '10', name: 'Stuff', price: 'N200,980'),
  ItemsRecord(quantity: '2', name: 'Stuff', price: 'N200,000'),
  ItemsRecord(quantity: '5', name: 'Food', price: 'N300,000'),
  ItemsRecord(quantity: '10', name: 'Shoe', price: 'N400,456'),
];

class PaymentHistory {
  String? date, price;
  PaymentHistory({this.date, this.price});
}

List<PaymentHistory> paymentHistoryList = [
  PaymentHistory(date: 'Sept. 21,2021', price: 'N200,980'),
  PaymentHistory(date: 'Sept. 21,2021', price: 'N200,000'),
  PaymentHistory(date: 'Sept. 21,2021', price: 'N300,000'),
];
