import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/app/screens/home/help_and_support.dart';
import 'package:huzz/colors.dart';

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
                fontFamily: 'DMSans',
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset('assets/images/my_team.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset('assets/images/bank_wallet.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset('assets/images/my_store.png'),
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 10,
                //     vertical: 20,
                //   ),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     color: Color.fromARGB(31, 150, 150, 150),
                //   ),
                //   child: Row(
                //     children: [
                //       Image.asset('assets/images/storeee 1.png'),
                //       SizedBox(
                //         width: 20,
                //       ),
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Bank/Wallet',
                //             style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontStyle: FontStyle.normal,
                //               fontSize: 16,
                //             ),
                //           ),
                //           Text(
                //             'Maintain a Nigerian bank account',
                //             style: TextStyle(
                //               fontWeight: FontWeight.normal,
                //               fontStyle: FontStyle.normal,
                //               fontSize: 12,
                //             ),
                //           ),
                //         ],
                //       ),
                //       Spacer(),
                //       Row(
                //         children: [
                //           Icon(
                //             Icons.keyboard_arrow_right,
                //             color: AppColor().backgroundColor,
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 10,
                //     vertical: 20,
                //   ),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     color: Color.fromARGB(31, 150, 150, 150),
                //   ),
                //   child: Row(
                //     children: [
                //       Image.asset('assets/images/store.png'),
                //       SizedBox(
                //         width: 20,
                //       ),
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Store',
                //             style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontStyle: FontStyle.normal,
                //               fontSize: 16,
                //             ),
                //           ),
                //           Text(
                //             'Sell your products easily',
                //             style: TextStyle(
                //               fontWeight: FontWeight.normal,
                //               fontStyle: FontStyle.normal,
                //               fontSize: 12,
                //             ),
                //           ),
                //         ],
                //       ),
                //       Spacer(),
                //       Row(
                //         children: [
                //           Icon(
                //             Icons.keyboard_arrow_right,
                //             color: AppColor().backgroundColor,
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: (() {
                    Get.to(HelpsAndSupport());
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(31, 150, 150, 150),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/image 3.png',
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Help and Support',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: AppColor().backgroundColor,
                            ),
                          ],
                        ),
                      ],
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
