import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/core/widgets/image.dart';
import 'package:huzz/data/repository/invoice_repository.dart';
import 'package:huzz/data/repository/team_repository.dart';
import 'package:huzz/generated/assets.gen.dart';
import 'package:huzz/ui/customers/customer_tabView.dart';
import 'package:huzz/ui/invoice/empty_invoice.dart';
import 'package:huzz/ui/more/more.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:new_version/new_version.dart';
import 'home/home_page.dart';
import 'inventory/manage_inventory.dart';
import 'invoice/available_invoice.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  int? selectedIndex;
  Dashboard({
    Key? key,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;
  // _DashboardState({required this.selectedIndex});
  final _invoiceRepository = Get.find<InvoiceRespository>();
  final teamController = Get.find<TeamRepository>();

  @override
  void initState() {
    super.initState();
    final newVersion = NewVersion(
      iOSId: 'com.app.huzz',
      androidId: 'com.app.huzz',
    );

    const simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
      // ignore: dead_code
    } else {
      advancedStatusCheck(newVersion);
    }
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Custom Title',
        dialogText: 'Custom Text',
      );
    }
  }

  final inactiveColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    final _items = <_Item>[
      _Item(
        title: 'Home',
        inactiveIcon: Assets.icons.linear.home,
        icon: Assets.icons.bulk.home,
      ),
      _Item(
        title: 'Customers',
        inactiveIcon: Assets.icons.linear.people,
        icon: Assets.icons.bulk.people,
      ),
      _Item(
        title: 'Inventory',
        inactiveIcon: Assets.icons.linear.shop,
        icon: Assets.icons.bulk.shop,
      ),
      _Item(
        title: 'Invoice',
        inactiveIcon: Assets.icons.linear.note1,
        icon: Assets.icons.bulk.note1,
      ),
      _Item(
        title: 'More',
        inactiveIcon: Assets.icons.linear.moreCircle,
        icon: Assets.icons.bulk.moreCircle,
      ),
    ];

    return Scaffold(
      body: buildPages(),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        // showSelectedLabels: true,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black54,
        items: _items
            .map(
              (item) => BottomNavigationBarItem(
                label: item.title,
                tooltip: item.title,
                activeIcon: LocalSvgIcon(
                  item.icon,
                  size: 20,
                  color: AppColors.primaryColor,
                ),
                icon: LocalSvgIcon(
                  item.inactiveIcon,
                  size: 20,
                  color: AppColors.primaryColor.withOpacity(0.7),
                ),
              ),
            )
            .toList(),
        onTap: (index) => setState(() => selectedIndex = index),
      ),
    );
  }

  Widget buildPages() {
    switch (selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return CustomerTabView();
      case 2:
        return const ManageInventory();
      case 3:
        return _invoiceRepository.invoiceStatus == InvoiceStatus.UnAuthorized
            ? const InvoiceNotAuthorized()
            : (_invoiceRepository.InvoicePendingList.isEmpty &&
                    _invoiceRepository.InvoiceDueList.isEmpty &&
                    _invoiceRepository.InvoiceDepositList.isEmpty &&
                    _invoiceRepository.paidInvoiceList.isEmpty)
                ? const EmptyInvoice()
                : const AvailableInvoice();
      case 4:
      default:
        return const More();
    }
  }
}

class _Item {
  const _Item({
    required this.title,
    required this.icon,
    required this.inactiveIcon,
  });

  final String title, icon, inactiveIcon;
}
