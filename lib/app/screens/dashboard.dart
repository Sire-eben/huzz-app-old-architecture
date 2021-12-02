import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:huzz/app/screens/inventory.dart';
import 'package:huzz/app/screens/invoice.dart';
import 'package:huzz/app/screens/more.dart';
import 'package:huzz/app/screens/customers/customer_tabView.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'home/home.dart';
import 'package:huzz/app/screens/users%20screen/home.dart';
import 'package:huzz/colors.dart';
import 'home/home.dart';
import 'invoice.dart';
import 'users screen/team.dart';
import 'users screen/inventry.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int index = 2;

  final inactiveColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPages(),
      bottomNavigationBar: BottomNavyBar(
        showElevation: false,
        selectedIndex: index,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              icon: Icon(Icons.people),
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
        onItemSelected: (index) => setState(() => this.index = index),
      ),
    );
  }

  Widget buildPages() {
    switch (index) {
      case 0:
        return CustomerTabView();
      case 1:
        return Inventory();
      case 2:
        return Home();
      case 3:
        return Invoice();
      case 4:
      default:
        return Container();
    }
  }
}
