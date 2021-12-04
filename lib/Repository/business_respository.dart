import 'dart:convert';
import 'dart:core';


import 'package:country_currency_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/create_business.dart';
import 'package:huzz/app/screens/dashboard.dart';
import 'package:huzz/app/screens/sign_in.dart';
import 'package:huzz/model/business.dart';
import 'package:huzz/model/offline_business.dart';
import 'package:huzz/sqlite/sqlite_db.dart';

import 'auth_respository.dart';
enum CreateBusinessStatus {Loading,Empty,Error,Success}
class BusinessRespository extends GetxController{
  Rx<List<OfflineBusiness>> _offlineBusiness=Rx([]);
List<OfflineBusiness> get offlineBusiness=>_offlineBusiness.value;
List<OfflineBusiness> pendingJob=[];
List<Business> businessListFromServer=[];
List<String> businessCategory=["PERSONAL","FINANCE","TRADE"];

final selectedCategory="".obs;
final businessName=TextEditingController();
final businessEmail=TextEditingController();
final businessPhoneNumber=TextEditingController();
final businessAddressController=TextEditingController(); 
final _userController=Get.find<AuthRepository>();
final _createBusinessStatus=CreateBusinessStatus.Empty.obs;
Rx<Business?> selectedBusiness=Rx(null);
SqliteDb sqliteDb=SqliteDb();
CreateBusinessStatus get createBusinessStatus=>_createBusinessStatus.value;

@override
void onInit()async{

_userController.Mtoken.listen((p0) {
  if(p0.isNotEmpty||p0!="0"){
OnlineBusiness();
  }

});

  sqliteDb.openDatabae().then((value){
 
GetOfflineBusiness();

  });
}


Future OnlineBusiness()async{
 var response=await http.get(Uri.parse(ApiLink.get_user_business),headers: {

"Authorization":"Bearer ${_userController.token}"
 });
var json=jsonDecode(response.body);
print("online busines result $json");
 if(response.statusCode==200){

if(json['success']){
var result=List.from(json['data']).map((e) => Business.fromJson(e));
businessListFromServer.addAll(result);
print("online data business lenght ${result.length}");
getBusinessYetToBeSavedLocally();


}


 }else{



 }

}
bool checkifBusinessAvailable(String id){
 bool result=false;
offlineBusiness.forEach((element) {
   
if(element.businessId==id){
print("business  found");
result=true;
}
 });
return result;
}
Future getBusinessYetToBeSavedLocally()async{

// if(offlineBusiness.length==businessListFromServer.length)
// return;

businessListFromServer.forEach((element) {
 
if(!checkifBusinessAvailable(element.businessId!)){
  print("doesnt contain value");
   var re=OfflineBusiness(businessId:element.businessId,business: element);
pendingJob.add(re);
}

});

savePendingJob();


}
Future savePendingJob()async{

if(pendingJob.isEmpty){
  return;
}
var savenext=pendingJob.first;
 await sqliteDb.insertBusiness(savenext);
pendingJob.remove(savenext);
if(pendingJob.isNotEmpty){
savePendingJob();

}
GetOfflineBusiness();

}


Future GetOfflineBusiness()async{
var results= await sqliteDb.getOfflineBusinesses();
print("offline business ${results.length}");

_offlineBusiness(results);
if(results.isNotEmpty)
selectedBusiness(results.first.business);



}
Future createBusiness()async{
 
print("token ${_userController.token}");
try{
  _createBusinessStatus(CreateBusinessStatus.Loading);
  final currency=CountryPickerUtils.getCountryByIsoCode(_userController.countryCodeFLag).currencyCode.toString();
final response= await http.post(Uri.parse(ApiLink.create_business),body: jsonEncode({
"name":businessName.text,
    "address": businessAddressController.text,
    "businessCategory": selectedCategory.value,
    "phoneNumber": businessPhoneNumber.text,
    "email": businessEmail.text,
    "currency": currency,
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
 Get.off(() => Dashboard());

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