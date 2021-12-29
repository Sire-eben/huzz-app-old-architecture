import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/file_upload_respository.dart';
import 'package:huzz/Repository/product_repository.dart';
import 'package:huzz/api_link.dart';
import 'package:huzz/app/screens/home/income_success.dart';
import 'package:huzz/app/screens/invoice/invoice_pdf.dart';
import 'package:huzz/app/screens/invoice/preview_invoice.dart';
import 'package:huzz/main.dart';
import 'package:huzz/model/bank.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/invoice.dart';
import 'package:huzz/model/offline_business.dart';
import 'package:huzz/model/payment_item.dart';
import 'package:huzz/model/product.dart';

import 'package:http/http.dart' as http;
import 'package:huzz/sqlite/sqlite_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;


import 'auth_respository.dart';
import 'customer_repository.dart';

enum AddingInvoiceStatus { Loading, Error, Success, Empty }

class InvoiceRespository extends GetxController {
  Rx<List<Invoice>> _offlineInvoices = Rx([]);
  List<Invoice> get offlineInvoices => _offlineInvoices.value;
  final _uploadImageController = Get.find<FileUploadRespository>();
  final _customerController = Get.find<CustomerRepository>();
  final _productController=Get.find<ProductRepository>();
  List<Invoice> OnlineInvoice = [];
  List<Invoice> pendingInvoice = [];
  Rx<List<PaymentItem>> _allPaymentItem = Rx([]);
  List<PaymentItem> get allPaymentItem => _allPaymentItem.value;
  final _userController = Get.find<AuthRepository>();
  final _businessController = Get.find<BusinessRespository>();
  final expenses = 0.obs;
  final income = 0.obs;
  final numberofincome = 0.obs;
  final numberofexpenses = 0.obs;
  final totalbalance = 0.obs;
   bool isBusyAdding=false;
 bool isBusyUpdating=false;
  bool isbusyDeleting=false;
  final debtors = 0.obs;
   List<PaymentItem> productList=[];
  List<Invoice> todayInvoice = [];
  SqliteDb sqliteDb = SqliteDb();
  final itemNameController = TextEditingController();
  final amountController = TextEditingController();
  final quantityController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final paymentController = TextEditingController();
  final paymentSourceController = TextEditingController();
  final receiptFileController = TextEditingController();
  final amountPaidController = TextEditingController();
  final taxController=TextEditingController();
  final discountController=TextEditingController();
  Bank? invoiceBank;
  // final TextEditingController dateController = TextEditingController();
  // final TextEditingController timeController = TextEditingController();
  final TextEditingController contactName = TextEditingController();
  final TextEditingController contactPhone = TextEditingController();
  final TextEditingController contactMail = TextEditingController();
  List<Invoice> deletedItem=[];
  final _addingInvoiceStatus = AddingInvoiceStatus.Empty.obs;
  var uuid = Uuid();
// final _uploadFileController=Get.find<FileUploadRespository>();
  AddingInvoiceStatus get addingInvoiceStatus =>
      _addingInvoiceStatus.value;
  Product? selectedProduct;
  Bank? selectedBank;
  int? remain;
  Customer? selectedCustomer = null;
  DateTime? date;
  TimeOfDay? time;
  File? image;
  int selectedValue = 0;
  int customerType = 0;
  int paymentValue=0;
  bool addCustomer = false;
  List<String> paymentSource = ["POS", "CASH", "TRANSFER", "OTHERS"];
  String? selectedPaymentSource;
  List<String> paymentMode = ["FULLY_PAID", "DEPOSIT"];
  String? selectedPaymentMode;
  List<Invoice> pendingInvoiceToBeAdded=[];
  final bankName=TextEditingController();
  final bankAccountNumber=TextEditingController();
  final bankAccountName=TextEditingController();

