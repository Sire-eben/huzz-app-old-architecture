class Team {
  String? name, phone, image;
  String? customerId, businessId, businessTransactionType, email;
  DateTime? createdTime, updatedTime;
  bool? isAddingPending;
  bool? isUpdatingPending;
  bool? isCreatedFromTransaction;
  bool? isCreatedFromInvoice;
  bool? isCreatedFromDebtors;
  bool? deleted;
  Team(
      {this.image,
      this.name,
      this.phone,
      this.customerId,
      this.businessId,
      this.businessTransactionType,
      this.createdTime,
      this.updatedTime,
      this.deleted,
      this.email,
      this.isAddingPending,
      this.isUpdatingPending,
      this.isCreatedFromTransaction,
      this.isCreatedFromInvoice,
      this.isCreatedFromDebtors});

  factory Team.fromJson(Map<String, dynamic> json) => Team(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      customerId: json['id'],
      businessId: json['businessId'],
      businessTransactionType: json['businessTransactionType'],
      createdTime: DateTime.parse(json['createdDateTime']),
      updatedTime: json['updatedDateTime'] == null
          ? DateTime.parse(json['createdDateTime'])
          : DateTime.parse(json['updatedDateTime']),
      deleted: json['deleted'] ?? false,
      isAddingPending: json['isAddingPending'] ?? false,
      isUpdatingPending: json['isAddingPending'] ?? false,
      isCreatedFromTransaction: json['isCreatedFromTransaction'] ?? false,
      isCreatedFromInvoice: json['isCreatedFromInvoice'] ?? false,
      isCreatedFromDebtors: json['isCreatedFromDebtors'] ?? false);

  Map<String, dynamic> toJson() => {
        "name": this.name,
        "phone": this.phone,
        "email": this.email,
        "id": this.customerId,
        "businessId": this.businessId,
        "businessTransactionType": this.businessTransactionType,
        "createdDateTime": createdTime == null
            ? DateTime.now().toIso8601String()
            : this.createdTime!.toIso8601String(),
        "updatedDateTime": updatedTime == null
            ? DateTime.now().toIso8601String()
            : this.updatedTime!.toIso8601String(),
        "deleted": deleted,
        "isAddingPending": isAddingPending,
        "isUpdatingPending": isUpdatingPending,
        "isCreatedFromTransaction": isCreatedFromTransaction,
        "isCreatedFromInvoice": isCreatedFromInvoice,
        "isCreatedFromDebtors": isCreatedFromDebtors
      };
}

List<Team> teamList = [
  Team(
      name: 'Akinlose Damilare',
      phone: '09038726495',
      image: 'assets/images/cus1.png'),
  Team(
      name: 'Olaitan Adetayo',
      phone: '09038726495',
      image: 'assets/images/cus2.png'),
  // Team(
  //     name: 'Olatunde Joshua',
  //     phone: '09038726495',
  //     image: 'assets/images/cus3.png'),
  // Team(
  //     name: 'Akinlose Joshua',
  //     phone: '09038726495',
  //     image: 'assets/images/cus4.png'),
  // Team(
  //     name: 'Olatunde Damilare',
  //     phone: '09038726495',
  //     image: 'assets/images/cus5.png'),
];
