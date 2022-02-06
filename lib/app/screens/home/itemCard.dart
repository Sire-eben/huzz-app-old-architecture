import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:huzz/colors.dart';
import 'package:huzz/model/payment_item.dart';

// ignore: must_be_immutable
class ItemCard extends StatelessWidget {
  PaymentItem item;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  ItemCard({required this.item, this.onDelete, this.onEdit});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.03, vertical: 10),
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
              flex: 6,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName!,
                      style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'N ${item.amount}',
                      style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Qty: ${item.quality}',
                style: TextStyle(
                  fontFamily: "DMSans",
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
            Expanded(
              child: GestureDetector(
                onTap: onDelete!,
                child: SvgPicture.asset(
                  'assets/images/delete.svg',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
