import 'dart:convert';

import 'package:huzz/model/offline_business.dart';
import 'package:huzz/model/transaction_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SqliteDb {
late Database db;
static String databaseName="HuzzOffline.db";
static  String businessTableName="Business";
static String businessId="BusinessId";
static String businessJson="BusinessJson";
static String transactionId="TransactionId";
static String transactionJson="TransactionJson";
static String transactionTableName="Transactions";


Future openDatabae()async{
 final databasePath = await getDatabasesPath();
  // print(databasePath);
  final path = join(databasePath, "HuzzAppbbsw");

 db = await openDatabase( path,version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $businessTableName ( 
  $businessId text primary key, 
  $businessJson text not null)
''');
  
 await db.execute('''
create table $transactionTableName ( 
  $transactionId text primary key, 
  $transactionJson text not null,
  $businessId text not null)
''');
  
// await db.execute(''' create table $playtableName (
// $courseId integer,
// $coursevideoplayedid integer,
// $positionLastWatched integer,
// $watchedDurationWatched integer,
// $courseVideoTitle text not null,
// $userId integer) 


// ''');  

// await db.execute(''' create table $courseTable (
//   $courseId integer,
//   $courseDetails text not null
// )'''


// );
// await db.execute(''' create table $imageTable (
// $imageId text not null,
// $imagePath text not null)
// ''');

    });


}

Future insertBusiness(OfflineBusiness offline)async{
 var result=db.insert(businessTableName, offline.toJson());

}

Future<List<OfflineBusiness>> getOfflineBusinesses()async{
var result=await db.query(businessTableName,);
var offlineBusiness=result.map((e) => OfflineBusiness.fromJson(e)).toList();
return offlineBusiness;

}
Future<OfflineBusiness?> getOfflineBusiness(String id)async{
var result=await db.query(businessTableName,where:  '"BusinessId" = ?',whereArgs: [id]);
if(result.length>0){

  return OfflineBusiness.fromJson(result.first);
}else{

  return null;
}


}
Future updateOfflineBusiness (OfflineBusiness business)async{
var result=await db.update(businessTableName, business.toJson(),where: '"BusinessId" = ?',whereArgs: [business.businessId]);

print("updated $result");


}


Future insertTransaction(TransactionModel transaction)async{
  var value=jsonEncode(transaction.toJson());
 var result=db.insert(transactionTableName,{
   transactionId:transaction.id,
   businessId:transaction.businessId,
   transactionJson:value

 } );

}

Future<List<TransactionModel>> getOfflineTransactions(String id)async{
var result=await db.query(transactionTableName,where: '"BusinessId" = ?',whereArgs: [id]);
var offlineTransaction=result.map((e) => TransactionModel.fromJson(jsonDecode(e[transactionJson].toString()))).toList();
return offlineTransaction;

}
Future<TransactionModel?> getOfflineTransaction(String id)async{
var result=await db.query(transactionTableName,where:'"TransactionId" = ?',whereArgs: [id]);
if(result.length>0){
var json=result.first;
  return TransactionModel.fromJson(jsonDecode(result.first[transactionJson].toString()));
}else{

  return null;
}


}
Future updateOfflineTransaction(TransactionModel transactionModel)async{
var result=await db.update(transactionTableName, transactionModel.toJson(),where: transactionId,whereArgs: [transactionModel.id]);

print("updated $result");


}

}