  @override
  void onInit() async {
    // TODO: implement onInit
    print("getting Invoice repo");

    _userController.Mtoken.listen((p0) {
      print("token gotten $p0");
      if (p0.isNotEmpty || p0 != "0") {
        final value = _businessController.selectedBusiness.value;
        if (value != null) {
          getOnlineInvoice(value.businessId!);

          // getSpending(value.businessId!);

          GetOfflineInvoices(value.businessId!);
        } else {
          print("current business is null");
        }
        _businessController.selectedBusiness.listen((p0) {
          if (p0 != null) {
            print("business id ${p0.businessId}");
            _offlineInvoices([]);
            _allPaymentItem([]);
            OnlineInvoice = [];
            getOnlineInvoice(p0.businessId!);

            GetOfflineInvoices(p0.businessId!);
            // getSpending(p0.businessId!);

     
          }
        });
      }
    });
        _userController.MonlineStatus.listen((po){
       if(po==OnlineStatus.Onilne){
 _businessController.selectedBusiness.listen((p0) {
checkIfInvoiceThatIsYetToBeAdded();
         //update server with pending job
 });
       }
 });

                  
  }

  // Future getAllPaymentItem() async {
  //   if (todayInvoice.isEmpty) return;
  //   List<PaymentItem> items = [];
  //   todayInvoice.forEach((element) {
  //     items.addAll(element.is!);
  //   });

  //   _allPaymentItem(items);
  // }

