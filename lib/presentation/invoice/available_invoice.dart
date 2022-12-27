import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/invoice_repository.dart';
import 'package:huzz/presentation/invoice/available_invoice/all.dart';
import 'package:huzz/presentation/invoice/available_invoice/overdue.dart';
import 'package:huzz/presentation/invoice/available_invoice/paid.dart';
import 'package:huzz/presentation/invoice/available_invoice/pending.dart';
import 'package:huzz/core/constants/app_themes.dart';
import '../../data/repository/auth_respository.dart';
import '../../data/repository/team_repository.dart';

class ManageInvoiceInformationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 27,
        ),
        SizedBox(height: 7),
        Text(
          'This is where you can create new invoices for your customers or update payments for existing invoices.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class AvailableInvoice extends StatefulWidget {
  const AvailableInvoice({Key? key}) : super(key: key);

  @override
  _AvailableInvoiceState createState() => _AvailableInvoiceState();
}

class _AvailableInvoiceState extends State<AvailableInvoice>
    with SingleTickerProviderStateMixin {
  ScrollController? _scrollController;
  TabController? _tabController;

  final _authController = Get.put(AuthRepository());
  final _invoiceRepository = Get.find<InvoiceRespository>();
  final teamController = Get.find<TeamRepository>();

  bool? fixedScroll;

  @override
  void initState() {
    _authController.checkTeamInvite();

    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    _tabController = TabController(length: 4, vsync: this);
    _tabController!.addListener(_smoothScrollToTop);
    fixedScroll = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
  }

  @override
  void dispose() {
    _tabController!.dispose();
    _scrollController!.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (fixedScroll!) {
      _scrollController!.jumpTo(0);
    }
  }

  _smoothScrollToTop() {
    _scrollController!.animateTo(
      0,
      duration: Duration(microseconds: 300),
      curve: Curves.ease,
    );
    setState(() {
      fixedScroll = _tabController!.index == 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(210),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Manage Invoices",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColors.backgroundColor),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Platform.isIOS
                                ? showCupertinoDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => CupertinoAlertDialog(
                                      content: ManageInvoiceInformationDialog(),
                                      actions: [
                                        CupertinoButton(
                                          child: Text("OK"),
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  )
                                : showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: ManageInvoiceInformationDialog(),
                                      actions: [
                                        CupertinoButton(
                                          child: Text("OK"),
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                            child: SvgPicture.asset(
                              "assets/images/info.svg",
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Row(
                      children: [
                        DashboardDetails(
                            name: 'Pending',
                            no: _invoiceRepository.InvoicePendingList.length),
                        SizedBox(
                            width: MediaQuery.of(context).size.height * 0.02),
                        DashboardDetails(
                            name: 'Overdue',
                            no: _invoiceRepository.InvoiceDueList.length),
                        SizedBox(
                            width: MediaQuery.of(context).size.height * 0.02),
                        DashboardDetails(
                            name: 'Deposit',
                            no: _invoiceRepository.InvoiceDepositList.length),
                        SizedBox(
                            width: MediaQuery.of(context).size.height * 0.02),
                        DashboardDetails(
                            name: 'Paid',
                            no: _invoiceRepository.paidInvoiceList.length)
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Text(
                      "Invoices",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: AppColors.backgroundColor),
                    ),
                  ],
                ),
              ),
            ),
            body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: TabBar(
                      controller: _tabController,
                      labelColor: AppColors.backgroundColor,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: GoogleFonts.inter(
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: GoogleFonts.inter(
                        color: AppColors.backgroundColor,
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: AppColors.backgroundColor,
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Pending'),
                        Tab(text: 'Paid'),
                        Tab(text: 'Overdue'),
                      ],
                    ),
                  )
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[All(), Pending(), Paid(), Overdue()],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class DashboardDetails extends StatelessWidget {
  final String? name;
  final int? no;

  const DashboardDetails({Key? key, this.name, this.no}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.backgroundColor.withOpacity(0.3)),
        child: Column(
          children: [
            Text(
              name!,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black),
            ),
            Text(
              no!.toString(),
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.backgroundColor),
            )
          ],
        ),
      ),
    );
  }
}
