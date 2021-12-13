import 'dart:convert';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/offline_business.dart';
import 'package:huzz/model/product.dart';
import 'package:huzz/model/transaction_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDb {
  late Database db;
  static String databaseName = "HuzzOffline.db";
  static String businessTableName = "Business";
  static String businessId = "BusinessId";
  static String businessJson = "BusinessJson";
  static String transactionId = "TransactionId";
  static String transactionJson = "TransactionJson";
  static String transactionTableName = "Transactions";
  static String productbusinessTable="ProductBusinessTable";
  static String productId="ProductId";
  static String productJson="ProductJson";

   static String customerbusinessTable="CustomerBusinessTable";
  static String customerId="CustomerId";
  static String  customerJson="CustomerJson";

  Future openDatabae() async {
    final databasePath = await getDatabasesPath();
    // print(databasePath);
    final path = join(databasePath, "HuzzApipbbshhw");

    db = await openDatabase(path, version: 1,
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

      await db.execute('''create table $productbusinessTable (
$productId text primary key,
$productJson text not null,
$businessId text not null) 

''');
 

      await db.execute('''create table $customerbusinessTable (
$customerId text primary key,
$customerJson text not null,
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

  Future insertBusiness(OfflineBusiness offline) async {
    var result = db.insert(businessTableName, offline.toJson());
  }

  Future<List<OfflineBusiness>> getOfflineBusinesses() async {
    var result = await db.query(
      businessTableName,
    );
    var offlineBusiness =
        result.map((e) => OfflineBusiness.fromJson(e)).toList();
    return offlineBusiness;
  }

  Future<OfflineBusiness?> getOfflineBusiness(String id) async {
    var result = await db
        .query(businessTableName, where: '"BusinessId" = ?', whereArgs: [id]);
    if (result.length > 0) {
      return OfflineBusiness.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future updateOfflineBusiness(OfflineBusiness business) async {
    var result = await db.update(businessTableName, business.toJson(),
        where: '"BusinessId" = ?', whereArgs: [business.businessId]);

    print("updated $result");
  }

  Future insertTransaction(TransactionModel transaction) async {
    var value = jsonEncode(transaction.toJson());
    var result = db.insert(transactionTableName, {
      transactionId: transaction.id,
      businessId: transaction.businessId,
      transactionJson: value
    });
  }

  Future<List<TransactionModel>> getOfflineTransactions(String id) async {
    var result = await db.query(transactionTableName,
        where: '"BusinessId" = ?', whereArgs: [id]);
    var offlineTransaction = result
        .map((e) => TransactionModel.fromJson(
            jsonDecode(e[transactionJson].toString())))
        .toList();
    return offlineTransaction;
  }

  Future<TransactionModel?> getOfflineTransaction(String id) async {
    var result = await db.query(transactionTableName,
        where: '"TransactionId" = ?', whereArgs: [id]);
    if (result.length > 0) {
      var json = result.first;
      return TransactionModel.fromJson(
          jsonDecode(result.first[transactionJson].toString()));
    } else {
      return null;
    }
  }

  Future updateOfflineTransaction(TransactionModel transactionModel) async {
    var result = await db.update(
        transactionTableName, transactionModel.toJson(),
        where: '"$transactionId" = ?', whereArgs: [transactionModel.id]);

    print("updated $result");
  }

  Future deleteOfflineTransaction(TransactionModel transactionModel)async{
var result=await db.delete(transactionTableName,where:'"$transactionId" = ?',whereArgs: [transactionModel.id] );
print("transaction is deleted $result");

  }

Future insertProduct(Product product) async {
    var value = jsonEncode(product.toJson());
    var result = db.insert(productbusinessTable, {
      productId: product.productId,
      businessId: product.businessId,
      productJson: value
    });
  }

  Future<List<Product>> getOfflineProducts(String id) async {
    var result = await db.query(productbusinessTable,
        where: '"$businessId" = ?', whereArgs: [id]);
    var offlineProducts = result
        .map((e) => Product.fromJson(
            jsonDecode(e[productJson].toString())))
        .toList();
    return offlineProducts;
  }

  Future<Product?> getOfflineProduct(String id) async {
    var result = await db.query(productbusinessTable,
        where: '"$productId" = ?', whereArgs: [id]);
    if (result.length > 0) {
      var json = result.first;
      return Product.fromJson(
          jsonDecode(result.first[productJson].toString()));
    } else {
      return null;
    }
  }

  Future updateOfflineProdcut(Product product) async {
    var value = jsonEncode(product.toJson());
    var result = await db.update(
        productbusinessTable, {
           productId: product.productId,
      businessId: product.businessId,
      productJson: value
        },
        where: '"$productId" = ?', whereArgs: [product.productId]);

    print("updated $result");
  }


Future deleteProduct(Product product)async{
var result= await db.delete(  productbusinessTable, 
        where: '"$productId" = ?', whereArgs: [product.productId]);

print("result after delete ${result}");
}



Future insertCustomer(Customer customer) async {
    var value = jsonEncode(customer.toJson());
    var result = db.insert(customerbusinessTable, {
      customerId: customer.customerId,
      businessId: customer.businessId,
    customerJson: value
    });
  }

  Future<List<Customer>> getOfflineCustomers(String id) async {
    var result = await db.query(customerbusinessTable,
        where: '"$businessId" = ?', whereArgs: [id]);
    var offlineCustomers = result
        .map((e) => Customer.fromJson(
            jsonDecode(e[customerJson].toString())))
        .toList();
    return offlineCustomers;
  }

  Future<Customer?> getOfflineCustomer(String id) async {
    var result = await db.query(customerbusinessTable,
        where: '"$customerId" = ?', whereArgs: [id]);
    if (result.length > 0) {
      var json = result.first;
      return Customer.fromJson(
          jsonDecode(result.first[customerJson].toString()));
    } else {
      return null;
    }
  }

  Future updateOfflineCustomer(Customer customer) async {
    var value = jsonEncode(customer.toJson());
    var result = await db.update(
        customerbusinessTable, {
           customerId: customer.customerId,
      businessId: customer.businessId,
      customerJson: value
        },
        where: '"$customerId" = ?', whereArgs: [customer.customerId]);

    print("updated $result");
  }


Future deleteCustomer(Customer customer)async{
var result= await db.delete(  customerbusinessTable, 
        where: '"$customerId" = ?', whereArgs: [customer.customerId]);

print("result after delete ${result}");
}



}
