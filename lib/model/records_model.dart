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
