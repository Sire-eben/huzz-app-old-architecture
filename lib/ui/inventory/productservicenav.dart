import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:huzz/ui/customers/customer_tabView.dart';
import 'package:huzz/ui/home/home.dart';
import 'package:huzz/ui/inventory/productserviceTab.dart';
import 'package:huzz/ui/invoice/available_invoice.dart';
import 'package:huzz/ui/more/more.dart';
import 'package:huzz/core/constants/app_themes.dart';

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
              icon: const Icon(Icons.people),
              title: const Text('Customers'),
              textAlign: TextAlign.center,
              activeColor: AppColors.backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: const Icon(Icons.inventory),
              title: const Text('Inventory'),
              activeColor: AppColors.backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              activeColor: AppColors.backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: const Icon(Icons.receipt),
              title: const Text('Invoice'),
              activeColor: AppColors.backgroundColor,
              inactiveColor: inactiveColor),
          BottomNavyBarItem(
              icon: const Icon(Icons.dashboard),
              title: const Text('More'),
              activeColor: AppColors.backgroundColor,
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
        return const ProductServiceListing();
      case 2:
        return const HomePage();
      case 3:
        return const AvailableInvoice();
      case 4:
      default:
        return const More();
    }
  }
}
