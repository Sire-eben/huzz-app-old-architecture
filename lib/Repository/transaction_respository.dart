import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/model/offline_business.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:huzz/model/transaction_model.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/sqlite/sqlite_db.dart';

import 'auth_respository.dart';
class TransactionRespository extends GetxController{


Rx<List<TransactionModel>> _offlineTransactions=Rx([]);
List<TransactionModel> get offlineTransactions=> _offlineTransactions.value;
List<TransactionModel> OnlineTransaction=[];
List<TransactionModel> pendingTransaction=[];
Rx<List<PaymentItem>> _allPaymentItem=Rx([]);
List<PaymentItem> get allPaymentItem=>_allPaymentItem.value;
final _userController=Get.find<AuthRepository>();
final _businessController=Get.find<BusinessRespository>();
final expenses=0.obs;
final income=0.obs;
final numberofincome=0.obs;
final numberofexpenses=0.obs;
final totalbalance=0.obs;
final debtors=0.obs;
List<TransactionModel> todayTransaction=[];
SqliteDb sqliteDb=SqliteDb();
final itemNameController=TextEditingController();
final amountController=TextEditingController();
final quantityController=TextEditingController();
final dateController=TextEditingController();
  final timeController=TextEditingController();
final  paymentController=TextEditingController();
final paymentSourceController=TextEditingController();
final receiptFileController=TextEditingController();



@override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    await sqliteDb.openDatabae();
    
    _userController.Mtoken.listen((p0) {
  if(p0.isNotEmpty||p0!="0"){
   final value=_businessController.selectedBusiness.value;
    if(value!=null){
     
getOnlineTransaction(value.businessId!);
GetOfflineTransactions(value.businessId!);
getSpending(value.businessId!);

    }
_businessController.selectedBusiness.listen((p0) {
  if(p0!=null){

print("business id ${p0.businessId}");
 _offlineTransactions([]);
      _allPaymentItem([]);
    OnlineTransaction=[];
getOnlineTransaction(p0.businessId!);
GetOfflineTransactions(p0.businessId!);
getSpending(p0.businessId!);
  }

});
  }

});

  
  }

Future getAllPaymentItem()async{
if(todayTransaction.isEmpty)
return;
List<PaymentItem> items=[];
todayTransaction.forEach((element) {
  
items.addAll(element.businessTransactionPaymentItemList!);

});


_allPaymentItem(items);
}




Future getOnlineTransaction(String businessId)async{

var response= await http.get(Uri.parse(ApiLink.get_business_transaction+"?businessId="+businessId),headers: {

"Authorization":"Bearer ${_userController.token}"
 });
var json=jsonDecode(response.body);
print("get online transaction $json");
if(response.statusCode==200){
var result=List.from(json['data']).map((e) => TransactionModel.fromJson(e));


OnlineTransaction.addAll(result);

getTransactionYetToBeSavedLocally();


}else{



}




}


Future GetOfflineTransactions(String id) async{

var results= await sqliteDb.getOfflineTransactions(id);
print("offline transaction ${results.length}");

_offlineTransactions(results);

getTodayTransaction();
} 

Future getTodayTransaction()async{
List<TransactionModel> _todayTransaction=[];
final date=DateTime.now();
offlineTransactions.forEach((element) {
  
print("element test date ${element.createdTime!.toIso8601String()}");
final  d=DateTime(element.createdTime!.year,element.createdTime!.month,element.createdTime!.day);
  if(d.isAtSameMomentAs(DateTime(date.year,date.month,date.day))){
    _todayTransaction.add(element);

  print("found date for today");

  }

});
todayTransaction=_todayTransaction;
getAllPaymentItem();
}
Future getTransactionYetToBeSavedLocally()async{



OnlineTransaction.forEach((element) {
 
if(!checkifTransactionAvailable(element.id!)){
  print("doesnt contain value");
 
pendingTransaction.add(element);
}

});

savePendingJob();




}
Future PendingTransaction()async{



}

bool checkifTransactionAvailable(String id){
 bool result=false;
offlineTransactions.forEach((element) {
   print("checking transaction whether exist");
if(element.id==id){
print("transaction   found");
result=true;
}
 });
return result;
}


Future savePendingJob()async{

if(pendingTransaction.isEmpty){
  return;
}
var savenext=pendingTransaction.first;
 await sqliteDb.insertTransaction(savenext);
pendingTransaction.remove(savenext);
if(pendingTransaction.isNotEmpty){
savePendingJob();

}
GetOfflineTransactions(savenext.businessId!);

}


Future getSpending(String id)async{


final now=DateTime.now();
var day=now.day>=10?now.day.toString():"0"+now.day.toString();
var month=now.month>=10?now.month.toString():"0"+now.month.toString();
 final date=""+now.year.toString()+"-"+month+"-"+day;
 print("today date is $date");
  final response= await http.get(Uri.parse(ApiLink.dashboard_overview+"?businessId="+id+"&from=$date 00:00&to=$date 23:59"),headers: {

"Authorization":"Bearer ${_userController.token}"
 });
  var json=jsonDecode(response.body);
  print("overview result $json");
  if(response.statusCode==200){
   var totalIncome=json['data']['totalIncomeAmount'];
   var totalExpenses=json['data']['totalExpenditureAmount'];
   var balance=json['data']['differences'];
   var numberofIncome=json['data']['numberOfIncomeTransactions'];
   var numberofExpenses=json['data']['numberOfExpenditureTransactions'];
   var Debtor=json['otalIncomeBalanceAmount']??0;
   income(totalIncome);
   expenses(totalExpenses);
   totalbalance(balance);
   numberofexpenses(numberofExpenses);
   numberofincome(numberofIncome);
   debtors(Debtor);



  }
}
}