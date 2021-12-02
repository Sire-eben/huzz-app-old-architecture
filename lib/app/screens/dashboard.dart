import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:huzz/app/screens/inventory.dart';
import 'package:huzz/app/screens/invoice.dart';
import 'package:huzz/app/screens/more.dart';
import 'package:huzz/app/screens/team.dart';
import 'package:huzz/colors.dart';
import 'home/home.dart';
import 'package:huzz/app/screens/users%20screen/home.dart';
import 'users screen/team.dart';
import 'users screen/inventry.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<Widget> _screens;

  // @override
  // void initState() {
  //   _screens = [
  //     //teams
  //     Teams(),

  //     //inventry
  //     InventaryTabView(),

  //     //home
  //     HomePage(),

  //     //invoice
  //     //Invoice(),
  //     InventaryTabView(),

  //     //more
  //     //More(),
  //     InventaryTabView(),
  //   ];
  //   super.initState();
  // }

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
        return InventaryTabView();
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
