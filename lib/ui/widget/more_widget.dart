import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';

class MoreWidget extends StatelessWidget {
  final String? image;
  final String? description;
  final String? title;
  final Widget? page;

  const MoreWidget(
      {Key? key, this.image, this.title, this.description, this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(31, 150, 150, 150),
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 100,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image.asset(
              image!,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                ),
              ),
              Text(
                description!,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.keyboard_arrow_right,
            color: AppColors.backgroundColor,
          ),
        ],
      ),
    ).onTap(() => Get.to(page));
  }
}
