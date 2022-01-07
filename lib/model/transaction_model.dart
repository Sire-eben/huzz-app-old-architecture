import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:huzz/model/payment_history.dart';
import 'package:huzz/model/payment_item.dart';


class TransactionModel {
  String? id;
  int? totalAmount;
  DateTime? createdTime;
  DateTime? updatedTime;
  DateTime? entryDateTime;
  String? transactionType;
  String? paymentSource;
  String? businessTransactionFileStoreId;
  String? customerId;
  String? businessId;
  bool? deleted;
  String? expenseCategory;
  String? paymentMethod;
  int? balance;
  List<PaymentHistory>? businessTransactionPaymentHistoryList;
  PaymentHistory? currentBusinessTransactionPaymentHistory;
  List<PaymentItem>? businessTransactionPaymentItemList;
  bool isPending;
  bool? isHistoryPending;
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
    required this.isPending,
    this.isHistoryPending
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
          id: json['id'],
          totalAmount: json['totalAmount'],
          createdTime: DateTime.parse(json['createdDateTime']),
          updatedTime: json['updatedDateTime'] == null
              ? DateTime.parse(json['createdDateTime'])
              : DateTime.parse(json['updatedDateTime']),
          entryDateTime: json['entryDateTime'] == null
              ? DateTime.parse(json['createdDateTime'])
              : DateTime.parse(json['entryDateTime']),
          transactionType: json['transactionType'],
          paymentSource: json['paymentSource'],
          businessTransactionFileStoreId:
              json['businessTransactionFileStoreId'],
          customerId: json['customerId'] ?? null,
          businessId: json['businessId'] ?? null,
          deleted: json['deleted']??false,
          expenseCategory: json['expenseCategory'],
          paymentMethod: json['paymentMode'],
          balance: json['balance'] ?? 0,
          isPending: json['isPending'] ?? false,
          isHistoryPending: json['isHistoryPending']??false,
          businessTransactionPaymentHistoryList:
              json['businessTransactionPaymentHistoryList'] == null 
                  ? []
                  : List.from(json['businessTransactionPaymentHistoryList']).map((e) => PaymentHistory.fromJson(e)).toList(),
          currentBusinessTransactionPaymentHistory:
              json['currentBusinessTransactionPaymentHistory']==null|| json['currentBusinessTransactionPaymentHistory']==""?null:PaymentHistory.fromJson(json['currentBusinessTransactionPaymentHistory']),
          businessTransactionPaymentItemList:
              List.from(json['businessTransactionPaymentItemList'])
                  .map((e) => PaymentItem.fromJson(
                      e,
                      json['transactionType']??"",
                      json['balance'] == null || json['balance'] == 0
                          ? true
                          : false,json['id']))
                  .toList());

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalAmount": totalAmount,
        "createdDateTime": createdTime == null
            ? DateTime.now().toIso8601String()
            : createdTime!.toIso8601String(),
        "updatedDateTime":
            updatedTime == null ? null : updatedTime!.toIso8601String(),
        "entryDateTime":
            entryDateTime == null ? null : entryDateTime!.toIso8601String(),
        "transactionType": transactionType,
        "paymentSource": paymentSource,
        "paymentMode":paymentMethod,
        "businessTransactionFileStoreId": businessTransactionFileStoreId ?? "",
        "customerId": customerId ?? null,
        "businessId": businessId ?? null,
        "deleted": deleted,
        "expenseCategory": expenseCategory,
        "balance": balance,
        "isPending": isPending,
        "isHistoryPending":isHistoryPending,
        "businessTransactionPaymentHistoryList":
            businessTransactionPaymentHistoryList == null ||
                    businessTransactionPaymentHistoryList!.isEmpty
                ? []
                : businessTransactionPaymentHistoryList!.map((e) => e.toJson()).toList(),
        "currentBusinessTransactionPaymentHistory":
            currentBusinessTransactionPaymentHistory != null 
                ? currentBusinessTransactionPaymentHistory!.toJson()
                : null,
        "businessTransactionPaymentItemList":
            businessTransactionPaymentItemList!.map((e) => e.toJson(id!)).toList(),
      };
}
