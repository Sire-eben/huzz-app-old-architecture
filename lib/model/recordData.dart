import 'package:huzz/model/transaction_model.dart';

class RecordsData {
  RecordsData(this.label, this.value,this.transactionList);

  final String label;
  final dynamic value;
  final List<TransactionModel> transactionList;
}
