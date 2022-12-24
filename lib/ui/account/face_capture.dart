import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/core/util/extension.dart';
import 'package:huzz/core/widgets/appbar.dart';
import 'package:huzz/core/widgets/button/button.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/generated/assets.gen.dart';
import 'package:huzz/ui/account/id_verification.dart';

enum FaceCapture { initial, loading, successful, unsuccessful }

// ignore: must_be_immutable
class FaceCaptureCreen extends StatefulWidget {
  FaceCapture faceCapture;

  FaceCaptureCreen({
    super.key,
    this.faceCapture = FaceCapture.initial,
  });

  @override
  State<FaceCaptureCreen> createState() => _FaceCaptureCreenState();
}

class _FaceCaptureCreenState extends State<FaceCaptureCreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
      body: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'STEP ONE',
                  style: TextStyles.t2.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),

                //Indicator
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 4,
                          width: 42,
                          margin: const EdgeInsets.only(
                            right: Insets.sm,
                          ),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Corners.smRadius),
                              color: AppColors.primaryColor),
                        ),
                        Container(
                          height: 4,
                          width: 42,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Corners.smRadius),
                              color: Colors.grey.shade300),
                        )
                      ]),
                ),
                const Gap(Insets.xl * 2),

                widget.faceCapture == FaceCapture.initial
                    ? const Text('Ensure you are in a well-lit environment')
                    : Text('Facial Capture\nSuccessful!',
                        textAlign: TextAlign.center,
                        style: TextStyles.h3.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          // fontSize: 14,
                        )),
                const Gap(Insets.xl * 2),
                widget.faceCapture == FaceCapture.initial
                    ? Image.asset(Assets.icons.imported.faceScan.path)
                    : widget.faceCapture == FaceCapture.successful
                        ? Image.asset(Assets.icons.imported.success.path)
                        : Image.asset(Assets.images.huzz),
                const Spacer(),
                widget.faceCapture == FaceCapture.initial
                    ? Button(
                        label: 'Verify',
                        action: () {
                          setState(() {
                            widget.faceCapture = FaceCapture.successful;
                          });
                        },
                      )
                    : widget.faceCapture == FaceCapture.successful
                        ? Button(
                            label: 'Proceed',
                            action: () {
                              context.push(IdVerificationScreen());
                            },
                          )
                        : Button(
                            label: 'Proceed',
                            action: () {},
                          ),
                const Gap(Insets.xl),
              ],
            ),
          )),
    );
  }
}
