import 'package:get/get.dart';
import 'package:huzz/model/payment_history_request.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:huzz/model/records_model.dart';
import 'package:huzz/model/transaction_model.dart';

class Invoice {
  String? id;
  String? customerId;
  String? businessId;
  String? businessTransactionId;
  String? businessInvoiceStatus;
  double? totalAmount;
  double? discountAmount;
  double? tax;
  DateTime? dueDateTime;
  String? note;
  DateTime? issuranceDateTime;
  DateTime? reminderDateTime;
  DateTime? createdDateTime;
  DateTime? updatedDateTime;
  bool? deleted;
  bool? isPending;
  bool? isUpdatePending;
  List<PaymentItem>? paymentItemRequestList;
// List<PaymentHistoryRequest>? paymentHistoryRequest;
  String? bankId;
  bool? isHistoryPending;
  TransactionModel? businessTransaction;

  Invoice(
      {this.id,
      this.customerId,
      this.businessId,
      this.businessTransactionId,
      this.businessInvoiceStatus,
      this.totalAmount,
      this.discountAmount,
      this.tax,
      this.dueDateTime,
      this.note,
      this.issuranceDateTime,
      this.reminderDateTime,
      this.updatedDateTime,
      this.createdDateTime,
      this.deleted,
      this.isPending,
      this.isUpdatePending,
      this.paymentItemRequestList,
      this.bankId,
      this.businessTransaction,
      this.isHistoryPending});

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
      id: json['id'],
      customerId: json['customerId'],
      businessId: json['businessId'],
      businessTransactionId: json['businessTransactionId'],
      businessInvoiceStatus: json['businessInvoiceStatus'] ?? "PENDING",
      totalAmount:
          json['totalAmount'] == null ? 0.0 : json['totalAmount'] * 1.0,
      discountAmount: json['discountAmount'],
      tax: json['tax'],
      dueDateTime: json['dueDateTime'] == null
          ? null
          : DateTime.parse(json['dueDateTime']),
      note: json['note'] ?? "",
      issuranceDateTime: json['issuranceDateTime'] == null
          ? null
          : DateTime.parse(json['issuranceDateTime']),
      reminderDateTime: json['reminderDateTime'] == null
          ? null
          : DateTime.parse(json['reminderDateTime']),
      updatedDateTime: json['updateDateTime'] == null
          ? DateTime.parse(json['createdDateTime'])
          : DateTime.parse(json['updatedDateTime']),
      createdDateTime: DateTime.parse(json['createdDateTime']),
      deleted: json['deleted'] ?? false,
      isPending: json['isPending'] ?? false,
      isUpdatePending: json['isUpdatingPending'] ?? false,
      bankId: json['bankInfoId'],
      isHistoryPending: json['isHistoryPending'] ?? false,
      businessTransaction: json['businessTransaction'] == null
          ? null
          : TransactionModel.fromJson(json['businessTransaction']),
      paymentItemRequestList: json['businessTransactionPaymentItemList'] == null
          ? []
          : List.from(json['businessTransactionPaymentItemList'])
              .map((e) => PaymentItem.fromJson(
                  e,
                  "INCOME",
                  json['balance'] == null || json['balance'] == 0
                      ? true
                      : false,
                  json['id'],
                  DateTime.parse(json['createdDateTime'])))
              .toList());

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerId": customerId,
        "businessId": businessId,
        "businessTransactionId": businessTransactionId,
        "businessInvoiceStatus": businessInvoiceStatus,
        "totalAmount": totalAmount,
        "discountAmount": discountAmount,
        "tax": tax,
        "dueDateTime":
            dueDateTime == null ? null : dueDateTime!.toIso8601String(),
        "note": note,
        "issuranceDateTime": issuranceDateTime == null
            ? null
            : issuranceDateTime!.toIso8601String(),
        "reminderDateTime": reminderDateTime == null
            ? null
            : reminderDateTime!.toIso8601String(),
        "updateDatetime":
            updatedDateTime == null ? null : updatedDateTime!.toIso8601String(),
        "createdDateTime": createdDateTime!.toIso8601String(),
        "deleted": deleted,
        "businessTransactionPaymentItemList":
            paymentItemRequestList!.map((e) => e.toJson(id!)).toList(),
        "isPending": isPending,
        "isUpdatingPending": isUpdatePending,
        "bankInfoId": bankId,
        "isHistoryPending": isHistoryPending ?? false,
        "businessTransaction":
            businessTransaction == null ? null : businessTransaction!.toJson()
      };
}
