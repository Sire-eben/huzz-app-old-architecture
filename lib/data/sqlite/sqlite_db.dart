import 'dart:convert';
import 'package:huzz/model/bank.dart';
import 'package:huzz/model/customer_model.dart';
import 'package:huzz/model/debtor.dart';
import 'package:huzz/model/invoice.dart';
import 'package:huzz/model/offline_business.dart';
import 'package:huzz/model/product.dart';
import 'package:huzz/model/transaction_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDb {
  late Database db;
  static String databaseName = "HuzzOffline.db";

  static String businessTableName = "Business";
  static String businessId = "BusinessId";
  static String businessJson = "BusinessJson";

  static String transactionId = "TransactionId";
  static String transactionJson = "TransactionJson";
  static String transactionTableName = "Transactions";

  static String productbusinessTable = "ProductBusinessTable";
  static String productId = "ProductId";
  static String productJson = "ProductJson";

  static String bankAccountTable = "BankAccount";
  static String bankAccountId = "BankAccountId";
  static String bankAccountJson = "BankAccountJson";

  static String customerbusinessTable = "CustomerBusinessTable";
  static String customerId = "CustomerId";
  static String customerJson = "CustomerJson";

  // static String teambusinessTable = "TeamBusinessTable";
  // static String teamId = "TeamId";
  // static String teamJson = "TeamJson";

  static String invoiceTableName = "Invoice";
  static String invoiceJson = "InvoiceJson";
  static String invoiceId = "InvoiceId";

  static String debtorbusinessTable = "DebtorBusinessTable";
  static String debtorJson = "debtorJson";
  static String debtorId = "debtorId";

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

//       await db.execute('''create table $teambusinessTable (
// $teamId text primary key,
// $teamJson text not null,
// $businessId text not null)
// ''');

      await db.execute('''create table $bankAccountTable (
$bankAccountId text primary key,
$bankAccountJson text not null,
$businessId text not null) 
''');

      await db.execute('''create table $invoiceTableName (
$invoiceId text primary key,
$invoiceJson text not null,
$businessId text not null)
''');

      await db.execute('''create table $debtorbusinessTable (
$debtorId text primary key,
$debtorJson text not null,
$businessId text not null)
''');

// await db.execute(''' create table $playtableName (
// $courseId integer,
// $coursevideoplayedid integer,
// $positionLastWatched integer,
// $watchedDurationWatched integer
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

  Future deleteAllOfflineBusiness() async {
    db.delete(businessTableName);
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
    var value = jsonEncode(transactionModel.toJson());
    var result = await db.update(
        transactionTableName,
        {
          transactionId: transactionModel.id,
          businessId: transactionModel.businessId,
          transactionJson: value
        },
        where: '"$transactionId" = ?',
        whereArgs: [transactionModel.id]);

    print("updated $result");
  }

  Future<int> deleteOfflineTransaction(
      TransactionModel transactionModel) async {
    var result = await db.delete(transactionTableName,
        where: '"$transactionId" = ?', whereArgs: [transactionModel.id]);
    print("transaction  with ${transactionModel.id} is deleted $result ");
    return result;
  }

  Future deleteAllOfflineTransaction() async {
    await db.delete(transactionTableName);
  }
  // Future deleteOfflineTransaction(TransactionModel transactionModel) async {
  //   var result = await db.delete(transactionTableName,
  //       where: '"$transactionId" = ?', whereArgs: [transactionModel.id]);
  //   print("transaction is deleted $result");

  // }

// Future deleteAllOfflineTransaction()async{
//  await db.delete(transactionTableName);

