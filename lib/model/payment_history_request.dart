class PaymentHistoryRequest{

int? amountPaid;
String? paymentMode;
DateTime? createdDateTime;
DateTime? updateDateTime;
bool? deleted;
bool? isPendingUpdating;
String? id;
String? invoiceId;
String? paymentSource;
PaymentHistoryRequest({
this.amountPaid,
this.paymentMode,
this.createdDateTime,
this.updateDateTime,
this.deleted,
this.isPendingUpdating,
this.id,
this.invoiceId,
this.paymentSource}
);
factory PaymentHistoryRequest.fromJson(Map<String,dynamic> json)=>PaymentHistoryRequest(
  amountPaid:json['amountPaid'],
  paymentMode: json['paymentMode'],
  createdDateTime: DateTime.parse(json['createdDateTime']),
  updateDateTime: json['updatedDateTime']==null?DateTime.parse(json['createdDateTime']):DateTime.parse(json['updatedDateTime']),
  isPendingUpdating: json['isPendingUpdating']??false,
  deleted: json['deleted']??false,
  invoiceId: json['invoiceId'],
  paymentSource: json['paymentSource'],

);

Map<String,dynamic> toJson()=>{
"amountPaid":amountPaid,
"paymentMode":paymentMode,
"createdDateTime":createdDateTime!.toIso8601String(),
"isPendingUpdating":isPendingUpdating,
"deleted":deleted??false,
"invoiceId":invoiceId,
"paymentSource":paymentSource

};
 
}