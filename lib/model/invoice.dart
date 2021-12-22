class Invoice {
  String? id;
  String? customerId;
  String? businessId;
  String? businessTransactionId;
  String? businessInvoiceStatus;
  int? totalAmount;
  int? discountAmount;
  int? tax;
  DateTime? dueDateTime;
  String? note;
  DateTime? issuranceDateTime;
  DateTime? reminderDateTime;
  DateTime? createdDateTime;
  DateTime? updatedDateTime;
  bool? deleted;
  bool? isPending;
  bool? isUpdatePending;

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
      this.isUpdatePending});

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
      id: json['id'],
      customerId: json['customerId'],
      businessId: json['businessId'],
      businessTransactionId: json['businessTransactionId'],
      businessInvoiceStatus: json['businessInvoiceStatus'],
      totalAmount: json['totalAmount'],
      discountAmount: json['discountAmount'],
      tax: json['tax'],
      dueDateTime: json['dueDateTime'] == null
          ? null
          : DateTime.parse(json['dueDateTime']),
      note: json['note'],
      issuranceDateTime: json['issuranceDateTime'] == null
          ? null
          : DateTime.parse(json['issuranceDateTime']),
      reminderDateTime: json['reminderDateTime'] == null
          ? null
          : DateTime.parse(json['reminderDateTime']),
      updatedDateTime:
          json['updateDateTime'] == DateTime.parse(json['createdDateTime'])
              ? null
              : DateTime.parse(json['updatedDateTime']),
      createdDateTime: DateTime.parse(json['createdDateTime']),
      deleted: json['deleted'] ?? false,
      isPending: json['isPending'] ?? false,
      isUpdatePending: json['isUpdatingPending'] ?? false);

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
        "deleted": deleted
      };
}
