import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:huzz/app/screens/home/home.dart';
import 'package:huzz/app/screens/inventory/productserviceTab.dart';
import 'package:huzz/app/screens/invoice.dart';
import 'package:huzz/app/screens/more.dart';
import 'package:huzz/app/screens/team.dart';
import 'package:huzz/colors.dart';

class ProServiceDashboard extends StatefulWidget {
  const ProServiceDashboard({Key? key}) : super(key: key);

  @override
  _ProServiceDashboardState createState() => _ProServiceDashboardState();
}

class _ProServiceDashboardState extends State<ProServiceDashboard> {
  int _selectedIndex = 1;
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
        selectedIndex: _selectedIndex,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              icon: Icon(Icons.people),
              title: Text('Teams'),
              textAlign: TextAlign.center,
              activeColor: AppColor().backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: Icon(Icons.inventory),
              title: Text('Inventory'),
              activeColor: AppColor().backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: AppColor().backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: Icon(Icons.receipt),
              title: Text('Invoice'),
              activeColor: AppColor().backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: Icon(Icons.dashboard),
              title: Text('More'),
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
        return Team();
      case 1:
        return ProductServiceListing();
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
