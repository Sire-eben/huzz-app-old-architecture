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
      body: Stack(
        children: [
          //
          // Positioned.fill(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(
          //       sigmaX: 10,
          //       sigmaY: 10,
          //     ),
          //     child: Container(
          //       color: Colors.white.withOpacity(0.9),
          //     ),
          //   ),
          // ),
          //
          // Positioned.fill(
          //   top: 5,
          //   left: 20,
          //   right: 20,
          //   bottom: 550,
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(
          //       sigmaX: 10,
          //       sigmaY: 10,
          //     ),
          //     child: Container(
          //       padding: EdgeInsets.symmetric(
          //         horizontal: 10,
          //         vertical: 20,
          //       ),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         color: Colors.grey.withOpacity(0.2),
          //       ),
          //       child: Row(
          //         children: [
          //           Image.asset('assets/images/team 1.png'),
          //           SizedBox(
          //             width: 20,
          //           ),
          //           Column(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'My Team',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   fontStyle: FontStyle.normal,
          //                   fontSize: 16,
          //                 ),
          //               ),
          //               Text(
          //                 'Collaborate with coworkers',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.normal,
          //                   fontStyle: FontStyle.normal,
          //                   fontSize: 12,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Spacer(),
          //           Row(
          //             children: [
          //               Icon(
          //                 Icons.keyboard_arrow_right,
          //                 color: AppColor().backgroundColor,
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
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
                //   height: 20,
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
        ],
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
