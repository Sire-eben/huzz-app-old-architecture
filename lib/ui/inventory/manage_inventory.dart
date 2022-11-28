import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/ui/inventory/Service/services.dart';
import '../../data/repository/auth_respository.dart';
import '../../data/repository/business_respository.dart';
import '../../util/colors.dart';
import 'Product/products.dart';

class ManageInventoryInformationDialog extends StatelessWidget {
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
          'To make recording your sales easier, you can add all your products/services here.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class ManageInventory extends StatefulWidget {
  const ManageInventory({Key? key}) : super(key: key);

  @override
  _ManageInventoryState createState() => _ManageInventoryState();
}

class _ManageInventoryState extends State<ManageInventory> {
  final _authController = Get.put(AuthRepository());
  final _businessController = Get.find<BusinessRespository>();
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(
          'Team Invite deeplink: ${_authController.hasTeamInviteDeeplink.value}');
    }
    if (_authController.hasTeamInviteDeeplink.value == true) {
      _businessController.OnlineBusiness();
      _authController.hasTeamInviteDeeplink(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Text(
                'Manage Inventory',
                style: GoogleFonts.inter(
                  color: AppColor().backgroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Platform.isIOS
                      ? showCupertinoDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => CupertinoAlertDialog(
                            content: ManageInventoryInformationDialog(),
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
                            content: ManageInventoryInformationDialog(),
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: AppColor().backgroundColor,
                  ),
                  color: AppColor().whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  labelColor: AppColor().whiteColor,
                  unselectedLabelColor: AppColor().backgroundColor,
                  labelStyle: GoogleFonts.inter(
                    color: AppColor().backgroundColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.inter(
                    color: AppColor().backgroundColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  indicator: BoxDecoration(
                    color: AppColor().backgroundColor,
                    border: Border.all(
                      width: 3,
                      color: AppColor().backgroundColor,
                    ),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                  tabs: [
                    Tab(
                      text: 'Products',
                    ),
                    Tab(
                      text: 'Services',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Products(),
            Services(),
          ],
        ),
      ),
    );
  }
}
