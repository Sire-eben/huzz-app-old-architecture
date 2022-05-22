import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/more/my_team.dart';
import 'package:huzz/app/screens/widget/more_widget.dart';
import 'package:huzz/colors.dart';
import 'help_and_support.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Do more with Huzz',
              style: TextStyle(
                color: AppColor().backgroundColor,
                fontFamily: 'InterRegular',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: Image.asset('assets/images/my_team.png'),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: Image.asset('assets/images/bank_wallet.png'),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: Image.asset('assets/images/my_store.png'),
            // ),

            //my team features
            InkWell(
              onTap: (() {
                Get.to(() => MyTeam());
              }),
              child: MoreWidget(
                image: 'assets/images/team 1.png',
                title: 'My Team',
                description: 'Collaborate with coworkers',
              ),
            ),
            SizedBox(
              height: 10,
            ),

            // InkWell(
            //   onTap: (() {
            //     // Get.to(() => MyTeam());
            //   }),
            //   child: MoreWidget(
            //     image: 'assets/images/wallett.png',
            //     title: 'Bank/Wallet',
            //     description: 'Maintain a Nigerian bank account',
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset('assets/images/bank_wallet.png'),
            ),
            SizedBox(
              height: 10,
            ),
            // InkWell(
            //   onTap: (() {
            //     // Get.to(() => MyTeam());
            //   }),
            //   child: MoreWidget(
            //     image: 'assets/images/storeee 1.png',
            //     title: 'Store',
            //     description: 'Sell your products easily',
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset('assets/images/my_store.png'),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (() {
                Get.to(() => HelpsAndSupport());
              }),
              child: MoreWidget(
                image: 'assets/images/image 3.png',
                title: 'Help and Support',
                description: '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBlur({
    required Widget child,
    double sigmaX = 10,
    double sigmaY = 10,
  }) =>
      BackdropFilter(
        filter: ImageFilter.blur(),
        child: child,
      );
}
