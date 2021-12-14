import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:huzz/model/payment_item.dart';

class TransactionModel {

String? id;
int? totalAmount;
DateTime? createdTime;
DateTime? updatedTime;
DateTime? entryDateTime;
String? transactionType;
String? paymentSource;
String?  businessTransactionFileStoreId;
String? customerId;
String? businessId;
bool? deleted;
String? expenseCategory;
String? paymentMethod;
int? balance;
List? businessTransactionPaymentHistoryList;
String? currentBusinessTransactionPaymentHistory;
List<PaymentItem>? businessTransactionPaymentItemList;
bool? isPending;
TransactionModel({
this.id,
this.totalAmount,
this.createdTime,
this.updatedTime,
this.entryDateTime,
this.transactionType,
this.paymentSource,
this.businessTransactionFileStoreId,
this.customerId,
this.businessId,
this.deleted,
this.expenseCategory,
this.paymentMethod,
this.balance,
this.businessTransactionPaymentHistoryList,
this.currentBusinessTransactionPaymentHistory,
this.businessTransactionPaymentItemList,
this.isPending,
});


factory TransactionModel.fromJson(Map<String,dynamic> json)=>TransactionModel(
  id: json['id'],
  totalAmount:json['totalAmount'],
  createdTime:  DateTime.parse(json['createdDateTime']),
  updatedTime: json['updatedDateTime']==null? DateTime.parse(json['createdDateTime']): DateTime.parse(json['updatedDateTime']),
  entryDateTime: json['entryDateTime']==null? DateTime.parse(json['createdDateTime']):DateTime.parse(json['entryDateTime']),
  transactionType: json['transactionType'],
  paymentSource: json['paymentSource'],
  businessTransactionFileStoreId:json['businessTransactionFileStoreId'],
  customerId: json['customerId']??null,
  businessId: json['businessId']??null,
  deleted: json['deleted'],
  expenseCategory: json['expenseCategory'],
  paymentMethod: json['paymentMethod'],
  balance: json['balance'],
  isPending: json['isPending']?? false,
  businessTransactionPaymentHistoryList: json['businessTransactionPaymentHistoryList']==null?[]:List.from(json['businessTransactionPaymentHistoryList']),
  currentBusinessTransactionPaymentHistory: json['currentBusinessTransactionPaymentHistory'],
  businessTransactionPaymentItemList: List.from(json['businessTransactionPaymentItemList']).map((e) => PaymentItem.fromJson(e,json['transactionType'])).toList()


);

Map<String,dynamic> toJson()=>{
"id":id,
"totalAmount":totalAmount,
"createdDateTime":createdTime==null?DateTime.now().toIso8601String():createdTime!.toIso8601String(),
"updatedDateTime":updatedTime==null?null: updatedTime!.toIso8601String(),
"entryDateTime":entryDateTime==null?null: entryDateTime!.toIso8601String(),
"transactionType":transactionType,
"paymentSource":paymentSource,
"businessTransactionFileStoreId":businessTransactionFileStoreId??"",
"customerId":customerId??null,
"businessId":businessId??null,
"deleted":deleted,
"expenseCategory":expenseCategory,
"balance":balance,
"isPending":isPending,
"businessTransactionPaymentHistoryList":businessTransactionPaymentHistoryList==null||  businessTransactionPaymentHistoryList!.isEmpty?[]:businessTransactionPaymentHistoryList,
"currentBusinessTransactionPaymentHistory":currentBusinessTransactionPaymentHistory==null?currentBusinessTransactionPaymentHistory:"",
"businessTransactionPaymentItemList":businessTransactionPaymentItemList!.map((e) => e.toJson()).toList(),

};
}