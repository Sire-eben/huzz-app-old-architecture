import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/customer_repository.dart';
import 'package:huzz/data/repository/debtors_repository.dart';
import 'package:huzz/presentation/home/debtors/debt_updated_success.dart';
import 'package:huzz/data/repository/transaction_respository.dart';
import 'package:huzz/presentation/widget/custom_form_field.dart';
import 'package:huzz/data/model/customer_model.dart';
import 'package:huzz/data/model/debtor.dart';
import 'package:number_display/number_display.dart';
import 'package:random_color/random_color.dart';
import '../../../data/repository/team_repository.dart';
import 'package:huzz/core/constants/app_themes.dart';

import 'package:huzz/core/util/util.dart';
import '../money_history.dart';

// ignore: must_be_immutable
class DebtOwned extends StatefulWidget {
  Debtor? item;
  DebtOwned({Key? key, this.item}) : super(key: key);

  @override
  _DebtOwnedState createState() => _DebtOwnedState();
}

class _DebtOwnedState extends State<DebtOwned> {
  final _debtorRepository = Get.find<DebtorRepository>();
  final _customerRepository = Get.find<CustomerRepository>();
  final teamController = Get.find<TeamRepository>();

  final RandomColor _randomColor = RandomColor();
  final itemNameController = TextEditingController();
  final amountController = TextEditingController();
  final quantityController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final paymentController = TextEditingController();
  final paymentSourceController = TextEditingController();
  final receiptFileController = TextEditingController();
  final amountPaidController = TextEditingController();
  final _customerKey = GlobalKey<FormState>();

  final debtStatus = ['Pending', 'Fully Paid'];

  int statusType = 0;
  String? value = "Pending";

