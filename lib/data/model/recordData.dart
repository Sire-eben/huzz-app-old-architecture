import 'package:flutter/material.dart';
import 'transaction_model.dart';

class RecordsData {
  RecordsData(this.label, this.value, this.transactionList, this.color);

  final String label;
  final dynamic value;
  final List<TransactionModel> transactionList;
  final Color color;
}
