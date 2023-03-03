import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/constants/app_icons.dart';
import 'package:huzz/core/constants/app_strings.dart';
import 'package:huzz/core/constants/app_themes.dart';

class HelpTile extends StatefulWidget {
  final String icon, title;
  final VoidCallback action;
  final bool isSVG;

  const HelpTile({
    super.key,
    required this.icon,
    required this.title,
    required this.action,
    this.isSVG = false,
  });

  @override
  State<HelpTile> createState() => _HelpTileState();
}

class _HelpTileState extends State<HelpTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            child: InkWell(
              highlightColor: AppColors.backgroundColor.withOpacity(0.3),
              splashColor: AppColors.secondbgColor.withOpacity(0.3),
              onTap: widget.action,
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffE6F4F2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border: Border.all(
                          width: 2,
                          color: AppColors.whiteColor,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: widget.isSVG == true
                            ? SvgPicture.asset(
                                widget.icon,
                                height: 15,
                                width: 15,
                              )
                            : Image(
                                image: AssetImage(widget.icon),
                                width: 20,
                                height: 20),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.title,
                      style: GoogleFonts.inter(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      AppIcons.chevronRight,
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(Insets.lg),
      ],
    );
  }
}
