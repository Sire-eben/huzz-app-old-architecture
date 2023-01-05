import 'dart:convert';

class PaymentItem {
  String? id;
  String? businessTransactionId;
  String? itemName;
  String? productId;
  int? quality;
  dynamic amount;
  bool? isFullyPaid;
  dynamic totalAmount;
  DateTime? createdTime;
  DateTime? updatedTime;
  bool? deleted;
  String? transactionType;
  DateTime? entryDateTime;

  PaymentItem(
      {this.id,
      this.businessTransactionId,
      this.itemName,
      this.productId,
      this.quality,
      this.amount,
      this.totalAmount,
      this.createdTime,
      this.updatedTime,
      this.deleted,
      this.transactionType,
      this.isFullyPaid,
      this.entryDateTime});

  factory PaymentItem.fromJson(Map<String, dynamic> json, String type,
          bool isFullyPaid, String transactionId, DateTime entryDateTime) =>
      PaymentItem(
          id: json['id'],
          businessTransactionId: transactionId,
          itemName: json['itemName'],
          productId: json['productId'],
          quality: json['quantity'],
          amount: json['amount'],
          totalAmount: json['totalAmount'],
          createdTime: DateTime.parse(json['createdDateTime']),
          updatedTime: json['updatedDateTime'] == null
              ? DateTime.parse(json['createdDateTime'])
              : DateTime.parse(json['updatedDateTime']),
          deleted: json['deleted'],
          transactionType: type,
          isFullyPaid: isFullyPaid,
          entryDateTime: entryDateTime);

  Map<String, dynamic> toJson(String transactionId) => {
        "id": id,
        "businessTransactionId": transactionId,
        "itemName": itemName,
        "productId": productId,
        "quantity": quality,
        "amount": amount,
        "totalAmount": totalAmount,
        "createdDateTime": (createdTime == null)
            ? DateTime.now().toIso8601String()
            : createdTime!.toIso8601String(),
        "updatedDateTime":
            (updatedTime == null) ? null : updatedTime!.toIso8601String(),
        "deleted": deleted ?? false,
        "isFully": isFullyPaid,
      };
}
