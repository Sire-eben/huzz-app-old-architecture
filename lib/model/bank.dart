import 'package:huzz/model/bank_model.dart';

class Bank {
  String? id;
  String? bankName;
  String? bankAccountNumber;
  String? bankAccountName;
  bool? deleted;
  DateTime? createdDateTime;
  DateTime? updatedDateTime;
  String? userId;
  bool? isAddingPending;
  bool? isUpdatingPending;
  bool? isCreatedFromInvoice;
  String? businessId;

  Bank(
      {this.id,
      this.bankName,
      this.bankAccountNumber,
      this.bankAccountName,
      this.deleted,
      this.createdDateTime,
      this.updatedDateTime,
      this.userId,
      this.isAddingPending,
      this.isUpdatingPending,
      this.isCreatedFromInvoice,
      this.businessId});

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
      id: json['id'],
      bankAccountName: json['bankAccountName'],
      bankName: json['bankName'],
      bankAccountNumber: json['bankAccountNumber'],
      deleted: json['deleted'] ?? false,
      createdDateTime: DateTime.parse(json['timeCreated']),
      updatedDateTime: json['timeUpdated'] == null
          ? DateTime.parse(json['timeCreated'])
          : DateTime.parse(json['timeUpdated']),
      userId: json['userId'],
      isAddingPending: json['isAddingPending'] ?? false,
      isCreatedFromInvoice: json['isCreatedFromInvoice'] ?? false,
      isUpdatingPending: json['isUpdatingPending'] ?? false,
      businessId: json['businessId']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "bankAccountName": bankAccountName,
        "bankName": bankName,
        "bankAccountNumber": bankAccountNumber,
        "deleted": deleted,
        "timeCreated": createdDateTime!.toIso8601String(),
        "timeUpdated": updatedDateTime!.toIso8601String(),
        "userId": userId,
        "isAddingPending": isAddingPending,
        "isCreatedFromInvoice": isCreatedFromInvoice,
        "isUpdatingPending": isUpdatingPending,
        "businessId": businessId,
      };
}
