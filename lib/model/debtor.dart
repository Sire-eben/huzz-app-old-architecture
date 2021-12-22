class DebtorsModel {
  String? debtorId;
  String? customerId;
  String? businessId;
  int? businessTransactionId;
  int? balance;
  int? totalAmount;
  DateTime? createdTime;
  DateTime? updatedTime;
  bool? paid;
  bool? deleted;
  String? businessTransactionType;

  DebtorsModel({
    this.debtorId,
    this.customerId,
    this.businessId,
    this.businessTransactionId,
    this.balance,
    this.totalAmount,
    this.businessTransactionType,
    this.paid,
    this.createdTime,
    this.updatedTime,
    this.deleted,
  });

  factory DebtorsModel.fromJson(Map<String, dynamic> json) => DebtorsModel(
        debtorId: json["id"],
        customerId: json["customerId"],
        businessId: json["businessId"],
        businessTransactionId: json["businessTransactionId"],
        balance: json["balance"],
        totalAmount: json["totalAmount"],
        businessTransactionType: json["businessTransactionType"],
        paid: json["paid"],
        createdTime: DateTime.parse(json["createdDateTime"]),
        updatedTime: json["updatedDateTime"],
        deleted: json["deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": debtorId,
        "customerId": customerId,
        "businessId": businessId,
        "businessTransactionId": businessTransactionId,
        "balance": balance,
        "totalAmount": totalAmount,
        "businessTransactionType": businessTransactionType,
        "paid": paid,
        "createdDateTime": createdTime == null
            ? DateTime.now().toIso8601String()
            : createdTime!.toIso8601String(),
        "updatedDateTime": updatedTime == null
            ? DateTime.now().toIso8601String()
            : updatedTime!.toIso8601String(),
        "deleted": deleted,
      };
}
