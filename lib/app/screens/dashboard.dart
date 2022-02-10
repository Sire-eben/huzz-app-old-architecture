import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/invoice_repository.dart';
import 'package:huzz/app/screens/customers/customer_tabView.dart';
import 'package:huzz/app/screens/invoice/empty_invoice.dart';
import 'package:huzz/app/screens/more.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'customers/customer_tabView.dart';
import 'home/home.dart';
import 'inventory/manage_inventory.dart';
import 'invoice/available_invoice.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  int? selectedIndex;
  Dashboard({
    Key? key,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  _DashboardState createState() =>
      _DashboardState(selectedIndex: selectedIndex!);
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  _DashboardState({required this.selectedIndex});
  final _invoiceRepository = Get.find<InvoiceRespository>();
  // ignore: unused_element
  void _selectPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final inactiveColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPages(),
      bottomNavigationBar: BottomNavyBar(
        showElevation: false,
        selectedIndex: selectedIndex,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text(
                'Home',
                style: AppThemes.style12PriBold,
              ),
              activeColor: AppColor().backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: Icon(
                CupertinoIcons.person_3_fill,
                size: 32,
              ),
              title: Text(
                'Customers',
                style: AppThemes.style12PriBold,
              ),
              activeColor: AppColor().backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: Icon(Icons.inventory),
              title: Text(
                'Inventory',
                style: AppThemes.style12PriBold,
              ),
              activeColor: AppColor().backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: Icon(Icons.receipt),
              title: Text(
                'Invoice',
                style: AppThemes.style12PriBold,
              ),
              activeColor: AppColor().backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: Icon(Icons.grid_view_rounded),
              title: Text(
                'More',
                style: AppThemes.style12PriBold,
              ),
              activeColor: AppColor().backgroundColor,
              inactiveColor: inactiveColor),
        ],
        onItemSelected: (index) => setState(() => this.selectedIndex = index),
      ),
    );
  }

  Widget buildPages() {
    switch (selectedIndex) {
      case 0:
        return Home();
      case 1:
        return CustomerTabView();
      case 2:
        return ManageInventory();
      case 3:
        return (_invoiceRepository.InvoicePendingList.length == 0 &&
                _invoiceRepository.InvoiceDueList.length == 0 &&
                _invoiceRepository.InvoiceDepositList.length == 0 &&
                _invoiceRepository.paidInvoiceList.length == 0)
            ? EmptyInvoice()
            : AvailableInvoice();
      case 4:
      default:
        return More();
    }
  }
}
