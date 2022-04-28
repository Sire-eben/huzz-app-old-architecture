import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzz/Repository/auth_respository.dart';
import 'package:huzz/Repository/business_respository.dart';
import 'package:huzz/Repository/team_repository.dart';
import 'package:huzz/app/screens/widget/no_team_widget.dart';
import 'package:huzz/app/screens/widget/team_widget.dart';
import 'package:huzz/colors.dart';
import 'package:random_color/random_color.dart';
import 'add_member.dart';

class MyTeam extends StatefulWidget {
  const MyTeam({Key? key}) : super(key: key);

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  final controller = Get.find<AuthRepository>();
  final _teamController = Get.find<TeamRepository>();
  final _businessController = Get.find<BusinessRespository>();
  RandomColor _randomColor = RandomColor();

  final items = [
    'Owner',
    'Writer',
    'Admin',
  ];

  String? values;
  late String firstName, lastName;

  @override
  void initState() {
    firstName = controller.user!.firstName!;
    lastName = controller.user!.lastName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = _businessController.selectedBusiness.value;

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColor().backgroundColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Row(
            children: [
              Text(
                'My Team',
                style: TextStyle(
                  color: AppColor().backgroundColor,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColor().whiteColor,
        floatingActionButton: value!.teamId == null
            ? Container()
            : FloatingActionButton.extended(
                onPressed: () {
                  Get.to(() => AddMember());
                },
                icon: Icon(Icons.add),
                backgroundColor: AppColor().backgroundColor,
                label: Text(
                  'Add new member',
                  style: TextStyle(
                      fontFamily: 'InterRegular',
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
        body: value.teamId == null
            ? NoTeamWidget()
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _teamController.onlineBusinessTeam.length,
                        itemBuilder: (context, index) {
                          var item = _teamController.onlineBusinessTeam[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TeamsWidget(
                              name: item.email == null
                                  ? '$firstName $lastName'
                                  : item.email!,
                              position: 'Owner',
                              status: Container(),
                            ),
                          );
                        },
                      ),
                    ),
                    // TeamsWidget(
                    //   name: 'Olatunde Joshua',
                    //   position: 'Owner',
                    //   status: Container(),
                    // ),
                    // SizedBox(height: 10),
                    // TeamsWidget(
                    //   name: 'Hassan Tunmise',
                    //   position: 'Admin',
                    //   status: Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(80),
                    //         border: Border.all(
                    //             width: 1, color: AppColor().orangeBorderColor),
                    //         color: AppColor().orangeBorderColor.withOpacity(0.2)),
                    //     child: Text(
                    //       'Pending',
                    //       style: TextStyle(
                    //           fontSize: 6,
                    //           color: AppColor().orangeBorderColor,
                    //           fontFamily: 'InterRegular',
                    //           fontWeight: FontWeight.w400),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                    // TeamsWidget(
                    //   name: 'Akinlose Damilare',
                    //   position: 'Writer',
                    //   status: Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(80),
                    //         border: Border.all(
                    //             width: 1, color: AppColor().backgroundColor),
                    //         color: AppColor().backgroundColor.withOpacity(0.2)),
                    //     child: Text(
                    //       'Invited',
                    //       style: TextStyle(
                    //           fontSize: 6,
                    //           color: AppColor().backgroundColor,
                    //           fontFamily: 'InterRegular',
                    //           fontWeight: FontWeight.w400),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
      );
    });
  }

  Widget buildEditTeam() =>
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
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 6,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Edit Team',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "InterRegular",
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Select Item',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'InterRegular'),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 2, color: AppColor().backgroundColor)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: values,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor().backgroundColor,
                    ),
                    iconSize: 30,
                    items: items.map(buildEditItem).toList(),
                    onChanged: (value) => myState(() {
                      value = value;
                    }),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              InkWell(
                onTap: () async {
                  // if (_transactionController.addingTransactionStatus !=
                  //     AddingTransactionStatus.Loading) {
                  //   print('Amount to be updated: ' +
                  //       _transactionController.amountController!.text
                  //           .replaceAll('₦', ''));

                  //   var result =
                  //       await _transactionController.updateTransactionHistory(
                  //           transactionModel!.id!,
                  //           transactionModel!.businessId!,
                  //           (paymentType == 0)
                  //               ? _transactionController
                  //                   .amountController!.text
                  //                   .replaceAll('₦', '')
                  //                   .replaceAll(',', '')
                  //               : (transactionModel!.balance ?? 0),
                  //           (paymentType == 0) ? "DEPOSIT" : "FULLY_PAID");

                  //   if (result != null) {
                  //     print("result is not null");
                  //     transactionModel = result;
                  //     setState(() {});
                  //   } else {
                  //     print("result is null");
                  //   }
                  //   transactionModel =
                  //       _transactionController.getTransactionById(
                  //           widget.item!.businessTransactionId!);
                  //   setState(() {});
                  // }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.01),
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child:
                      // (_team.addingTransactionStatus ==
                      //         AddingTransactionStatus.Loading)
                      //     ? Container(
                      //         width: 30,
                      //         height: 30,
                      //         child: Center(
                      //             child: CircularProgressIndicator(
                      //                 color: Colors.white)),
                      //       )
                      //     :
                      Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'InterRegular'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      });

  DropdownMenuItem<String> buildEditItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 14),
        ),
      );
}
