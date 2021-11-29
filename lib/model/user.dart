class User{

  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? signatureImageFileStoreId;
  String? profileImageFileStoreId;

  User({this.firstName,this.lastName,this.phoneNumber,this.email,this.signatureImageFileStoreId,this.profileImageFileStoreId});


 factory  User.fromJson(Map<String,dynamic> json)=> User(
firstName: json['firstName'],
lastName: json['lastName'],
phoneNumber: json['phoneNumber'],
email: json['email'],
signatureImageFileStoreId: json['signatureImageFileStoreId']==null?"":json['signatureImageFileStoreId'],
profileImageFileStoreId: json['profileImageFileStoreId']==null?"":json['profileImageFileStoreId']

 );  

Map<String,dynamic> toJson()=>{
  "firstName":firstName,
  "lastName":lastName,
  "phoneNumber":phoneNumber,
  "email":email,
  "profileImageFileStoreId":profileImageFileStoreId,
  "signatureImageFileStoreId":signatureImageFileStoreId
};
}