  Future getOnlineInvoice(String businessId) async {
    var response = await http.get(
        Uri.parse(
            ApiLink.invoice_link +"?businessId=" + businessId),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    var json = jsonDecode(response.body);
    print("get online Invoice $json");
    if (response.statusCode == 200) {
      var result =
          List.from(json['data']).map((e) => Invoice.fromJson(e));

      OnlineInvoice.addAll(result);
print("online Invoice ${result.length}");
    // getTodayInvoice();
      getInvoiceYetToBeSavedLocally();
    } else {}
  }

  Future GetOfflineInvoices(String id) async {
    var results = await _businessController.sqliteDb.getOfflineInvovoices(id);
    print("offline Invoice ${results.length}");

    _offlineInvoices(results);

  
  }

  // Future getTodayInvoice() async {
  //   List<Invoice> _todayInvoice = [];
  //   final date = DateTime.now();
  //   offlineInvoices.forEach((element) {
  //     print("element test date ${element.createdTime!.toIso8601String()}");
  //     final d = DateTime(element.createdTime!.year, element.createdTime!.month,
  //         element.createdTime!.day);
  //     if (d.isAtSameMomentAs(DateTime(date.year, date.month, date.day))) {
  //       _todayInvoice.add(element);

  //       print("found date for today");
  //     }
  //   });
  //   todayInvoice = _todayInvoice;
  //   getAllPaymentItem();
  //   calculateOverView();
  // }

  Future getInvoiceYetToBeSavedLocally() async {
    OnlineInvoice.forEach((element) {
      if (!checkifInvoiceAvailable(element.id!)) {
      
        if(!element.isPending!)
        pendingInvoice.add(element);
      }
    });
      // print("does contain value ${pendingInvoice.first.isPending}");
print("item yet to be save yet ${pendingInvoice.length}");
    savePendingJob();
  }

  Future PendingInvoice() async {}

  bool checkifInvoiceAvailable(String id) {
    bool result = false;
    offlineInvoices.forEach((element) {
      // print("checking Invoice whether exist");
      if (element.id == id ) {
        // print("Invoice   found");
        result = true;
      }
    });
    return result;
  }

  Future savePendingJob() async {
    if (pendingInvoice.isEmpty) {
      return;
    }
    var savenext = pendingInvoice.first;
    await _businessController.sqliteDb.insertInvoce(savenext);
    pendingInvoice.remove(savenext);
    if (pendingInvoice.isNotEmpty) {
      savePendingJob();
    }
    GetOfflineInvoices(savenext.businessId!);
  }

  Future getSpendings(String id) async {
    final now = DateTime.now();
    var day = now.day >= 10 ? now.day.toString() : "0" + now.day.toString();
    var month =
        now.month >= 10 ? now.month.toString() : "0" + now.month.toString();
    final date = "" + now.year.toString() + "-" + month + "-" + day;
    print("today date is $date");
    final response = await http.get(
        Uri.parse(ApiLink.dashboard_overview +
            "?businessId=" +
            id +
            "&from=$date 00:00&to=$date 23:59"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    var json = jsonDecode(response.body);
    print("overview result $json");
    if (response.statusCode == 200) {
      var totalIncome = json['data']['totalIncomeAmount'];
      var totalExpenses = json['data']['totalExpenditureAmount'];
      var balance = json['data']['differences'];
      var numberofIncome = json['data']['numberOfIncomeInvoices'];
      var numberofExpenses = json['data']['numberOfExpenditureInvoices'];
      var Debtor = json['totalIncomeBalanceAmount'] ?? 0;
      income(totalIncome);
      expenses(totalExpenses);
      totalbalance(balance);
      numberofexpenses(numberofExpenses);
      numberofincome(numberofIncome);
      debtors(Debtor);
    }
  }

//   Future createInvoice(String type) async {
//     try {
//       _addingInvoiceStatus(AddingInvoiceStatus.Loading);
//       String? fileid;
//       String? customerId;
//       var productList = [];
//       if (image != null) {
//         fileid = await _uploadImageController.uploadFile(image!.path);
//       }

//       if (addCustomer) {
//         if (customerType == 1) {
//           customerId =
//               await _customerController.addBusinessCustomerWithString(type);
//         } else {
//           if (selectedCustomer.value != null)
//             customerId = selectedCustomer.value!.customerId;
//         }
//       }

//       if (selectedValue == 0) {
//         productList.add({
//           "productId": selectedProduct!.productId!,
//           "itemName": null,
//           "quantity": null,
//           "amount": null
//         });
//       } else {
//         productList.add({
//           "productId": null,
//           "itemName": itemNameController.text,
//           "quantity": null,
//           "amount": amountController.text
//         });
//       }

//       if (time != null && date != null) {
// // date!.hour=time!.hour;
//         date!.add(Duration(hours: time!.hour, minutes: time!.minute));
//         print("date Time to string ${date!.toIso8601String()}");
//       }
// // String? timeday=date!.toIso8601String();
//       String body = jsonEncode({
//         "paymentItemRequestList": productList,
//         "InvoiceType": type,
//         "paymentSource": selectedPaymentSource,
//         "businessId": _businessController.selectedBusiness.value!.businessId,
//         "paymentMode": selectedPaymentMode,
//         "customerId": customerId,
//         "businessInvoiceFileStoreId": fileid,
//         "entyDateTime": date!.toIso8601String()
//       });
//       print("Invoice body $body");
//       final response =
//           await http.post(Uri.parse(ApiLink.get_business_Invoice),
//               headers: {
//                 "Authorization": "Bearer ${_userController.token}",
//                 "Content-Type": "application/json"
//               },
//               body: body);

//       print({"creatng Invoice response ${response.body}"});
//       if (response.statusCode == 200) {
//         _addingInvoiceStatus(AddingInvoiceStatus.Success);
//         Get.to(() => IncomeSuccess());
//         getOnlineInvoice(
//             _businessController.selectedBusiness.value!.businessId!);

//         GetOfflineInvoices(
//             _businessController.selectedBusiness.value!.businessId!);
//         getSpending(_businessController.selectedBusiness.value!.businessId!);
//       } else {
//         _addingInvoiceStatus(AddingInvoiceStatus.Error);
//       }
//     } catch (ex) {
//       print("error occurred ${ex.toString()}");
//       _addingInvoiceStatus(AddingInvoiceStatus.Error);
//     }
//   }
Future createBusinessInvoice()async{
if(_userController.onlineStatus==OnlineStatus.Onilne){
createInvoiceOnline();

}else{

createInvoiceOffline();
}

}

Future createInvoiceOnline()async{
  
  try{
  _addingInvoiceStatus(AddingInvoiceStatus.Loading);
  String? fileid;
  String? customerId=null;
 
  if(quantityController.text.isEmpty){

    quantityController.text="1";
  }



if(customerType==1){
customerId=await _customerController.addBusinessCustomerWithString("INCOME");
}else{
  if(selectedCustomer!=null)
  customerId=selectedCustomer!.customerId;
}




if(time!=null&&date!=null){
// date!.hour=time!.hour;
date!.add(Duration(hours: time!.hour,minutes: time!.minute));
print("date Time to string ${date!.toIso8601String()}");
}
double tax=0;
int totalAmount=0;
productList.forEach((element) {
  

totalAmount=totalAmount+element.totalAmount!;
});
if(taxController.text.isNotEmpty){

tax=(double.parse(taxController.text)*totalAmount)/100;

}

double discount=0;

if(discountController.text.isNotEmpty){
discount=(double.parse(discountController.text)*totalAmount)/100;


}
double newTotalAmount=totalAmount+tax-discount;
// String? timeday=date!.toIso8601String();
String body=jsonEncode({

"paymentItemRequestList":productList.map((e) => e.toJson()).toList(),
   
    "paymentSource": selectedPaymentSource,
    "businessId":_businessController.selectedBusiness.value!.businessId,
    "paymentMode":selectedPaymentMode,
    "customerId":customerId,
    "tax":tax,
    "discountAmount":discount,
    "totalAmount":newTotalAmount
    
    


});
print("Invoice body $body");
final response=await http.post(Uri.parse(ApiLink.invoice_link),headers: {
"Authorization":"Bearer ${_userController.token}",
"Content-Type":"application/json"

},body:body );

print({"creatng Invoice response ${response.body}"});
if(response.statusCode==200){
 _addingInvoiceStatus(AddingInvoiceStatus.Success);
 var json=jsonDecode(response.body);
 var result=Invoice.fromJson(json['data']);
 result.paymentItemRequestList=productList;
 print("second result is ${result.toJson()}");
  final invoiceReceipt = await PdfInvoiceApi.generate(result);
              Get.to(() => PreviewInvoice(file: invoiceReceipt));
          //  Get.to(() => IncomeSuccess(Invoice: result,title: "Invoice",));
         getOnlineInvoice(_businessController.selectedBusiness.value!.businessId!);

GetOfflineInvoices(_businessController.selectedBusiness.value!.businessId!);

// getSpending(_businessController.selectedBusiness.value!.businessId!);
clearValue();
}else{
 _addingInvoiceStatus(AddingInvoiceStatus.Error);

}
}
catch(ex){
  print("error occurred ${ex.toString()}");
_addingInvoiceStatus(AddingInvoiceStatus.Error);

}

}

Future createInvoiceOffline()async{
String? fileid;
  String? customerId=null;


if(quantityController.text.isEmpty){

  quantityController.text="1";
}

if(customerType==1){
customerId=await _customerController.addBusinessCustomerOfflineWithString("INCOME");
}else{
  if(selectedCustomer!=null)
  customerId=selectedCustomer!.customerId;
}
double tax=0;
int totalAmount=0;
productList.forEach((element) {
  

totalAmount=totalAmount+element.totalAmount!;
});
if(taxController.text.isNotEmpty){

tax=(double.parse(taxController.text)*totalAmount)/100;

}

double discount=0;

if(discountController.text.isNotEmpty){
discount=(double.parse(discountController.text)*totalAmount)/100;


}
double newTotalAmount=totalAmount+tax-discount;

  
print("trying to save offline");
 
  Invoice? value;

 



 value=Invoice(

id:  uuid.v1(),
totalAmount: newTotalAmount,
createdDateTime: DateTime.now(),
issuranceDateTime: DateTime.now(),


customerId: customerId,
businessId: _businessController.selectedBusiness.value!.businessId,
paymentItemRequestList: productList,
isPending: true,
tax:tax,
discountAmount: discount

);

print("offline saving to database ${value!.toJson()}}");
   await _businessController.sqliteDb.insertInvoce(value!);
   GetOfflineInvoices(_businessController.selectedBusiness.value!.businessId!);
  // Get.to(() => IncomeSuccess(Invoice: value!,title: "Invoice",));
    final invoiceReceipt = await PdfInvoiceApi.generate(value);
              Get.to(() => PreviewInvoice(file: invoiceReceipt));
clearValue();
}
Future checkIfInvoiceThatIsYetToBeAdded()async{

  
  print("hoping Invoice to be added");
   var list= await _businessController.sqliteDb.getOfflineInvovoices(_businessController.selectedBusiness.value!.businessId!);
print("number of Invoice is ${list.length}");
list.forEach((element) {
  
if(element.isPending!){

  pendingInvoiceToBeAdded.add(element);
  print("is pending to be added");
}


});
print("number of Invoice that is yet to saved on server is ${pendingInvoiceToBeAdded.length}");
saveInvoiceOnline();
}

 bool checkifSelectedForDeleted(String id) {
    bool result = false;
    deletedItem.forEach((element) {
      print("checking transaction whether exist");
      if (element.id == id) {
        print("Customer   found");
        result = true;
      }
    });
    return result;
  }
Future saveInvoiceOnline()async{

  
  if(pendingInvoiceToBeAdded.isEmpty){

  return;

}

 

// pendingInvoice.forEach((e)async{
print("loading Invoice to server ");
try{
// if(!isBusyAdding){
var savenext=pendingInvoiceToBeAdded.first;
isBusyAdding=true;
print("saved next is ${savenext.toJson()}");
if(savenext.customerId!=null&& savenext.customerId!=" "){
  print("saved yet customer is not null");

var customervalue=await _businessController.sqliteDb.getOfflineCustomer(savenext.customerId!);
if(customervalue!=null&&customervalue!.isCreatedFromInvoice!){ 
  String? customerId= await _customerController.addBusinessCustomerWithString("INCOME");
  savenext.customerId=customerId;
  _businessController.sqliteDb.deleteCustomer(customervalue);
}else{

  print("saved yet customer is null");
}
}
// if(savenext.businessInvoiceFileStoreId!=null&& savenext.businessInvoiceFileStoreId!=''){

//   String image=await _uploadImageController.uploadFile(savenext.businessInvoiceFileStoreId!);
  
//   File _file=File(savenext.businessInvoiceFileStoreId!);
//   savenext.businessInvoiceFileStoreId=image;
//   _file.deleteSync();

// }

String body=jsonEncode({

"paymentItemRequestList":savenext.paymentItemRequestList!.map((e) => e.toJson()).toList(),

    "businessId":savenext.businessId,

   
    "customerId":savenext.customerId,
   
   
    "amountPaid":savenext.totalAmount,


});
print("Invoice body $body");
final response=await http.post(Uri.parse(ApiLink.invoice_link),headers: {
"Authorization":"Bearer ${_userController.token}",
"Content-Type":"application/json"

},body:body );

print({"sending to server Invoice response ${response.body}"});
await deleteItem(savenext);
pendingInvoiceToBeAdded.remove(savenext);
if(response.statusCode==200){

      print("Invoice response ${response.body}");
// pendingInvoice.remove(savenext);

 

// deletedItem.add(savenext);
  // saveInvoiceOnline();

if(pendingInvoiceToBeAdded.isNotEmpty){
print("saved size  left is ${pendingInvoiceToBeAdded.length}");
saveInvoiceOnline();
  // await GetOfflineInvoices(_businessController.selectedBusiness.value!.businessId!);
  //  getOnlineInvoice(_businessController.selectedBusiness.value!.businessId!);


// getSpending(_businessController.selectedBusiness.value!.businessId!);
}else{
print("done uploading  Invoice to server ");
await GetOfflineInvoices(_businessController.selectedBusiness.value!.businessId!);
   getOnlineInvoice(_businessController.selectedBusiness.value!.businessId!);
}
isBusyAdding=false;
}else{

  isBusyAdding=false;


//   print("pending Invoice is uploaded finished");
//   deleteItems();

Future.delayed(Duration(seconds: 5));

}
}catch(ex){



}



}

Future deleteItem(Invoice model)async{

 await  _businessController.sqliteDb.deleteInvoice(model);
}
void deleteItems(){

deletedItem.forEach((element) {
  deleteBusinessInvoice(element);

});

}

 Future deleteInvoiceOnline(Invoice invoice) async {
    var response = await http.delete(
        Uri.parse(ApiLink.invoice_link+
            "/${invoice.id}?businessId=${invoice.businessId}"),
        headers: {"Authorization": "Bearer ${_userController.token}"});
    print("delete response ${response.body}");
    if (response.statusCode == 200) {
    } else {}
  await  _businessController.sqliteDb.deleteInvoice(invoice);
   GetOfflineInvoices(_businessController.selectedBusiness.value!.businessId!);
  }

  Future deleteBusinessInvoice(Invoice invoice) async {
    if (_userController.onlineStatus == OnlineStatus.Onilne) {
      deleteInvoiceOnline(invoice);
    } else {
      deleteBusinessInvoiceOffline(invoice);
    }
  }

  Future deleteBusinessInvoiceOffline(Invoice invoice) async {
    invoice.deleted = true;

    if (!invoice.isPending!) {
     await _businessController.sqliteDb.updateOfflineInvoice(invoice);
    } else {
    await  _businessController.sqliteDb.deleteInvoice(invoice);
    }
    GetOfflineInvoices(_businessController.selectedBusiness.value!.businessId!);
    // getOfflineInvoice(_businessController.selectedBusiness.value!.businessId!);
  }
clearValue(){
print("clearing value");
  itemNameController.text="";
   amountController.text="";
   quantityController.text="";
  dateController.text="";
timeController.text="";
   paymentController.text="";
   paymentSourceController.text="";
  receiptFileController.text="";
amountPaidController.text="";
date=null;
image=null;
selectedPaymentMode=null;
selectedCustomer=null;
selectedPaymentSource=null;
selectedProduct=null;
productList=[];

  





 
}
// Future calculateOverView()async{

// var todayBalance=0;
// var todayMoneyIn=0;
// var todayMoneyout=0;

// todayInvoice.forEach((element) {
//      if(element.totalAmount==null){
//       return;
//     }
//   if(element.InvoiceType=="INCOME"){

// todayMoneyIn=todayMoneyIn+ element.totalAmount!;

//   }else{
 
//     print("total amount is ${element.totalAmount} ${element.toJson()}");
// todayMoneyout=todayMoneyout+element.totalAmount!;


//   }



// });
// todayBalance=todayMoneyIn-todayMoneyout;
// income(todayMoneyIn);
// expenses(todayMoneyout);
// totalbalance(todayBalance);
// }
void addMoreProduct(){

 
 if(selectedValue==0){
   
   if(selectedProduct!=null)
  productList.add(PaymentItem(
productId: selectedProduct!.productId!,
itemName:selectedProduct!.productName, 
amount:(amountController.text.isEmpty)? selectedProduct!.sellingPrice:int.parse(amountController.text),
totalAmount: (amountController.text.isEmpty)? (selectedProduct!.sellingPrice!*
(quantityController.text.isEmpty?1:int.parse(quantityController.text))):int.parse(amountController.text)*
(quantityController.text.isEmpty?1:int.parse(quantityController.text)),
quality:(quantityController.text.isEmpty)? 1:int.parse(quantityController.text)

  )); 





 }else{
   if(itemNameController.text.isNotEmpty && amountController.text.isNotEmpty)
productList.add(PaymentItem(
itemName: itemNameController.text,
quality: int.parse(quantityController.text),
amount: int.parse(amountController.text),
totalAmount: int.parse(amountController.text)*int.parse(quantityController.text)

));




 }

 selectedProduct=null;
 quantityController.text="1";
 amountController.text="";
 itemNameController.text="";
}

void addBankInvoice(){
if(paymentValue==0){

invoiceBank=selectedBank;

}else{
invoiceBank=Bank(
  bankName: bankName.text,
  bankAccountName: bankAccountName.text,
  bankAccountNumber: bankAccountNumber.text

);

}




}


Future selectEditValue(PaymentItem item)async{
 quantityController.text=item.quality.toString();
 amountController.text=item.amount.toString();
 itemNameController.text=item.itemName!;

}

Future updatePaymetItem(PaymentItem item,int index)async{
item.itemName=itemNameController.text;
item.quality=int.parse(quantityController.text);
item.amount=int.parse(amountController.text);
productList[index]=item;
 quantityController.text="1";
 amountController.text="";
 itemNameController.text="";

}

Future setValue(PaymentItem item)async{
  if(item.productId==null || item.productId!.isEmpty){
 quantityController.text=item.quality.toString();
 amountController.text=item.amount.toString();
 itemNameController.text=item.itemName!;
selectedValue=1;
  }else{
    selectedValue=0;
  selectedProduct=  _productController.productGoods.where((element) => element.productId==item.productId).toList().first;





  }


}



}