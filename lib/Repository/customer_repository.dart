import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/api_link.dart';

class CustomerRepository extends GetxController{
final nameController=TextEditingController();
final phoneNumberController=TextEditingController();
final emailController=TextEditingController();
final _businessController=Get.find<BusinessRespository>();
final _userController=Get.find<AuthRepository>();
@override
  void onInit() {
    // TODO: implement onInit
    
  }

  Future<String> addBusinessCustomer(String transactionType)async{

var response= await http.post(Uri.parse(ApiLink.addCustomer),body: jsonEncode({
"email":emailController.text,
"phone":phoneNumberController.text,
"name":nameController.text,
"businessId":_businessController.selectedBusiness.value!.businessId,
"businessTransactionType":transactionType,

}),
headers: {
 "Content-Type":"application/json",
  "Authorization":"Bearer ${_userController.token}"

});

if(response.statusCode==200){

var json=jsonDecode(response.body);
if(json['success']){
  
return json['data']['id'];

}else{

  return "";
}

}else{
return "";
}

  } 


  



}