// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/bank.dart';

class ItemCard extends StatelessWidget {
  Bank item;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  ItemCard({super.key, required this.item, this.onDelete, this.onEdit});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: AppColors.backgroundColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                item.bankAccountName!,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 2,
              child: Text(
                item.bankAccountNumber!,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 2,
              child: Text(
                item.bankName!,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
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
            const SizedBox(
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
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
