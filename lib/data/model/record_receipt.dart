class RecordInvoice {
  final List<RecordItem> items;

  const RecordInvoice({
    required this.items,
  });
}

class DailyRecordInvoice {
  final List<DailyRecordItem> items;

  const DailyRecordInvoice({
    required this.items,
  });
}

class RecordItem {
  final String date;
  final double moneyIn;
  final double moneyOut;

  const RecordItem({
    required this.date,
    required this.moneyIn,
    required this.moneyOut,
  });
}

class DailyRecordItem {
  final String date, time, type, itemName, mode, customerName;
  final int quantity;
  final double amount;

  const DailyRecordItem({
    required this.date,
    required this.time,
    required this.type,
    required this.itemName,
    required this.mode,
    required this.quantity,
    required this.customerName,
    required this.amount,
  });
}
