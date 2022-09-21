class Business {
  String? businessId;
  String? userId;
  String? businessName;
  String? businessAddress;
  String? businessCategory;
  String? businessPhoneNumber;
  String? businessEmail;
  String? businessCurrency;
  String? buisnessLogoFileStoreId;
  bool? deleted;
  DateTime? createdTime;
  DateTime? updatedTime;
  String? state;
  String? country;
  String? yearFounded;
  String? businessDescription;
  bool? businessRegistered;
  String? businessRegistrationType;
  String? businessRegistrationNumber;
  String? bankInfoId;
  String? teamId;
  dynamic team;

  Business(
      {this.businessId,
      this.userId,
      this.businessName,
      this.businessAddress,
      this.businessCategory,
      this.businessPhoneNumber,
      this.businessEmail,
      this.businessCurrency,
      this.buisnessLogoFileStoreId,
      this.deleted,
      this.createdTime,
      this.updatedTime,
      this.state,
      this.country,
      this.yearFounded,
      this.businessDescription,
      this.businessRegistered,
      this.businessRegistrationType,
      this.businessRegistrationNumber,
      this.bankInfoId,
      this.team,
      this.teamId});

  factory Business.fromJson(Map<String, dynamic> json) => Business(
      businessId: json['id'],
      userId: json['userId'],
      businessName: json['name'],
      businessAddress: json['address'],
      businessCategory: json['businessCategory'],
      businessPhoneNumber: json['phoneNumber'],
      businessEmail: json['email'],
      businessCurrency: json['currency'],
      buisnessLogoFileStoreId: json['buisnessLogoFileStoreId'],
      deleted: json['deleted'],
      createdTime: DateTime.parse(json['timeCreated']),
      updatedTime: json['timeUpdated'] != null
          ? DateTime.tryParse(json['timeUpdated'])
          : DateTime.parse(json['timeCreated']),
      state: json['state'],
      country: json['country'],
      yearFounded: json['yearFounded'],
      businessDescription: json['businessDescription'],
      businessRegistered: json['businessRegistered'],
      businessRegistrationType: json['businessRegistrationType'],
      businessRegistrationNumber: json['businessRegistrationNumber'],
      team: json['team'],
      teamId: json['teamId'],
      bankInfoId: json['bankInfoId']);
  Map<String, dynamic> toJson() => {
        "id": businessId,
        "userId": userId,
        "name": businessName,
        "address": businessAddress,
        "businessCategory": businessCategory,
        "phoneNumber": businessPhoneNumber,
        "email": businessEmail,
        "currency": businessCurrency,
        "buisnessLogoFileStoreId": buisnessLogoFileStoreId,
        "deleted": deleted,
        "timeCreated": createdTime!.toIso8601String(),
        "timeUpdated":
            updatedTime == null ? null : updatedTime!.toIso8601String(),
        "state": state,
        "country": country,
        "yearFounded": yearFounded,
        "businessDescription": businessDescription,
        "businessRegistered": businessRegistered,
        "businessRegistrationType": businessRegistrationType,
        "businessRegistrationNumber": businessRegistrationNumber,
        "bankInfoId": bankInfoId,
        "teamId": teamId,
        "team": teamId
      };
}
