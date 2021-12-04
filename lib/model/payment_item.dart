import 'dart:convert';

class PaymentItem{
String? id;
String? businessTransactionId;
String? itemName;
String? productId;
int? quality;
int? amount;

int? totalAmount;

DateTime? createdTime;
DateTime? updatedTime;
bool? deleted;
String? transactionType;


PaymentItem({
this.id,
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

});

factory PaymentItem.fromJson(Map<String,dynamic> json,String type)=> PaymentItem(
  id: json['id'],
  businessTransactionId: json['businessTransactionId'],
  itemName: json['itemName'],
  productId: json['productId'],
  quality: json['quantity'],
  amount: json['amount'],
  totalAmount: json['totalAmount'],
  createdTime: DateTime.parse(json['createdDateTime']),
  updatedTime: json['updatedDateTime']==null?DateTime.parse(json['createdDateTime']): DateTime.parse(json['updatedDateTime']),
  deleted: json['deleted'],
  transactionType: type

);

Map<String,dynamic> toJson()=>{
"id": id,
                    "businessTransactionId": businessTransactionId,
                    "itemName": itemName,
                    "productId": productId??"",
                    "quantity": quality,
                    "amount":amount,
                    "totalAmount":totalAmount,
                    "createdDateTime": createdTime!.toIso8601String(),
                    "updatedDateTime": updatedTime!.toIso8601String(),
                    "deleted":deleted


};
}