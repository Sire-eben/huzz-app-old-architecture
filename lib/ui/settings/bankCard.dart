// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:huzz/util/colors.dart';
import 'package:huzz/data/model/bank.dart';

class BankCard extends StatelessWidget {
  Bank item;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  BankCard({required this.item, this.onDelete, this.onEdit});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: AppColor().backgroundColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                item.bankAccountName!,
                style: TextStyle(
                  fontFamily: "InterRegular",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 3,
              child: Text(
                item.bankAccountNumber!,
                style: TextStyle(
                  fontFamily: "InterRegular",
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 3,
              child: Text(
                item.bankName!,
                style: TextStyle(
                  fontFamily: "InterRegular",
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  onEdit!();
                },
                child: SvgPicture.asset(
                  'assets/images/edit.svg',
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: GestureDetector(
                onTap: onDelete!,
                child: SvgPicture.asset(
                  'assets/images/delete.svg',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
