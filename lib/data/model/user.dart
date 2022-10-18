import 'business.dart';

class User {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? signatureImageFileStoreId;
  String? profileImageFileStoreId;
  List<Business>? businessList;
  String? profileImageFileStoreUrl;
  bool? phoneNumberVerified;

  User({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.signatureImageFileStoreId,
    this.profileImageFileStoreId,
    this.businessList,
    this.profileImageFileStoreUrl,
    this.phoneNumberVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      firstName: json['user']['firstName'],
      lastName: json['user']['lastName'],
      phoneNumber: json['user']['phoneNumber'],
      phoneNumberVerified: json['user']['phoneNumberVerified'],
      email: json['user']['email'],
      profileImageFileStoreUrl: json['user']['profileImageFileStoreUrl'] ?? "",
      signatureImageFileStoreId:
          json['user']['signatureImageFileStoreId'] == null
              ? ""
              : json['user']['signatureImageFileStoreId'],
      profileImageFileStoreId: json['user']['profileImageFileStoreId'] == null
          ? ""
          : json['user']['profileImageFileStoreId'],
      businessList: json['businessList'] != null
          ? List.from(json['businessList'])
              .map((e) => Business.fromJson(e))
              .toList()
          : []);

  factory User.fromJsonSettngs(Map<String, dynamic> json) => User(
        firstName: json['firstName'],
        lastName: json['lastName'],
        phoneNumber: json['phoneNumber'],
        phoneNumberVerified: json['phoneNumberVerified'],
        email: json['email'],
        profileImageFileStoreUrl: json['profileImageFileStoreUrl'] ?? "",
        signatureImageFileStoreId: json['signatureImageFileStoreId'] == null
            ? ""
            : json['signatureImageFileStoreId'],
        profileImageFileStoreId: json['profileImageFileStoreId'] == null
            ? ""
            : json['profileImageFileStoreId'],
// businessList: json['businessList']!=null? List.from(json['businessList']).map((e) => Business.fromJson(e)).toList():[]
      );

  Map<String, dynamic> toJson() => {
        'user': {
          "firstName": firstName,
          "lastName": lastName,
          "phoneNumber": phoneNumber,
          "phoneNumberVerified": phoneNumberVerified,
          "email": email,
          "profileImageFileStoreUrl": profileImageFileStoreUrl,
          "profileImageFileStoreId": profileImageFileStoreId,
          "signatureImageFileStoreId": signatureImageFileStoreId,
        },
        "businessList": businessList!.map((e) => e.toJson()).toList()
      };
}