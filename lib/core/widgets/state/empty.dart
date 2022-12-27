import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/generated/assets.gen.dart';

class EmptyOrErrorWidget extends StatelessWidget {
  final String title, subtitle;
  final String? icon, buttonText;
  final VoidCallback? onBtnPressed;
  const EmptyOrErrorWidget({
    this.title = "",
    this.subtitle = "",
    this.buttonText,
    this.onBtnPressed,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Insets.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LocalSvgIcon(icon ?? Assets.icons.linear.documentCopy, size: 64),
          const Gap(Insets.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(Insets.xs),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          if (buttonText != null) ...[
            const Gap(Insets.lg),
            Button(
              label: buttonText!,
              action: () => onBtnPressed?.call(),
              shrinkWrap: true,
            ),
          ],
          const Gap(Insets.lg),
        ],
      ),
    );
  }
}