  final display = createDisplay(
    roundingType: RoundingType.floor,
    length: 15,
    decimal: 5,
  );
  final _key = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (true)
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_debtorRepository.debtorStatus ==
                          DebtorStatus.UnAuthorized) ...[
                        Container(),
                      ] else ...[
                        Container(
                          height: 95,
                          decoration: const BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Number Of Debts Owed",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Center(
                                      child: Text(
                                        "${_debtorRepository.debtOwnedList.length}",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 95,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondBgColor,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: const [
                                        0.1,
                                        0.6,
                                        0.8,
                                      ],
                                      colors: [
                                        const Color(0xff0D8372),
                                        const Color(0xff07A58E),
                                        AppColors.backgroundColor
                                            .withOpacity(0.5),
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total Debts Owed",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "${Utils.getCurrency()}${display(_debtorRepository.debtOwnedAmount)}",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  width: 2, color: AppColors.backgroundColor)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: value,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 14,
                                color: AppColors.backgroundColor,
                              ),
                              hint: Text(
                                'Pending',
                                style: GoogleFonts.inter(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                              isDense: true,
                              items: debtStatus.map(buildDropDown).toList(),
                              onChanged: (value) =>
                                  setState(() => this.value = value),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Expanded(
                        child: ((value == "Pending")
                                ? (_debtorRepository.debtOwnedList.isEmpty)
                                : (_debtorRepository
                                    .fullyPaidDebtOwned.isEmpty))
                            ? Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/add_debt_owned.svg',
                                        height: 50,
                                        width: 50,
                                        color: AppColors.backgroundColor,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Add Debt Owed',
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        _debtorRepository.debtorStatus !=
                                                DebtorStatus.UnAuthorized
                                            ? 'Your debts will show here. Click the'
                                            : 'Your debts will show here.',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                      if (_debtorRepository.debtorStatus !=
                                          DebtorStatus.UnAuthorized) ...[
                                        Text(
                                          'Add New Debt Owed button to add your first debt',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 20),
                                      if (_debtorRepository.debtorStatus ==
                                          DebtorStatus.UnAuthorized) ...[
                                        Text(
                                          'You need to be authorized\nto view this module',
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color:
                                                  AppColors.orangeBorderColor,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: ((value == "Pending")
                                    ? (_debtorRepository.debtOwnedList.length)
                                    : (_debtorRepository
                                        .fullyPaidDebtOwned.length)),
                                itemBuilder: (context, index) {
                                  var item = ((value == "Pending")
                                      ? (_debtorRepository.debtOwnedList)
                                      : (_debtorRepository
                                          .fullyPaidDebtOwned))[index];
                                  var customer = _customerRepository
                                      .checkIfCustomerAvailableWithValue(
                                          item.customerId!);

                                  return (customer == null)
                                      ? Container()
                                      : Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: _randomColor
                                                            .randomColor()),
                                                    child: Center(
                                                        child: Text(
                                                      // ignore: unnecessary_null_comparison
                                                      customer != null &&
                                                              customer.name !=
                                                                  null &&
                                                              customer.name!
                                                                  .isNotEmpty
                                                          ? customer.name![0]
                                                          : "",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 30,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ))),
                                              ),
                                            )),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    customer.name!,
                                                    style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    customer.phone!,
                                                    style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Balance: ${Utils.getCurrency()}${display(item.balance!)}",
                                                    style: GoogleFonts.inter(
                                                        fontSize: 13,
                                                        color: AppColors
                                                            .orangeBorderColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    "Paid: ${Utils.getCurrency()}${display((item.totalAmount! - item.balance!))}",
                                                    style: GoogleFonts.inter(
                                                        fontSize: 11,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: (teamController.teamMember
                                                              .teamMemberStatus ==
                                                          'CREATOR' ||
                                                      teamController.teamMember
                                                          .authoritySet!
                                                          .contains(
                                                              'UPDATE_DEBTOR'))
                                                  ? InkWell(
                                                      onTap: () {
                                                        // print(index);
                                                        // item.businessTransactionId="6229ab581982280f4fd07cf5";
                                                        // print(
                                                        //     "business transaction id  is ${item.businessTransactionId}");
                                                        if (item.businessTransactionId !=
                                                                null &&
                                                            item.businessTransactionId!
                                                                .isNotEmpty) {
                                                          final _transactionController =
                                                              Get.find<
                                                                  TransactionRespository>();
                                                          final tItem =
                                                              _transactionController
                                                                  .getTransactionById(
                                                                      item.businessTransactionId!);
                                                          if (tItem != null) {
                                                            //  Get.snackbar("Error","Going to transaction page");
                                                            Get.to(() =>
                                                                MoneyHistory(
                                                                  item: tItem
                                                                      .businessTransactionPaymentItemList![0],
                                                                  pageCheck:
                                                                      false,
                                                                ));
                                                          } else {
                                                            Get.snackbar(
                                                                "Error",
                                                                "Transaction is not found");
                                                          }
                                                        } else {
                                                          showModalBottomSheet(
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              20))),
                                                              context: context,
                                                              isScrollControlled:
                                                                  true,
                                                              builder: (context) =>
                                                                  buildUpdatePayments(
                                                                      item));
                                                        }
                                                      },
                                                      child: SvgPicture.asset(
                                                          'assets/images/edit_pri.svg'))
                                                  : Container(),
                                            ),
                                            const SizedBox(width: 4),
                                            (teamController.teamMember
                                                            .teamMemberStatus ==
                                                        'CREATOR' ||
                                                    teamController.teamMember
                                                        .authoritySet!
                                                        .contains(
                                                            'DELETE_DEBTOR'))
                                                ? Obx(() => GestureDetector(
                                                      onTap: () {
                                                        _deleteDebtDialog(
                                                            context, item);
                                                      },
                                                      child: _debtorRepository
                                                                  .deletingItem
                                                                  .value ==
                                                              item
                                                          ? const CupertinoActivityIndicator(
                                                              radius: 10,
                                                            )
                                                          : SvgPicture.asset(
                                                              "assets/images/delete.svg",
                                                              height: 20,
                                                              width: 20,
                                                            ),
                                                    ))
                                                : Container(),
                                          ],
                                        );
                                }),
                      ),
                      const SizedBox(height: 20),
                      if (_debtorRepository.debtorStatus ==
                          DebtorStatus.UnAuthorized) ...[
                        Container(),
                      ] else ...[
                        (teamController.teamMember.teamMemberStatus ==
                                    'CREATOR' ||
                                teamController.teamMember.authoritySet!
                                    .contains('CREATE_DEBTOR'))
                            ? InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      context: context,
                                      builder: (context) => buildAddDebtor());
                                },
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: AppColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add,
                                        size: 22,
                                        color: AppColors.whiteColor,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Add New Debt Owed',
                                          style: GoogleFonts.inter(
                                            color: AppColors.whiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            )
          // ignore: dead_code
          : DebtorOwnedListing();
    });
  }

  _deleteDebtDialog(BuildContext context, Debtor debtor) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            title: Text(
              'Delete Debt',
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            content: Text(
              "You're about to delete this debt entry, click delete to proceed",
              style: GoogleFonts.inter(
                color: AppColors.blackColor,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
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
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(
                                width: 1.2,
                                color: AppColors.backgroundColor,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                color: AppColors.backgroundColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Get.back();
                          await _debtorRepository.deleteBusinessDebtor(debtor);
                        },
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.orangeBorderColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  StatefulBuilder buildUpdatePayments(Debtor debtor) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Center(
                    child: Container(
                      height: 6,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Update Payment',
                  style: GoogleFonts.inter(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          myState(() {
                            statusType = 1;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<int>(
                              value: 1,
                              activeColor: AppColors.backgroundColor,
                              groupValue: statusType,
                              onChanged: (value) {
                                myState(() {
                                  statusType = 1;
                                });
                              },
                            ),
                            Text(
                              'Paying Fully',
                              style: GoogleFonts.inter(
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          myState(() {
                            statusType = 0;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<int>(
                                value: 0,
                                activeColor: AppColors.backgroundColor,
                                groupValue: statusType,
                                onChanged: (value) {
                                  myState(() {
                                    value = 0;
                                    statusType = 0;
                                  });
                                }),
                            Text(
                              'Paying Partly',
                              style: GoogleFonts.inter(
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    statusType == 0
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Amount',
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "*",
                                      style: GoogleFonts.inter(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Balance: ${Utils.getCurrency()}${display(debtor.balance)}',
                                    style: GoogleFonts.inter(
                                      color: AppColors.orangeBorderColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    // debtOwnedModel.balance!,
                                    '',
                                    style: GoogleFonts.inter(
                                      color: AppColors.orangeBorderColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(
                      height: 5,
                    ),
                    (statusType == 0)
                        ? TextFormField(
                            controller: textEditingController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Amount is needed";
                              } else if (int.parse(value) > debtor.balance) {
                                return "Amount must be between the range of balance";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              isDense: true,

                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.backgroundColor,
                                      width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.backgroundColor,
                                      width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.backgroundColor,
                                      width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              // labelText: label,
                              hintText: '${Utils.getCurrency()} 0.00',

                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    color: Colors.black26,
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          )
                        : Container()
                  ],
                ),
                (statusType == 0)
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05)
                    : Container(),
                InkWell(
                  onTap: () async {
                    if (_debtorRepository.addingDebtorStatus !=
                        AddingDebtorStatus.Loading) {
                      if (_key.currentState!.validate()) {
                        await _debtorRepository.UpdateBusinessDebtor(
                            debtor,
                            statusType == 1
                                ? debtor.balance
                                : int.parse(textEditingController.text));
                        Get.to(const DebtUpdatedSuccess());
                      }
                    }
                  },
                  child: Obx(() {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: (_debtorRepository.addingDebtorStatus ==
                                AddingDebtorStatus.Loading)
                            ? const SizedBox(
                                width: 30,
                                height: 30,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white)),
                              )
                            : Text(
                                'Save',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        );
      });
  StatefulBuilder buildAddDebtor() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  height: 3,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Add Debt Owed',
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: newCustomersInfo(),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() {
                return InkWell(
                  onTap: () async {
                    if (_debtorRepository.customerType == 0) {
                      if (_debtorRepository.selectedCustomer == null) {
                        Get.snackbar("Error", "Kindly select a merchant");
                        return;
                      }

                      if (_debtorRepository.addingDebtorStatus !=
                          AddingDebtorStatus.Loading) {
                        if (_customerKey.currentState!.validate()) {
                          await _debtorRepository
                              .addBudinessDebtor("EXPENDITURE");
                          // setState(() {});
                          Get.back();
                        }
                      }
                    } else {
                      if (_customerKey.currentState!.validate()) {
                        if (_debtorRepository.addingDebtorStatus !=
                            AddingDebtorStatus.Loading) {
                          await _debtorRepository
                              .addBudinessDebtor("EXPENDITURE");
                          // setState(() {});
                          Get.back();
                        }
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.03),
                    height: 50,
                    decoration: const BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: (_debtorRepository.addingDebtorStatus ==
                            AddingDebtorStatus.Loading)
                        ? const SizedBox(
                            width: 30,
                            height: 30,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add,
                                size: 22,
                                color: AppColors.whiteColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Center(
                                child: Text(
                                  'Add Debt Owed',
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      });
  StatefulBuilder newCustomersInfo() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Form(
          key: _customerKey,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.00),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.01),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () =>
                              myState(() => _debtorRepository.customerType = 1),
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 1,
                                  activeColor: AppColors.backgroundColor,
                                  groupValue: _debtorRepository.customerType,
                                  onChanged: (value) => myState(() =>
                                      _debtorRepository.customerType = 1)),
                              Text(
                                'New Merchant',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              myState(() => _debtorRepository.customerType = 0),
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 0,
                                  activeColor: AppColors.backgroundColor,
                                  groupValue: _debtorRepository.customerType,
                                  onChanged: (value) => myState(() =>
                                      _debtorRepository.customerType = 0)),
                              Text(
                                'Existing Merchants',
                                style: GoogleFonts.inter(
                                  color: AppColors.backgroundColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    _debtorRepository.customerType == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  _customerRepository
                                      .showContactPicker(context);
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/select_from_contact.svg',
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Select from Contact",
                                      style: GoogleFonts.inter(
                                          color: AppColors.backgroundColor,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomTextFieldInvoiceOptional(
                                label: 'Name',
                                keyType: TextInputType.name,
                                textEditingController:
                                    _customerRepository.nameController,
                                validatorText: "Name is required",
                              ),
                              CustomTextFieldInvoiceOptional(
                                label: 'Phone Number',
                                keyType: TextInputType.name,
                                textEditingController:
                                    _customerRepository.phoneNumberController,
                                validatorText: "Phone number is required",
                              ),
                              CustomTextFieldInvoiceOptional(
                                label: 'Amount you owe',
                                inputformater: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyType: Platform.isIOS
                                    ? const TextInputType.numberWithOptions(
                                        signed: true, decimal: true)
                                    : TextInputType.number,
                                textEditingController:
                                    _debtorRepository.totalAmountController,
                                validatorText: "Amount you owe is required",
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Select Merchant',
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "*",
                                    style: GoogleFonts.inter(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 2,
                                        color: AppColors.backgroundColor)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Customer>(
                                    value: _debtorRepository.selectedCustomer,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.backgroundColor,
                                    ),
                                    iconSize: 30,
                                    items: _customerRepository.customerMerchant
                                        .map((value) {
                                      return DropdownMenuItem<Customer>(
                                        value: value,
                                        child: Text(value.name!),
                                      );
                                    }).toList(),
                                    onChanged: (value) => myState(
                                      () => _debtorRepository.selectedCustomer =
                                          value,
                                    ),
                                  ),
                                ),
                              ),
                              // CustomTextFieldInvoiceOptional(
                              //   label: 'Balance',
                              //   inputformater: [FilteringTextInputFormatter.digitsOnly],
                              // keyType: Platform.isIOS?TextInputType.numberWithOptions(signed: true, decimal: true): TextInputType.number,
                              //   textEditingController:
                              //       _customerRepository.amountController,
                              // ),
                              CustomTextFieldInvoiceOptional(
                                label: 'Amount you owe',
                                inputformater: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyType: Platform.isIOS
                                    ? const TextInputType.numberWithOptions(
                                        signed: true, decimal: true)
                                    : TextInputType.number,
                                validatorText: "Amount you owe is required",
                                textEditingController:
                                    _debtorRepository.totalAmountController,
                              ),
                            ],
                          ),
                  ],
                ),
              )
            ],
          ),
        );
      });

  DropdownMenuItem<String> buildExistingCustomer(String item) =>
      DropdownMenuItem(
        value: item,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color(0xffCFD1D2),
            ),
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffDCF2EF),
          ),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blueColor,
                ),
                child: Center(
                  child: Text('F',
                      style: GoogleFonts.inter(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      )),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Center(
                child: Text(
                  item,
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Center(
                child: Text(
                  '09038726495',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildAddItem() =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        return Container(
          // padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 6,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              const CustomTextField(
                label: "Enter Name *",
                validatorText: "merchant name is needed",
                hint: 'E.g.  Debtors Name',
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Amount",
                      validatorText: "amount is needed",
                      hint: '₦0',
                      inputformater: [FilteringTextInputFormatter.digitsOnly],
                      keyType: Platform.isIOS
                          ? const TextInputType.numberWithOptions(
                              signed: true, decimal: true)
                          : TextInputType.number,
                    ),
                  ),
                  const Expanded(
                    child: CustomTextField(
                      label: "Select Product",
                      validatorText: "Select Product ",
                      hint: '0',
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.03),
                  height: 50,
                  decoration: const BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Add Debtors',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      });

  DropdownMenuItem<String> buildDropDown(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      );
}

// ignore: must_be_immutable
class DebtorOwnedListing extends StatefulWidget {
  Debtor? item;
  DebtorOwnedListing({Key? key, this.item}) : super(key: key);

  @override
  _DebtorOwnedListingState createState() => _DebtorOwnedListingState();
}

class _DebtorOwnedListingState extends State<DebtorOwnedListing> {
  int statusType = 0;
  final _debtorController = Get.find<DebtorRepository>();

  final _key = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'name',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                'phone',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Balance: ${widget.item!.balance!}",
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "Paid: ${(widget.item!.totalAmount! - widget.item!.balance!)}",
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    context: context,
                    builder: (context) => buildUpdatePayments(widget.item!));
              },
              child: SvgPicture.asset('assets/images/edit_pri.svg')),
        ),
      ],
    );
  }

  StatefulBuilder buildUpdatePayments(Debtor debtor) =>
      StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
        ScrollController? controller;
        return Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            controller: controller,
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Center(
                      child: Container(
                        height: 6,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Update Payment',
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            myState(() {
                              statusType = 1;
                            });
                          },
                          child: Row(
                            children: [
                              Radio<int>(
                                value: 1,
                                activeColor: AppColors.backgroundColor,
                                groupValue: statusType,
                                onChanged: (value) {
                                  myState(() {
                                    statusType = 1;
                                  });
                                },
                              ),
                              Text(
                                'Paying Fully',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            myState(() {
                              statusType = 0;
                            });
                          },
                          child: Row(
                            children: [
                              Radio<int>(
                                  value: 0,
                                  activeColor: AppColors.backgroundColor,
                                  groupValue: statusType,
                                  onChanged: (value) {
                                    myState(() {
                                      value = 0;
                                      statusType = 0;
                                    });
                                  }),
                              Text(
                                'Paying Partly',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      statusType == 0
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "*",
                                        style: GoogleFonts.inter(
                                            color: Colors.red, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Balance: ' + debtor.balance.toString(),
                                      style: GoogleFonts.inter(
                                        color: AppColors.orangeBorderColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      // debtOwnedModel.balance!,
                                      '',
                                      style: GoogleFonts.inter(
                                        color: AppColors.orangeBorderColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      (statusType == 0)
                          ? TextFormField(
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Amount is needed";
                                } else if (int.parse(value) > debtor.balance) {
                                  return "Amount must be between the range of balance";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                isDense: true,

                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.backgroundColor,
                                        width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.backgroundColor,
                                        width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.backgroundColor,
                                        width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                // labelText: label,
                                hintText: '${Utils.getCurrency()} 0.00',

                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: Colors.black26,
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  (statusType == 0)
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05)
                      : Container(),
                  InkWell(
                    onTap: () async {
                      if (_debtorController.addingDebtorStatus !=
                          AddingDebtorStatus.Loading) {
                        if (_key.currentState!.validate()) {
                          await _debtorController.UpdateBusinessDebtor(
                              debtor,
                              statusType == 1
                                  ? 0
                                  : int.parse(textEditingController.text));
                          Get.to(const DebtUpdatedSuccess());
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: (_debtorController.addingDebtorStatus ==
                                AddingDebtorStatus.Loading)
                            ? const SizedBox(
                                width: 30,
                                height: 30,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white)),
                              )
                            : Text(
                                'Save',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
