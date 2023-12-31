import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/services/dynamic_linking/referral_dynamic_link_api.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/user_referral_model.dart';
import 'package:huzz/ui/widget/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferralBottomsheet extends StatefulWidget {
  const ReferralBottomsheet({Key? key}) : super(key: key);

  @override
  _ReferralBottomsheetState createState() => _ReferralBottomsheetState();
}

class _ReferralBottomsheetState extends State<ReferralBottomsheet> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final controller = Get.find<AuthRepository>();
  late Future<UserReferralModel?> future;
  bool isLoadingReferralLink = false;
  String? referralLink;

  @override
  void initState() {
    future = controller.getUserReferralData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final kHeight = MediaQuery.of(context).size.height / 3;

    return Consumer<ReferralDynamicLinksApi>(builder: (context, refer, child) {
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            )),
        child: Material(
          color: Colors.transparent,
          child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    height: kHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              future = controller.getUserReferralData();
                            });
                          },
                          child: Text(
                            "RETRY",
                            style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.backgroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  final referralData = snapshot.data as UserReferralModel;
                  return Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Invite business owners",
                              style: textTheme.headlineMedium!.copyWith(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Image.asset(
                              "assets/images/referral.png",
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Love Huzz? Spread the word and watch your referral count grow. Ask business owners you refer to enter your referral code when they sign up. In the future, your referral count will contribute to your Huzz Loyalty points which you can use to earn awesome rewards.",
                              style: textTheme.caption!.copyWith(
                                fontSize: 12,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 18),
                              decoration: const BoxDecoration(
                                color: Color(0xffE6F4F2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Referral Count",
                                    style: textTheme.caption!.copyWith(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "${referralData.count}",
                                    style: textTheme.headlineLarge!
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(children: [
                                      const TextSpan(text: "Referral Code: "),
                                      TextSpan(
                                        // ignore: unnecessary_string_interpolations
                                        text: "${referralData.referralCode}",
                                        style: textTheme.bodyMedium!.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.backgroundColor,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      ClipboardData(
                                        text: referralData.referralCode,
                                      ),
                                    );
                                    Get.snackbar(
                                      "Success",
                                      "Referral code successfully copied to clipboard",
                                      icon: const Icon(Icons.check),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 7),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffE6F4F2),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          "assets/images/copyIcon.png",
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Copy",
                                          style: textTheme.caption!.copyWith(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 24),
                            InkWell(
                              onTap: () async {
                                setState(() => isLoadingReferralLink = true);
                                final dynamicLink =
                                    await refer.createReferralLink(
                                        code: referralData.referralCode);
                                Share.share(
                                    "Click on the link below to sign up on Huzz. Link: $dynamicLink");

                                setState(() => isLoadingReferralLink = false);
                              },
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: isLoadingReferralLink
                                      ? LoadingWidget()
                                      : Text(
                                          'Share Referral Link',
                                          style: GoogleFonts.inter(
                                            color: AppColors.whiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: Container(
                          height: 3,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      )
                    ],
                  );
                }
                return SizedBox(
                    height: kHeight,
                    child: LoadingWidget(
                      color: AppColors.backgroundColor,
                    ));
              }),
        ),
      );
    });
  }
}
