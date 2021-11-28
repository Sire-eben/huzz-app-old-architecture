import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:huzz/app/screens/users%20screen/home.dart';
import 'package:huzz/colors.dart';
import 'users screen/team.dart';
import 'users screen/inventry.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<Widget> _screens;

  @override
  void initState() {
    _screens = [
      //teams
      Teams(),

      //inventry
      InventaryTabView(),

      //home
      HomePage(),

      //invoice
      //Invoice(),
      InventaryTabView(),

      //more
      //More(),
      InventaryTabView(),
    ];
    super.initState();
  }

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
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Color(0xffC3C3C3).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: BottomNavyBar(
          backgroundColor: Color(0xffF5F5F5),
          selectedIndex: _selectedIndex,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                icon: Icon(Icons.people),
                title: Text('Teams'),
                activeColor: AppColor().backgroundColor,
                inactiveColor: inactiveColor),
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                icon: Icon(Icons.inventory),
                title: Text('Inventory'),
                activeColor: AppColor().backgroundColor,
                inactiveColor: inactiveColor),
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                icon: Icon(Icons.home),
                title: Text('Home'),
                activeColor: AppColor().backgroundColor,
                inactiveColor: inactiveColor),
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                icon: Icon(Icons.receipt),
                title: Text('Invoice'),
                activeColor: AppColor().backgroundColor,
                inactiveColor: inactiveColor),
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                icon: Icon(Icons.dashboard),
                title: Text('More'),
                activeColor: AppColor().backgroundColor,
                inactiveColor: inactiveColor)
          ],
          onItemSelected: (index) =>
              setState(() => this._selectedIndex = index),
        ),
      ),
    );
  }
}
