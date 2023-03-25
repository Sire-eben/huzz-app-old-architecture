import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:huzz/core/constants/app_themes.dart';

class HuzzDeleteDialog extends StatefulWidget {
  final VoidCallback? action;
  final String title, content;

  const HuzzDeleteDialog(
      {super.key, this.action, required this.title, required this.content});

  @override
  State<HuzzDeleteDialog> createState() => _HuzzDeleteDialogState();
}

class _HuzzDeleteDialogState extends State<HuzzDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete ${widget.title}"),
      titleTextStyle: TextStyles.h3.copyWith(
        color: AppColors.primaryColor,
      ),
      contentTextStyle: TextStyles.t3.copyWith(color: Colors.black),
      content: Text(
          'You are about to delete a ${widget.content}, Are you sure you want to continue?',
          style: TextStyles.t12N),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border: Border.all(
                          width: 2,
                          color: AppColors.backgroundColor,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Cancel',
                        style: TextStyles.t12B
                            .copyWith(color: AppColors.primaryColor)),
                  ),
                ),
              ),
              const Gap(Insets.md),
              Expanded(
                child: InkWell(
                  onTap: widget.action,
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                        color: AppColors.orangeBorderColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Delete',
                        style: TextStyles.t12B.copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
