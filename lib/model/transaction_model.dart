class Transaction {
  String? name, date, amount, details, image;
  Transaction({this.amount, this.date, this.details, this.name, this.image});
}

List<Transaction> transactionList = [
  Transaction(
      amount: '2,000',
      date: '21 October, 2021',
      details: 'FULLY PAID',
      name: 'Stuff',
      image: 'assets/images/arrow_down.png'),
  Transaction(
      amount: '5,000',
      date: '21 October, 2021',
      details: 'FULLY PAID',
      name: 'Stuff',
      image: 'assets/images/arrow_up.png'),
  Transaction(
      amount: '4,456',
      date: '21 October, 2021',
      details: 'FULLY PAID',
      name: 'Stuff',
      image: 'assets/images/arrow_down.png'),
  Transaction(
      amount: '5980',
      date: '21 October, 2021',
      details: 'PARTLY PAID',
      name: 'Stuff',
      image: 'assets/images/arrow_up.png'),
  Transaction(
      amount: '3,000',
      date: '21 October, 2021',
      details: 'FULLY PAID',
      name: 'Stuff',
      image: 'assets/images/arrow_down.png'),
];
