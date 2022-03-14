import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:huzz/colors.dart';

class EmptyInvoiceInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/frown.svg',
              height: 40,
            ),
            Text(
              'Oh, snap. No transactions to show',
              style: TextStyle(
                color: AppColor().blackColor,
                fontFamily: 'InterRegular',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
