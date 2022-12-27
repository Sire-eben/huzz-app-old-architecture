import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/payment_item.dart';
import 'package:number_display/number_display.dart';
import 'package:huzz/core/util/util.dart';

// ignore: must_be_immutable
class ItemCard extends StatelessWidget {
  PaymentItem item;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  ItemCard({required this.item, this.onDelete, this.onEdit});
  @override
  Widget build(BuildContext context) {
    final display = createDisplay(
      roundingType: RoundingType.floor,
      length: 15,
      decimal: 5,
    );
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.03, vertical: 1),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: AppColors.backgroundColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.itemName!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${Utils.getCurrency()}${display(item.amount)}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Qty: ${item.quality}',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
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