// }

  Future insertProduct(Product product) async {
    var value = jsonEncode(product.toJson());
    var result = db.insert(productbusinessTable, {
      productId: product.productId,
      businessId: product.businessId,
      productJson: value
    });
  }

  Future insertDebtor(Debtor debtor) async {
    var value = jsonEncode(debtor.toJson());
    print("debtor value $value");
    var result = db.insert(debtorbusinessTable, {
      debtorId: debtor.debtorId,
      businessId: debtor.businessId,
      debtorJson: value
    });
  }

  Future<List<Product>> getOfflineProducts(String id) async {
    var result = await db.query(productbusinessTable,
        where: '"$businessId" = ?', whereArgs: [id]);
    var offlineProducts = result
        .map((e) => Product.fromJson(jsonDecode(e[productJson].toString())))
        .toList();
    return offlineProducts;
  }

  Future<List<Debtor>> getOfflineDebtors(String id) async {
    var result = await db.query(debtorbusinessTable,
        where: '"$businessId" = ?', whereArgs: [id]);
    var offlineDebtors = result
        .map((e) => Debtor.fromJson(jsonDecode(e[debtorJson].toString())))
        .toList();
    return offlineDebtors;
  }

  Future updateOfflineDebtor(Debtor debtor) async {
    var value = jsonEncode(debtor.toJson());
    var result = await db.update(
        debtorbusinessTable,
        {
          debtorId: debtor.debtorId,
          businessId: debtor.businessId,
          debtorJson: value
        },
        where: '"$debtorId" = ?',
        whereArgs: [debtor.debtorId]);

    print("updated $result");
  }

  Future<int> deleteOfflineDebtor(Debtor debtor) async {
    var result = await db.delete(debtorbusinessTable,
        where: '"$debtorId" = ?', whereArgs: [debtor.debtorId]);
    // print("transaction  with ${transactionModel.id} is deleted $result ");
    print("result of deleted debtors $result");
    return result;
  }

  Future deleteAllOfflineDebtors() async {
    await db.delete(debtorbusinessTable);
  }

  Future<Product?> getOfflineProduct(String id) async {
    var result = await db.query(productbusinessTable,
        where: '"$productId" = ?', whereArgs: [id]);
    if (result.length > 0) {
      var json = result.first;
      return Product.fromJson(jsonDecode(result.first[productJson].toString()));
    } else {
      return null;
    }
  }

  Future updateOfflineProdcut(Product product) async {
    var value = jsonEncode(product.toJson());
    var result = await db.update(
        productbusinessTable,
        {
          productId: product.productId,
          businessId: product.businessId,
          productJson: value
        },
        where: '"$productId" = ?',
        whereArgs: [product.productId]);

    print("updated $result");
  }

  Future deleteProduct(Product product) async {
    var result = await db.delete(productbusinessTable,
        where: '"$productId" = ?', whereArgs: [product.productId]);

    print("result after delete $result");
  }

  Future deleteAllProducts() async {
    db.delete(productbusinessTable);

// print("result after delete ${result}");
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
        .map((e) => Customer.fromJson(jsonDecode(e[customerJson].toString())))
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
        customerbusinessTable,
        {
          customerId: customer.customerId,
          businessId: customer.businessId,
          customerJson: value
        },
        where: '"$customerId" = ?',
        whereArgs: [customer.customerId]);

    print("updated $result");
  }

  Future deleteCustomer(Customer customer) async {
    var result = await db.delete(customerbusinessTable,
        where: '"$customerId" = ?', whereArgs: [customer.customerId]);

    print("result after delete $result");
  }

  Future deleteAllCustomers() async {
    db.delete(customerbusinessTable);
  }

  //Team SQL Db Logic
  // Future insertTeam(Teams teams) async {
  //   var value = jsonEncode(teams.toJson());
  //   var result = db.insert(teambusinessTable, {
  //     teamId: teams.teamId,
  //     businessId: teams.businessId,
  //     teamJson: value,
  //   });
  // }

  // Future<List<Teams>> getOfflineTeams(String id) async {
  //   var result = await db
  //       .query(teambusinessTable, where: '"$businessId" = ?', whereArgs: [id]);
  //   var offlineTeams = result
  //       .map((e) => Teams.fromJson(jsonDecode(e[teamJson].toString())))
  //       .toList();
  //   return offlineTeams;
  // }

  // Future<Teams?> getOfflineTeam(String id) async {
  //   var result = await db
  //       .query(teambusinessTable, where: '"$teamId" = ?', whereArgs: [id]);
  //   if (result.length > 0) {
  //     var json = result.first;
  //     return Teams.fromJson(jsonDecode(result.first[teamJson].toString()));
  //   } else {
  //     return null;
  //   }
  // }

  // Future updateOfflineTeam(Teams teams) async {
  //   var value = jsonEncode(teams.toJson());
  //   var result = await db.update(teambusinessTable,
  //       {teamId: teams.teamId, businessId: teams.businessId, teamJson: value},
  //       where: '"$teamId" = ?', whereArgs: [teams.teamId]);

  //   print("updated $result");
  // }

  // Future deleteTeam(Teams teams) async {
  //   var result = await db.delete(teambusinessTable,
  //       where: '"$teamId" = ?', whereArgs: [teams.teamId]);

  //   print("result after delete $result");
  // }

  // Future deleteAllTeam() async {
  //   db.delete(teambusinessTable);
  // }

