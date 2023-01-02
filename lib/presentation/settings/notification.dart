import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzz/data/repository/auth_respository.dart';
import 'package:huzz/core/constants/app_themes.dart';
import 'package:huzz/data/model/notification_model.dart';
import 'package:random_color/random_color.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final RandomColor _randomColor = RandomColor();
  final controller = Get.find<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.backgroundColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'Notifications',
            style: GoogleFonts.inter(
              color: AppColors.backgroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: notificationList.isNotEmpty
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/notification_bell.svg",
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Messages',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Your notifications will appear here',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: notificationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = notificationList[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _randomColor.randomColor()),
                                  child: SvgPicture.asset(item.image!)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.message!,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    item.time!,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor
                                            .withOpacity(0.5),
                                        fontSize: 8),
                                  ),
                                  Text(
                                    item.time!,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor
                                            .withOpacity(0.5),
                                        fontSize: 8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ));
  }
}
