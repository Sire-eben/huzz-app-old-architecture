import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/create_business.dart';
import 'package:huzz/app/screens/sign_in.dart';

import 'auth_respository.dart';
enum CreateBusinessStatus {Loading,Empty,Error,Success}
class BusinessRespository extends GetxController{

List<String> businessCategory=["PERSONAL","FINANCE","TRADE"];
final selectedCategory="".obs;
final businessName=TextEditingController();
final businessEmail=TextEditingController();
final businessPhoneNumber=TextEditingController();
final businessAddressController=TextEditingController(); 
final _userController=Get.find<AuthRepository>();
final _createBusinessStatus=CreateBusinessStatus.Empty.obs;
CreateBusinessStatus get createBusinessStatus=>_createBusinessStatus.value;

Future createBusiness()async{
print("token ${_userController.token}");
try{
  _createBusinessStatus(CreateBusinessStatus.Loading);
final response= await http.post(Uri.parse(ApiLink.create_business),body: jsonEncode({
"name":businessName.text,
    "address": businessAddressController.text,
    "businessCategory": selectedCategory.value,
    "phoneNumber": businessPhoneNumber.text,
    "email": businessEmail.text,
    "currency": "NGN",
    "buisnessLogoFileStoreId":null,
   
    "yearFounded":"",
   
    "businessRegistered":false,
    "businessRegistrationType":null,
    "businessRegistrationNumber":null,
    "bankInfoId":null
    

},),headers: {

  "Content-Type":"application/json",
  "Authorization":"Bearer ${_userController.token}"
});

print("create business response ${response.body}");
if(response.statusCode==200){
var json=jsonDecode(response.body);
if(json['success']){


_createBusinessStatus(CreateBusinessStatus.Success);
Get.off(Signin());

}else{


}


}else{

_createBusinessStatus(CreateBusinessStatus.Error);


}




}catch(ex){

_createBusinessStatus(CreateBusinessStatus.Error);
}
}
}