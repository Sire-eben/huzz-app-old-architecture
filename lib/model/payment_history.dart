class PaymentHistory{
int? amountPaid;
String? paymentMode;
DateTime? createdDateTime;
DateTime? updateDateTime;
bool? deleted;
bool? isPendingUpdating;
String? id;
String? paymentSource;
String? businessTransactionId;

PaymentHistory({this.id,
this.amountPaid,
this.paymentMode,
this.createdDateTime,
this.updateDateTime,
this.isPendingUpdating,
this.deleted,
this.businessTransactionId,
this.paymentSource
});

factory PaymentHistory.fromJson(Map<String,dynamic> json)=>PaymentHistory(
id: json['id'],
amountPaid: json['amountPaid'],
paymentMode: json['paymentMode'],
createdDateTime: DateTime.parse(json['createdDateTime']),
updateDateTime: json['updatedDateTime']==null?DateTime.parse(json['createdDateTime']):DateTime.parse(json['updatedDateTime']),
isPendingUpdating: json['isPendingUpdating']??false,
businessTransactionId: json['businessTransactionId'],
deleted: json['deleted']??false,
paymentSource:json['paymentSource']

);
Map<String,dynamic> toJson()=>{
"id":id,
"amountPaid":amountPaid,
"paymentMode":paymentMode,
"createdDateTime":createdDateTime!.toIso8601String(),
"updatedDateTime":updateDateTime!.toIso8601String(),
"isPendingUpdating":isPendingUpdating,
"businessTransactionId":businessTransactionId,
"deleted":deleted,
"paymentSource":paymentSource

};
}