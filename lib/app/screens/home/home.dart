import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/core/util/constants.dart';
import 'package:huzz/core/util/util.dart';
import 'package:huzz/presentation/business/create_business.dart';
import 'package:huzz/presentation/home/debtors/debtors_tab.dart';
import 'package:huzz/presentation/home/insight.dart';
import 'package:huzz/presentation/home/money_history.dart';
import 'package:huzz/presentation/home/money_in.dart';
import 'package:huzz/presentation/home/money_out.dart';
import 'package:huzz/presentation/home/records.dart';
import 'package:huzz/presentation/settings/settings.dart';
import 'package:number_display/number_display.dart';
import 'package:random_color/random_color.dart';
import 'package:huzz/core/constants/app_themes.dart';
import '../../../data/model/business.dart';
import '../../../data/model/notification_model.dart';
import '../../../data/repository/business_repository.dart';
import '../../../data/repository/debtors_repository.dart';
import '../../../data/repository/transaction_respository.dart';

class DebtInformationDialog extends StatelessWidget {
  const DebtInformationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        const SizedBox(height: 7),
        Text(
          "Total debts is the sum of the debts you owe and the debts others owe you. It gives you a sense of your potential revenue.",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final display = createDisplay(
    roundingType: RoundingType.floor,
    length: 15,
    decimal: 5,
  );

  String? value;
  final _transactionController = Get.find<TransactionRespository>();
  final _businessController = Get.find<BusinessRepository>();
  final _debtorController = Get.find<DebtorRepository>();
  // final _authController = Get.find<AuthRepository>();
  int selectedValue = 0;
  final transactionList = [];
  final RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // print(
      // 'Team Invite deeplink: ${_authController.hasTeamInviteDeeplink.value}');
      // if (!_authController.hasTeamInviteDeeplink.value) {
      // Get.reset();
      // }
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          context: context,
                          builder: (context) => buildSelectBusiness());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 3, color: AppColors.backgroundColor)),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          buildMenuItem(
                              "${_businessController.selectedBusiness.value!.businessName}"),
                          const Expanded(child: SizedBox()),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.backgroundColor,
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(Notifications());
                        },
                        child: SvgPicture.asset(
                          'assets/images/bell.svg',
                          height: 20,
                          width: 20,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02),
                      GestureDetector(
                        onTap: () {
                          Get.to(const Settings());
                        },
                        child: SvgPicture.asset(
                          'assets/images/settings.svg',
                          color: AppColors.backgroundColor,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Obx(() {
                return Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 13, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "Today's BALANCE",
                              style: GoogleFonts.inter(
                                color: AppColors.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${Utils.getCurrency()}${display(_transactionController.totalbalance.value)}",
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => const Records());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff056B5C),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "All Records",
                                        style: GoogleFonts.inter(
                                          color: AppColors.whiteColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_outlined,
                                          color: Color(0xff056B5C),
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              InkWell(
                                onTap: () {
                                  Get.to(() => const Insight());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff056B5C),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Insights",
                                        style: GoogleFonts.inter(
                                          color: AppColors.whiteColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/images/graph.svg',
                                          height: 14,
                                          width: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xff016BCC),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: SvgPicture.asset(
                                      "assets/images/money_in.svg",
                                      height: 8,
                                    )),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Today's Money IN",
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${Utils.getCurrency()}${display(_transactionController.income.value)}",
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xffDD8F48),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: SvgPicture.asset(
                                      "assets/images/money_out.svg",
                                      height: 8,
                                    )),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Today's Money Out",
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${Utils.getCurrency()}${display(_transactionController.expenses.value)}",
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/home_rectangle.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Obx(() {
              //   return Container(
              //     padding: EdgeInsets.all(12),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           "${Utils.getCurrency()}${display(_transactionController.totalbalance.value)}",
              //           style: GoogleFonts.inter(
              //             color: AppColors.whiteColor,
              //             // ,
              //             fontSize: 20,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //         InkWell(
              //           onTap: () {
              //             Get.to(() => Records());
              //           },
              //           child: Container(
              //             padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              //             decoration: BoxDecoration(
              //               color: Color(0xff056B5C),
              //               borderRadius: BorderRadius.circular(24),
              //             ),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   "All Records",
              //                   style: GoogleFonts.inter(
              //                     color: AppColors.whiteColor,
              //                     // ,
              //                     fontSize: 10,
              //                     fontWeight: FontWeight.w600,
              //                   ),
              //                 ),
              //                 SizedBox(width: 5),
              //                 Container(
              //                   padding: EdgeInsets.all(2),
              //                   decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     shape: BoxShape.circle,
              //                   ),
              //                   child: Icon(
              //                     Icons.arrow_forward_outlined,
              //                     color: Color(0xff056B5C),
              //                     size: 14,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //         SizedBox(width: 7),
              //         InkWell(
              //           onTap: () {
              //             Get.to(() => Insight());
              //           },
              //           child: Container(
              //             padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              //             decoration: BoxDecoration(
              //               color: Color(0xff056B5C),
              //               borderRadius: BorderRadius.circular(24),
              //             ),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   "Insights",
              //                   style: GoogleFonts.inter(
              //                     color: AppColors.whiteColor,
              //                     // ,
              //                     fontSize: 10,
              //                     fontWeight: FontWeight.w600,
              //                   ),
              //                 ),
              //                 SizedBox(width: 5),
              //                 Container(
              //                   padding: EdgeInsets.all(2),
              //                   decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     shape: BoxShape.circle,
              //                   ),
              //                   child: SvgPicture.asset(
              //                     'assets/images/graph.svg',
              //                     height: 14,
              //                     width: 14,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //     height: 60,
              //     decoration: BoxDecoration(
              //       color: AppColors.backgroundColor,
              //       borderRadius: BorderRadius.circular(12),
              //       image: DecorationImage(
              //         image: AssetImage("assets/images/home_rectangle.png"),
              //         fit: BoxFit.fill,
              //       ),
              //     ),
              //   );
              // }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {
                  Get.to(() => const DebtorsTab());
                },
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.02),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.08,
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.015),
                              decoration: const BoxDecoration(
                                  color: Color(0xffEF6500),
                                  shape: BoxShape.circle),
                              child:
                                  SvgPicture.asset('assets/images/debtors.svg'),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            Text(
                              'Total debts',
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () {
                                Platform.isIOS
                                    ? showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          content:
                                              const DebtInformationDialog(),
                                          actions: [
                                            CupertinoButton(
                                              child: const Text("OK"),
                                              onPressed: () => Get.back(),
                                            ),
                                          ],
                                        ),
                                      )
                                    : showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content:
                                              const DebtInformationDialog(),
                                          actions: [
                                            CupertinoButton(
                                              child: const Text("OK"),
                                              onPressed: () => Get.back(),
                                            ),
                                          ],
                                        ),
                                      );
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 4.0, top: 2.0),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  size: 18,
                                  color: Color(0xff056B5C),
                                ),
                              ),
                            )
                          ],
                        ),
                        (_debtorController.totalDebt as num).abs() == 0
                            ? Text(
                                "No debtors yet",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: const Color(0xffF58D40),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Row(
                                children: [
                                  Text(
                                    "${_debtorController.isTotalDebtNegative ? "-" : ""}${Utils.getCurrency()}${display((_debtorController.totalDebt as num).abs())}",
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        color: const Color(0xffF58D40),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: Color(0xffF58D40),
                                  ),
                                ],
                              ),
                      ],
                    )),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                "Today's transactions",
                style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.02),
                decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 2, color: Colors.grey.withOpacity(0.2))),
                child: Obx(() {
                  return RefreshIndicator(
                    onRefresh: () async {
                      return Future.delayed(const Duration(seconds: 1), () {
                        _debtorController.dispose();
                        _transactionController.dispose();
                        _transactionController.getAllPaymentItem();
                        _transactionController.allPaymentItem;
                      });
                    },
                    child: (_transactionController.transactionStatus ==
                            TransactionStatus.Loading)
                        ? const Center(child: CircularProgressIndicator())
                        : (_transactionController.allPaymentItem.isNotEmpty)
                            ? ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var item = _transactionController
                                      .allPaymentItem[index];
                                  return InkWell(
                                    onTap: () {
                                      // print(
                                      //     "item payment transaction id is ${item.businessTransactionId}");
                                      Get.to(() => MoneyHistory(
                                            item: item,
                                          ));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Image.asset(
                                            (item.transactionType ==
                                                    "EXPENDITURE")
                                                ? "assets/images/arrow_up.png"
                                                : "assets/images/arrow_down.png",
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.itemName!,
                                                style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                item.entryDateTime!
                                                    .formatDate()!,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "${Utils.getCurrency()}${display(item.totalAmount)}",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  item.isFullyPaid!
                                                      ? "Fully Paid"
                                                      : "Partially",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ]),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: _transactionController
                                    .allPaymentItem.length)
                            : Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/images/empty_transaction.svg'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Record a transaction',
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Your recent transactions will show here. Click the',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Add transaction button to record your first transaction.',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  );
                }),
              ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              context: context,
              builder: (context) => buildAddTransaction()),
          icon: const Icon(Icons.add),
          backgroundColor: AppColors.backgroundColor,
          label: Text(
            'Add transaction',
            style: GoogleFonts.inter(
                fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    });
  }

  //Transaction is available
  // ignore: non_constant_identifier_names
  Container TransactionAvailable(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      context: context,
                      builder: (context) => buildSelectBusiness());
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 3, color: AppColors.backgroundColor)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      buildMenuItem(
                          "${_businessController.selectedBusiness.value!.businessName}"),
                      const Expanded(child: SizedBox()),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.backgroundColor,
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(Notifications());
                    },
                    child: SvgPicture.asset(
                      'assets/images/bell.svg',
                      height: 20,
                      width: 20,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  GestureDetector(
                    onTap: () {
                      Get.to(const Settings());
                    },
                    child: SvgPicture.asset(
                      'assets/images/settings.svg',
                      color: AppColors.backgroundColor,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Obx(() {
            return Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "Today's BALANCE",
                          style: GoogleFonts.inter(
                            color: AppColors.blackColor,
                            // ,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${Utils.getCurrency()}${display(_transactionController.totalbalance.value)}",
                        style: GoogleFonts.inter(
                          color: AppColors.whiteColor,
                          // ,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => const Records());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xff056B5C),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "All Records",
                                    style: GoogleFonts.inter(
                                      color: AppColors.whiteColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_outlined,
                                      color: Color(0xff056B5C),
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          InkWell(
                            onTap: () {
                              Get.to(() => const Insight());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xff056B5C),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Insights",
                                    style: GoogleFonts.inter(
                                      color: AppColors.whiteColor,
                                      // ,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/images/graph.svg',
                                      height: 14,
                                      width: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xff016BCC),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: SvgPicture.asset(
                                  "assets/images/money_in.svg",
                                  height: 8,
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Today's Money IN",
                              style: GoogleFonts.inter(
                                color: AppColors.whiteColor,
                                // ,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${Utils.getCurrency()}${display(_transactionController.income.value)}",
                        style: GoogleFonts.inter(
                          color: AppColors.whiteColor,
                          // ,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xffDD8F48),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: SvgPicture.asset(
                                  "assets/images/money_out.svg",
                                  height: 8,
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Today's Money Out",
                              style: GoogleFonts.inter(
                                color: AppColors.whiteColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${Utils.getCurrency()}${display(_transactionController.expenses.value)}",
                        style: GoogleFonts.inter(
                          color: AppColors.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage("assets/images/home_rectangle.png"),
                  fit: BoxFit.fill,
                ),
              ),
            );
          }),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          // Obx(() {
          //   return Container(
          //     padding: EdgeInsets.all(12),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "${Utils.getCurrency()}${display(_transactionController.totalbalance.value)}",
          //           style: GoogleFonts.inter(
          //             color: AppColors.whiteColor,
          //             // ,
          //             fontSize: 20,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //         InkWell(
          //           onTap: () {
          //             Get.to(() => Records());
          //           },
          //           child: Container(
          //             padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          //             decoration: BoxDecoration(
          //               color: Color(0xff056B5C),
          //               borderRadius: BorderRadius.circular(24),
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   "All Records",
          //                   style: GoogleFonts.inter(
          //                     color: AppColors.whiteColor,
          //                     // ,
          //                     fontSize: 10,
          //                     fontWeight: FontWeight.w600,
          //                   ),
          //                 ),
          //                 SizedBox(width: 5),
          //                 Container(
          //                   padding: EdgeInsets.all(2),
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     shape: BoxShape.circle,
          //                   ),
          //                   child: Icon(
          //                     Icons.arrow_forward_outlined,
          //                     color: Color(0xff056B5C),
          //                     size: 14,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         SizedBox(width: 7),
          //         InkWell(
          //           onTap: () {
          //             Get.to(() => Insight());
          //           },
          //           child: Container(
          //             padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          //             decoration: BoxDecoration(
          //               color: Color(0xff056B5C),
          //               borderRadius: BorderRadius.circular(24),
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   "Insights",
          //                   style: GoogleFonts.inter(
          //                     color: AppColors.whiteColor,
          //                     // ,
          //                     fontSize: 10,
          //                     fontWeight: FontWeight.w600,
          //                   ),
          //                 ),
          //                 SizedBox(width: 5),
          //                 Container(
          //                   padding: EdgeInsets.all(2),
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     shape: BoxShape.circle,
          //                   ),
          //                   child: SvgPicture.asset(
          //                     'assets/images/graph.svg',
          //                     height: 14,
          //                     width: 14,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //     height: 60,
          //     decoration: BoxDecoration(
          //       color: AppColors.backgroundColor,
          //       borderRadius: BorderRadius.circular(12),
          //       image: DecorationImage(
          //         image: AssetImage("assets/images/home_rectangle.png"),
          //         fit: BoxFit.fill,
          //       ),
          //     ),
          //   );
          // }),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          InkWell(
            onTap: () {
              Get.to(() => const DebtorsTab());
            },
            child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.02),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.08,
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.015),
                          decoration: const BoxDecoration(
                              color: Color(0xffEF6500), shape: BoxShape.circle),
                          child: SvgPicture.asset('assets/images/debtors.svg'),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        Text(
                          'Total debts',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Platform.isIOS
                                ? showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => CupertinoAlertDialog(
                                      content: const DebtInformationDialog(),
                                      actions: [
                                        CupertinoButton(
                                          child: const Text("OK"),
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  )
                                : showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: const DebtInformationDialog(),
                                      actions: [
                                        CupertinoButton(
                                          child: const Text("OK"),
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4.0, top: 2.0),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: Color(0xff056B5C),
                            ),
                          ),
                        )
                      ],
                    ),
                    (_debtorController.totalDebt as num).abs() == 0
                        ? Text(
                            "No debtors yet",
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: const Color(0xffF58D40),
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Row(
                            children: [
                              Text(
                                "${_debtorController.isTotalDebtNegative ? "-" : ""}${Utils.getCurrency()}${display((_debtorController.totalDebt as num).abs())}",
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: const Color(0xffF58D40),
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Color(0xffF58D40),
                              ),
                            ],
                          ),
                  ],
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            "Today's transactions",
            style: GoogleFonts.inter(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.02),
            decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(width: 2, color: Colors.grey.withOpacity(0.2))),
            child: Obx(() {
              return RefreshIndicator(
                onRefresh: () async {
                  return Future.delayed(const Duration(seconds: 1), () {
                    _debtorController.dispose();
                    _transactionController.dispose();
                    _transactionController.getAllPaymentItem();
                    _transactionController.allPaymentItem;
                  });
                },
                child: (_transactionController.transactionStatus ==
                        TransactionStatus.Loading)
                    ? Obx(() {
                        return const Center(child: CircularProgressIndicator());
                      })
                    : (_transactionController.transactionStatus ==
                            TransactionStatus.Available)
                        ? ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item =
                                  _transactionController.allPaymentItem[index];
                              return InkWell(
                                onTap: () {
                                  // print(
                                  //     "item payment transaction id is ${item.businessTransactionId}");
                                  Get.to(() => MoneyHistory(
                                        item: item,
                                      ));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        (item.transactionType == "EXPENDITURE")
                                            ? "assets/images/arrow_up.png"
                                            : "assets/images/arrow_down.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.itemName!,
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            item.entryDateTime!.formatDate()!,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${Utils.getCurrency()}${display(item.totalAmount)}",
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              item.isFullyPaid!
                                                  ? "Fully Paid"
                                                  : "Partially",
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ]),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount:
                                _transactionController.allPaymentItem.length)
                        : (_transactionController.transactionStatus ==
                                TransactionStatus.Empty)
                            ? const Text('Not Item')
                            : const Text('Empty'),
              );
            }),
          ))
        ],
      ),
    );
  }

  //Transaction is not avaliable
  // ignore: non_constant_identifier_names
  Container TransactionNotAvailable(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      context: context,
                      builder: (context) => buildSelectBusiness());
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 3, color: AppColors.backgroundColor)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      buildMenuItem(_businessController
                                  .selectedBusiness.value ==
                              null
                          ? "No Business"
                          : "${_businessController.selectedBusiness.value!.businessName}"),
                      const Expanded(child: SizedBox()),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.backgroundColor,
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(Notifications());
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/images/bell.svg',
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(const Settings());
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    'assets/images/settings.svg',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Today's BALANCE",
                        style: GoogleFonts.inter(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${Utils.getCurrency()}0.0',
                      style: GoogleFonts.inter(
                        color: AppColors.whiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => const Records());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xff056B5C),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "All Records",
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_outlined,
                                    color: Color(0xff056B5C),
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        InkWell(
                          onTap: () {
                            Get.to(() => const Insight());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xff056B5C),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Insights",
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/graph.svg',
                                    height: 14,
                                    width: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xff016BCC),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: SvgPicture.asset(
                                "assets/images/money_in.svg",
                                height: 8,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Today's Money IN",
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${Utils.getCurrency()}0.0",
                      style: GoogleFonts.inter(
                        color: AppColors.whiteColor,
                        // ,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xffDD8F48),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: SvgPicture.asset(
                                "assets/images/money_out.svg",
                                height: 8,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Today's Money Out",
                            style: GoogleFonts.inter(
                              color: AppColors.whiteColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${Utils.getCurrency()}0.0",
                      style: GoogleFonts.inter(
                        color: AppColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            height: 130,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage("assets/images/home_rectangle.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          // InkWell(
          // onTap: () {
          // Get.to(Wallet());
          // },
          // child: Container(
          // padding: EdgeInsets.symmetric(
          // horizontal: MediaQuery.of(context).size.height * 0.02),
          // decoration: BoxDecoration(
          // color: AppColors.backgroundColor,
          // borderRadius: BorderRadius.circular(10),
          // image: DecorationImage(
          // image: AssetImage("assets/images/home_rectangle.png"),
          // fit: BoxFit.cover,
          // ),
          // ),
          // child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // children: [
          // Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // children: [
          // Row(
          // children: [
          // Text(
          // 'WEMA BANK #23456789',
          // style: GoogleFonts.inter(
          // fontSize: 12,
          // color: Colors.white,
          // fontWeight: FontWeight.w600),
          // ),
          // GestureDetector(
          // onTap: () {
          // Platform.isIOS
          // ? showCupertinoDialog(
          // context: context,
          // barrierDismissible: true,
          // builder: (context) =>
          // CupertinoAlertDialog(
          // content: DebtInformationDialog(),
          // actions: [
          // CupertinoButton(
          // child: Text("OK"),
          // onPressed: () => Get.back(),
          // ),
          // ],
          // ),
          // )
          // : showDialog(
          // context: context,
          // builder: (context) => AlertDialog(
          // content: DebtInformationDialog(),
          // actions: [
          // CupertinoButton(
          // child: Text("OK"),
          // onPressed: () => Get.back(),
          // ),
          // ],
          // ),
          // );
          // },
          // child: Padding(
          // padding:
          // const EdgeInsets.only(left: 4.0, top: 2.0),
          // child: Icon(
          // Icons.info_outline_rounded,
          // size: 12,
          // color: Colors.white,
          // ),
          // ),
          // )
          // ],
          // ),
          // SizedBox(height: 5),
          // Text(
          // '${Utils.getCurrency()}0.0',
          // style: GoogleFonts.inter(
          // color: AppColors.whiteColor,
          // // ,
          // fontSize: 24,
          // fontWeight: FontWeight.w600,
          // ),
          // ),
          // ],
          // ),
          // Container(
          // height: MediaQuery.of(context).size.height * 0.08,
          // width: MediaQuery.of(context).size.width * 0.08,
          // padding: EdgeInsets.all(
          // MediaQuery.of(context).size.width * 0.015),
          // decoration: BoxDecoration(
          // color: Color(0xff056B5C), shape: BoxShape.circle),
          // child: Icon(Icons.arrow_forward, color: Colors.white),
          // ),
          // ],
          // )),
          // ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          InkWell(
            onTap: () {
              Get.to(const DebtorsTab());
            },
            child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.02),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.08,
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.015),
                          decoration: const BoxDecoration(
                              color: Color(0xffEF6500), shape: BoxShape.circle),
                          child: SvgPicture.asset('assets/images/debtors.svg'),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        Text(
                          'Debtors',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Platform.isIOS
                                ? showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => CupertinoAlertDialog(
                                      content: const DebtInformationDialog(),
                                      actions: [
                                        CupertinoButton(
                                          child: const Text("OK"),
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  )
                                : showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: const DebtInformationDialog(),
                                      actions: [
                                        CupertinoButton(
                                          child: const Text("OK"),
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4.0, top: 2.0),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: Color(0xff056B5C),
                            ),
                          ),
                        )
                      ],
                    ),
                    (_debtorController.totalDebt as num).abs() == 0
                        ? Text(
                            "No debtors yet",
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: const Color(0xffF58D40),
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Row(
                            children: [
                              Text(
                                "${_debtorController.isTotalDebtNegative ? "-" : ""}${Utils.getCurrency()}${display((_debtorController.totalDebt as num).abs())}",
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: const Color(0xffF58D40),
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Color(0xffF58D40),
                              ),
                            ],
                          ),
                  ],
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            "Today's transactions",
            style: GoogleFonts.inter(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.02,
                  right: MediaQuery.of(context).size.height * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 2, color: Colors.grey.withOpacity(0.2))),
              child: Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.02,
                    right: MediaQuery.of(context).size.height * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.02),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/empty_transaction.svg'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Record a transaction',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Your recent transactions will show here. Click the',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Add transaction button to record your first transaction.',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddTransaction() => Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04,
            top: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 80,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      Get.to(() => const MoneyOut());
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: const Color(0xffEF6500),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/images/moneyRound_out.svg'),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Text(
                                'Money OUT',
                                style: GoogleFonts.inter(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Text(
                            'Click here to record an expense',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      Get.to(() => const MoneyIn());
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: const Color(0xff0065D3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/images/moneyRound_in.svg'),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Text(
                                'Money IN',
                                style: GoogleFonts.inter(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Text(
                            'Click here to record an income',
                            style: GoogleFonts.inter(
                                fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );

  Widget buildSelectBusiness() => Obx(() {
        return Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height:
                      (_businessController.offlineBusiness.length * 50) + 20,
                  width: MediaQuery.of(context).size.width,
                  child: Obx(() {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        var item = _businessController.offlineBusiness[index];
                        return GestureDetector(
                          onTap: () {
                            _debtorController.dispose();
                            _transactionController.dispose();

                            _businessController.selectedBusiness(item.business);

                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _randomColor.randomColor()),
                                      child: Center(
                                          child: Text(
                                        (item.business == null ||
                                                item.business!.businessName!
                                                    .isEmpty)
                                            ? ''
                                            : item.business!.businessName![0],
                                        style: GoogleFonts.inter(
                                            fontSize: 20,
                                            color: Colors.white,
                                            // ,
                                            fontWeight: FontWeight.w600),
                                      ))),
                                ),
                              )),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    item.business!.businessName!,
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Colors.black,
                                        // ,
                                        fontWeight: FontWeight.w600),
                                  )),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: Radio<Business>(
                                    value: item.business!,
                                    activeColor: AppColors.backgroundColor,
                                    groupValue: _businessController
                                        .selectedBusiness.value,
                                    onChanged: (value) {
                                      _businessController
                                          .selectedBusiness(value);
                                      _businessController
                                          .setLastBusiness(value!);
                                      Navigator.pop(context);
                                    }),
                              )),
                            ],
                          ),
                        );
                      },
                      itemCount: _businessController.offlineBusiness.length,
                    );
                  }),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Get.to(() => AddNewSale());
                    Get.to(const CreateBusiness());
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03,
                        vertical: 20),
                    height: 50,
                    decoration: const BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        'Create New Business',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.inter(fontSize: 14),
        ),
      );
}
