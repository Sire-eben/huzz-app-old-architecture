class Debtor {
  String? debtorId;
  String? customerId;
  String? businessId;
  String? businessTransactionId;
  dynamic balance;
  dynamic totalAmount;
  DateTime? createdTime;
  DateTime? updatedTime;
  bool? paid;
  bool? deleted;
  String? businessTransactionType;
  bool? isPendingAdding;
  bool? isPendingUpdating;

  Debtor(
      {this.debtorId,
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
      this.isPendingAdding,
      this.isPendingUpdating});

  factory Debtor.fromJson(Map<String, dynamic> json) => Debtor(
      debtorId: json["id"],
      customerId: json["customerId"],
      businessId: json["businessId"],
      businessTransactionId: json["businessTransactionId"],
      balance: json["balance"],
      totalAmount: json["totalAmount"],
      businessTransactionType: json["businessTransactionType"],
      paid: json["paid"] ?? false,
      createdTime: DateTime.parse(json["createdDateTime"]),
      updatedTime: json["updatedDateTime"] == null
          ? DateTime.parse(json['createdDateTime'])
          : DateTime.parse(json['updatedDateTime']),
      deleted: json["deleted"] ?? false,
      isPendingAdding: json['isPendingAdding'] ?? false,
      isPendingUpdating: json['isPendingUpdating'] ?? false);

  Map<String, dynamic> toJson() => {
        "id": debtorId,
        "customerId": customerId,
        "businessId": businessId,
        "businessTransactionId": businessTransactionId,
        "balance": balance,
        "totalAmount": totalAmount,
        "businessTransactionType": businessTransactionType,
        "paid": paid ?? false,
        "createdDateTime": createdTime!.toIso8601String(),
        "updatedDateTime": updatedTime == null
            ? createdTime!.toIso8601String()
            : updatedTime!.toIso8601String(),
        "deleted": deleted ?? false,
        "isPendingAdding": isPendingAdding ?? false,
        "isPendingUpdating": isPendingUpdating ?? false
      };
}
