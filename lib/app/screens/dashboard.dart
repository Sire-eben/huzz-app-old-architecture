import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huzz/app/screens/more.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/core/constants/app_themes.dart';

import 'customers/customer_tabView.dart';
import 'home/home.dart';
import 'inventory/manage_inventory.dart';
import 'invoice/invoice.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 2;
  // ignore: unused_element
  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final inactiveColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPages(),
      bottomNavigationBar: BottomNavyBar(
        showElevation: false,
        selectedIndex: _selectedIndex,
        items: <BottomNavyBarItem>[
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
              icon: Icon(Icons.home),
              title: Text(
                'Home',
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
              icon: Icon(Icons.dashboard),
              title: Text(
                'More',
                style: AppThemes.style12PriBold,
              ),
              activeColor: AppColor().backgroundColor,
              inactiveColor: inactiveColor)
        ],
        onItemSelected: (index) => setState(() => this._selectedIndex = index),
      ),
    );
  }

  Widget buildPages() {
    switch (_selectedIndex) {
      case 0:
        return CustomerTabView();
      case 1:
        return ManageInventory();
      case 2:
        return Home();
      case 3:
        return Invoice();
      case 4:
      default:
        return More();
    }
  }
}