//Bank SQL DB Logic
  Future insertBankAccount(Bank bank) async {
    var value = jsonEncode(bank.toJson());
    var result = db.insert(bankAccountTable, {
      bankAccountId: bank.id,
      businessId: bank.businessId,
      bankAccountJson: value
    });
  }

  Future<List<Bank>> getOfflineBankInfos(String id) async {
    var result = await db
        .query(bankAccountTable, where: '"$businessId" = ?', whereArgs: [id]);
    var offlineBankInfos = result
        .map((e) => Bank.fromJson(jsonDecode(e[bankAccountJson].toString())))
        .toList();
    return offlineBankInfos;
  }

  Future<Bank?> getOfflineBankInfo(String id) async {
    var result = await db.query(bankAccountTable,
        where: '"$bankAccountId" = ?', whereArgs: [id]);
    if (result.length > 0) {
      var json = result.first;
      return Bank.fromJson(
          jsonDecode(result.first[bankAccountJson].toString()));
    } else {
      return null;
    }
  }

  Future updateOfflineBank(Bank bank) async {
    var value = jsonEncode(bank.toJson());
    var result = await db.update(
        bankAccountTable,
        {
          bankAccountId: bank.id,
          businessId: bank.businessId,
          bankAccountJson: value
        },
        where: '"$bankAccountId" = ?',
        whereArgs: [bank.id]);

    print("updated $result");
  }

  Future deleteBank(Bank bank) async {
    var result = await db.delete(customerbusinessTable,
        where: '"$bankAccountId" = ?', whereArgs: [bank.id]);

    print("result after delete $result");
  }

  Future deleteAllBanks() async {
    db.delete(bankAccountTable);
  }

  Future insertInvoce(Invoice invoice) async {
    var value = jsonEncode(invoice.toJson());
    var result = db.insert(invoiceTableName, {
      invoiceId: invoice.id,
      businessId: invoice.businessId,
      invoiceJson: value
    });
  }

  Future<List<Invoice>> getOfflineInvovoices(String id) async {
    var result = await db
        .query(invoiceTableName, where: '"$businessId" = ?', whereArgs: [id]);
    var offlineInvoices = result
        .map((e) => Invoice.fromJson(jsonDecode(e[invoiceJson].toString())))
        .toList();
    return offlineInvoices;
  }

  Future<Invoice?> getOfflineInvoice(String id) async {
    var result = await db
        .query(invoiceTableName, where: '"$invoiceId" = ?', whereArgs: [id]);
    if (result.length > 0) {
      var json = result.first;
      return Invoice.fromJson(jsonDecode(result.first[invoiceJson].toString()));
    } else {
      return null;
    }
  }

  Future updateOfflineInvoice(Invoice invoice) async {
    var value = jsonEncode(invoice.toJson());
    var result = await db.update(
        invoiceTableName,
        {
          invoiceId: invoice.id,
          businessId: invoice.businessId,
          invoiceJson: value
        },
        where: '"$invoiceId" = ?',
        whereArgs: [invoice.id]);

    print("updated $result");
  }

  Future deleteInvoice(Invoice invoice) async {
    var result = await db.delete(invoiceTableName,
        where: '"$invoiceId" = ?', whereArgs: [invoice.id]);

    print("result after delete $result");
  }

  Future deleteAllInvoice() async {
    db.delete(invoiceTableName);
  }
}
