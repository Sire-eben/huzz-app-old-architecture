import 'package:flutter/material.dart';
import 'package:huzz/colors.dart';

class InventaryTabView extends StatefulWidget {
  const InventaryTabView({Key? key}) : super(key: key);

  @override
  _InventaryTabViewState createState() => _InventaryTabViewState();
}

class _InventaryTabViewState extends State<InventaryTabView> {
  List<bool> _isSelected = [
    false,
    true,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 5,
            left: 20,
            right: 20,
            child: Container(
              height: 300,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xffC3C3C3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Group 3625.png',
                    height: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Add Product',
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'DMSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your products will show here. Click the",
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'DMSans',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "New Product button to add your first prodcut",
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontFamily: 'DMSans',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Text(
              'Manage Inventory',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: 'DMSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: toggleButton(context),
          ),
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            child: productCount(context),
          ),
        ],
      ),
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  Widget toggleButton(BuildContext context) => Container(
        height: 55,
        child: ToggleButtons(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  "Delivery",
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  "Pick-up",
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
          renderBorder: true,
          isSelected: _isSelected,
          onPressed: onPressed,
          disabledColor: AppColor().backgroundColor,
          disabledBorderColor: AppColor().backgroundColor,
          color: Color(0xFF1A6164),
          fillColor: Color(0xFF07A58E),
          selectedColor: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10),
          borderWidth: 2,
          borderColor: Color(0xFF07A58E),
          splashColor: Color(0xFF07A58E),
          selectedBorderColor: Color(0xFF07A58E),
          highlightColor: Colors.green,
        ),
      );

  void onPressed(int newIndex) {
    setState(() {
      for (int index = 0; index < _isSelected.length; index++) {
        if (index == newIndex) {
          _isSelected[index] = true;
        } else {
          _isSelected[index] = false;
        }
      }
    });
  }

  Widget productCount(BuildContext context) => Container(
        height: 95,
        decoration: BoxDecoration(
          color: AppColor().backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Product Count",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DMSans',
                      fontSize: 12,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "0",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 95,
              padding: EdgeInsets.only(right: 9),
              decoration: BoxDecoration(
                color: AppColor().secondbgColor,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.1,
                    0.6,
                    0.8,
                  ],
                  colors: [
                    Color(0xff0D8372),
                    Color(0xff07A58E),
                    AppColor().backgroundColor.withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 39),
                      child: Text(
                        "Total service value",
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "N0.00",
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
