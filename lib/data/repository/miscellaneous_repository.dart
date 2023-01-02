import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:huzz/data/api_link.dart';
import 'package:huzz/data/sharepreference/sharepref.dart';
import 'auth_repository.dart';

class MiscellaneousRepository extends GetxController {
  Rx<List<String>> productTypeList = Rx([]);

  Rx<List<String>> businessTransactionExpenseCategoryList = Rx([]);

  Rx<List<String>> businessTransactionPaymentModeList = Rx([]);

  Rx<List<String>> businessTransactionPaymentSourceList = Rx([]);

  Rx<List<String>> businessTransactionTypeList = Rx([]);

  Rx<List<String>> businessCategoryList = Rx([]);

  Rx<List<String>> businessCurrencyList = Rx([]);

  Rx<List<String>> reminderIntervalList = Rx([]);
  Rx<List<String>> reminderTargetList = Rx([]);

  Rx<List<String>> reminderTypeList = Rx([]);

  Rx<List<String>> teamAuthorityList = Rx([]);

  Rx<List<String>> teamMemberStatusList = Rx([]);

  Rx<List<String>> teamRoleList = Rx([]);

  Rx<List<String>> businessInvoiceStatusList = Rx([]);

  Rx<List<String>> unitTypeList = Rx([]);
  SharePref pref = SharePref();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await pref.init();

    getMiscellaneousOnline();
    getMiscellaneousOffline();
  }

  Future getMiscellaneousOnline() async {
    var response = await http.get(Uri.parse(ApiLink.miscellaneous));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      var data = json['data'];

      pref.setMiscellaneous(response.body);
      getMiscellaneousOffline();
    }
  }

  Future getMiscellaneousOffline() async {
    String value = pref.getMiscellaneous();
    if (value.isNotEmpty) {
      // print("miscellaneous from offline is $value");
      var json1 = jsonDecode(value);
      var json = json1['data'];
      productTypeList(List.from(json['productTypeList']));
      businessTransactionExpenseCategoryList(
          List.from(json['businessTransactionExpenseCategoryList']));
      businessTransactionPaymentModeList(
          List.from(json['businessTransactionPaymentModeList']));
      businessTransactionPaymentSourceList(
          List.from(json['businessTransactionPaymentSourceList']));

      businessTransactionTypeList(
          List.from(json['businessTransactionTypeList']));
      businessCategoryList(List.from(json['businessCategoryList']));

      businessCurrencyList(List.from(json['businessCurrencyList']));
      reminderIntervalList(List.from(json['reminderIntervalList']));
      reminderTargetList(List.from(json['reminderTargetList']));
      reminderTypeList(List.from(json['reminderTypeList']));

      teamAuthorityList(List.from(json['teamAuthorityList']));
      teamMemberStatusList(List.from(json['teamMemberStatusList']));

      teamRoleList(List.from(json['teamRoleList']));
      businessInvoiceStatusList(List.from(json['businessInvoiceStatusList']));

      unitTypeList(List.from(json['unitTypeList']));
    }
  }
}
