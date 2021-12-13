import 'package:huzz/model/business.dart';

class User{

  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? signatureImageFileStoreId;
  String? profileImageFileStoreId;
  List<Business>? businessList;

  User({this.firstName,this.lastName,this.phoneNumber,this.email,this.signatureImageFileStoreId,this.profileImageFileStoreId, this.businessList});


 factory  User.fromJson(Map<String,dynamic> json)=> User(
firstName: json['user']['firstName'],
lastName: json['user']['lastName'],
phoneNumber: json['user']['phoneNumber'],
email: json['user']['email'],
signatureImageFileStoreId: json['user']['signatureImageFileStoreId']==null?"":json['user']['signatureImageFileStoreId'],
profileImageFileStoreId: json['user']['profileImageFileStoreId']==null?"":json['user']['profileImageFileStoreId'],
businessList: List.from(json['businessList']).map((e) => Business.fromJson(e)).toList()

 );  

Map<String,dynamic> toJson()=>{
 'user':{ "firstName":firstName,
  "lastName":lastName,
  "phoneNumber":phoneNumber,
  "email":email,
  "profileImageFileStoreId":profileImageFileStoreId,
  "signatureImageFileStoreId":signatureImageFileStoreId,
 },
  "businessList":businessList!.map((e) => e.toJson()).toList()
};
}